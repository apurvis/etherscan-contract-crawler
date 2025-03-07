pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@positionex/posi-token/contracts/VestingScheduleLogic.sol";
import "./interfaces/IUniswapV2Router.sol";
import "./interfaces/IUniswapV2Factory.sol";
import "./interfaces/IPosiStakingManager.sol";
import "./interfaces/IUniswapV2Pair.sol";
import "./library/UserInfo.sol";
import "./library/SwapMath.sol";
import "./library/TwapLogic.sol";
import "./interfaces/IPositionReferral.sol";
import "./interfaces/IVaultReferralTreasury.sol";
import "./interfaces/ISpotHouse.sol";

/*
A vault that helps users stake in POSI farms and pools more simply.
Supporting auto compound in Single Staking Pool.
*/

contract BUSDPosiVaultV2 is Initializable, ReentrancyGuardUpgradeable, OwnableUpgradeable, VestingScheduleLogic {
    using SafeMath for uint256;
    using UserInfo for UserInfo.Data;
    using TwapLogic for TwapLogic.ReserveSnapshot[];

    // MAINNET
    IERC20 public posi;
    IERC20 public busd;
    IUniswapV2Router02 public router;
    IUniswapV2Factory public factory;
    IPosiStakingManager public posiStakingManager;
    IPositionReferral public positionReferral;
    uint256 public constant POSI_BUSD_PID = 0;
    //
    //    // TESTNET
    //    IERC20 public posi = IERC20(0xb228359B5D83974F47655Ee41f17F3822A1fD0DD);
    //    IERC20 public busd = IERC20(0x787cF64b9F6E3d9E120270Cb84e8Ba1Fe8C1Ae09);
    //    IUniswapV2Router02 public router = IUniswapV2Router02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
    //    IUniswapV2Factory public factory = IUniswapV2Factory(0x6725F303b657a9451d8BA641348b6761A6CC7a17);
    //    IPosiStakingManager public posiStakingManager = IPosiStakingManager(0xD0A6C46316f789Ba3bdC320ebCC9AFdaE752fd73);
    //    IPositionReferral public positionReferral;
    //    uint256 public constant POSI_BUSD_PID = 2;

    uint256 public constant MAX_INT = 115792089237316195423570985008687907853269984665640564039457584007913129639935;

    mapping(address => UserInfo.Data) public userInfo;
    uint256 public totalSupply;
    uint256 public pendingRewardPerTokenStored;
    uint256 public lastUpdatePoolPendingReward;
    uint256 public lastCompoundRewardPerToken;

    uint256 public referralCommissionRate;
    uint256 public percentFeeForCompounding;

    IVaultReferralTreasury public vaultReferralTreasury;

    ISpotHouse public spotHouse;
    IPairManager public pairManager;
    mapping (address => mapping(VestingFrequencyHelper.Frequency => VestingData[])) public vestingSchedule;
    TwapLogic.ReserveSnapshot[] public reserveSnapshots;
    TwapLogic.ReserveSnapshot[] public res0Snapshots;
    TwapLogic.ReserveSnapshot[] public newReserveSnapshots;
    mapping(address => bool) public isMigratedUser;

    event Deposit(address account, uint256 amount);
    event Withdraw(address account, uint256 amount);
    event Harvest(address account, uint256 amount);
    event Compound(address caller, uint256 reward);
    event RewardPaid(address account, uint256 reward);
    event ReferralCommissionPaid(
        address indexed user,
        address indexed referrer,
        uint256 commissionAmount
    );

    modifier noCallFromContract {
        // due to flashloan attack
        // we don't like contract calls to our vault
        require(tx.origin == msg.sender, "no contract call");
        _;
    }

    modifier updateReward(address account) {

        pendingRewardPerTokenStored = pendingRewardPerToken();
        if(pendingRewardPerTokenStored != 0){
            lastUpdatePoolPendingReward = totalPoolPendingRewards();
        }

        if(account != address(0)){
            if(lastCompoundRewardPerToken >= userInfo[account].pendingRewardPerTokenPaid){
                // set user earned
                userInfo[account].updateEarnedRewards(_earned(account));
            }
            userInfo[account].updatePendingReward(
                _pendingEarned(account),
                pendingRewardPerTokenStored
            );
        }
        _;
    }

    modifier waitForCompound {
        require(!canCompound(), "Call compound first");
        _;
    }

    function initialize(address _posi, address _busd, address _router, address _factory, address _posiStakingManager, address _vaultReferralTreasury) public initializer {
        __ReentrancyGuard_init();
        __Ownable_init();
        /*
        MAINNET
        posi = IERC20(0x5CA42204cDaa70d5c773946e69dE942b85CA6706);
        busd = IERC20(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);
        router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        factory = IUniswapV2Factory(0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73);
        posiStakingManager = IPosiStakingManager(0x0C54B0b7d61De871dB47c3aD3F69FEB0F2C8db0B);
        */
        posi = IERC20(_posi);
        busd = IERC20(_busd);
        router = IUniswapV2Router02(_router);
        factory = IUniswapV2Factory(_factory);
        posiStakingManager = IPosiStakingManager(_posiStakingManager);
        vaultReferralTreasury = IVaultReferralTreasury(_vaultReferralTreasury);
        percentFeeForCompounding = 50; //default 5%
    }

    function canCompound() public view returns (bool) {
        return posiStakingManager.canHarvest(POSI_BUSD_PID, address(this));
    }

    function nearestCompoundingTime() public view returns (uint256 time) {
        (,,,time) = posiStakingManager.userInfo(POSI_BUSD_PID, address(this));
    }

    function balanceOf(address user) public view returns (uint256) {
        return getReserveInAmount1ByLP(userInfo[user].amount);
    }

    function lpOf(address user) public view returns (uint256) {
        return userInfo[user].amount;
    }


    function totalPoolPendingRewards() public view returns (uint256) {
        return posiStakingManager.pendingPosition(POSI_BUSD_PID, address(this));
    }

    // total user's rewards: pending + earned
    function pendingEarned(address account) public view returns (uint256) {
        return _convertEarnedTokenToPOSI(account, _pendingEarned(account));
    }

    // returns PTX amount
    function _pendingEarned(address account) internal view returns (uint256) {
        UserInfo.Data memory _userInfo = userInfo[account];
        uint256 _pendingRewardPerToken = pendingRewardPerToken();
        if(lastCompoundRewardPerToken >= _userInfo.pendingRewardPerTokenPaid){
            // only count for the next change
            return lpOf(account).mul(
                _pendingRewardPerToken
                .sub(lastCompoundRewardPerToken)
            )
            .div(1e18);
        }else{
            return lpOf(account).mul(
                _pendingRewardPerToken
                .sub(_userInfo.pendingRewardPerTokenPaid)
            )
            .div(1e18)
            .add(_userInfo.pendingRewards);
        }
    }

    // total user's rewards ready to withdraw
    function earned(address account) public view returns (uint256) {
        return _convertEarnedTokenToPOSI(account, _earned(account));
    }

    // returns PTX amount
    function _earned(address account) internal view returns (uint256) {
        UserInfo.Data memory _userInfo = userInfo[account]; // save gas
        if(lastCompoundRewardPerToken < _userInfo.pendingRewardPerTokenPaid) return _userInfo.rewards;
        return lpOf(account).mul(
            lastCompoundRewardPerToken
            .sub(_userInfo.pendingRewardPerTokenPaid)
        )
        .div(1e18)
        .add(_userInfo.pendingRewards)
        .add(_userInfo.rewards);
    }

    function pendingRewardPerToken() public view returns (uint256) {
        if (totalSupply == 0) {
            return 0;
        }
        return pendingRewardPerTokenStored.add(
            totalPoolPendingRewards()
            .sub(lastUpdatePoolPendingReward)
            .mul(1e18)
            .div(totalSupply)
        );
    }

    function getSwappingPair() internal view returns (IUniswapV2Pair) {
        return IUniswapV2Pair(
            factory.getPair(address(posi), address(busd))
        );
    }

    function updatePositionReferral(IPositionReferral _positionReferral) external onlyOwner {
        positionReferral = _positionReferral;
    }

    function updateReferralCommissionRate(uint256 _rate) external onlyOwner {
        require(_rate <= 2000, "max 20%");
        referralCommissionRate = _rate;
    }

    function updatePercentFeeForCompounding(uint256 _rate) external onlyOwner {
        require(_rate <= 100, "max 10%");
        percentFeeForCompounding = _rate;
    }


    function approve() public {
        posi.approve(address(posiStakingManager), MAX_INT);
        posi.approve(address(router), MAX_INT);
        busd.approve(address(router), MAX_INT);
        getSwappingPair().approve(address(posiStakingManager), MAX_INT);
        getSwappingPair().approve(address(router), MAX_INT);
        IERC20 _rewardToken = pairManager.getBaseAsset();
        _rewardToken.approve(address(spotHouse), type(uint256).max);
    }

    function rewardToken() public view returns (IERC20){
        return pairManager.getBaseAsset();
    }

    function getReserveInAmount1ByLP(uint256 lp) public view returns (uint256 amount) {
        IUniswapV2Pair pair = getSwappingPair();
        uint256 balance0 = posi.balanceOf(address(pair));
        uint256 balance1 = busd.balanceOf(address(pair));
        uint256 _totalSupply = pair.totalSupply();
        uint256 amount0 = lp.mul(balance0) / _totalSupply;
        uint256 amount1 = lp.mul(balance1) / _totalSupply;
        // convert amount0 -> amount1
        amount = amount1.add(amount0.mul(balance1).div(balance0));
    }

    /**
    * return lp Needed to get back total amount in amount 1
    * exp. amount = 1000 BUSD
    * lpNeeded returns 10
    * once remove liquidity, 10 LP will get back 500 BUSD and an amount in POSI corresponding to 500 BUSD
    */
    function getLPTokenByAmount1(uint256 amount) internal view returns (uint256 lpNeeded) {
        (, uint256 res1,) = getSwappingPair().getReserves();
        lpNeeded = amount.mul(getSwappingPair().totalSupply()).div(res1).div(2);
    }

    /**
    * return lp Needed to get back total amount in amount 0
    * exp. amount = 1000 POSI
    * lpNeeded returns 10
    * once remove liquidity, 10 LP will get back 500 POSI and an amount in BUSD corresponding to 500 POSI
    */
    function getLPTokenByAmount0(uint256 amount) internal view returns (uint256 lpNeeded) {
        uint256 res0 = res0Snapshots.getReserveTwapPrice(3 days);
        lpNeeded = amount.mul(getSwappingPair().totalSupply()).div(res0).div(2);
    }

    function deposit(uint256 amount, address referrer) external updateReward(msg.sender) nonReentrant noCallFromContract waitForCompound {
        // function to deposit BUSD
        busd.transferFrom(msg.sender, address(this), amount);
        (, uint256 res1,) = getSwappingPair().getReserves();
        uint256 amountToSwap = SwapMath.calculateSwapInAmount(res1, amount);
        uint256 posiOut = swapBusdToPosi(amountToSwap);
        uint256 amountLeft = amount.sub(amountToSwap);
        (,uint256 busdAdded,uint256 liquidityAmount) = router.addLiquidity(
            address(posi),
            address(busd),
            posiOut,
            amountLeft,
            0,
            0,
            address(this),
            block.timestamp
        );
        _depositLP(msg.sender, liquidityAmount, referrer);
        // trasnfer back amount left
        if(amount > busdAdded+amountToSwap){
            busd.transfer(msg.sender, amount - (busdAdded + amountToSwap));
        }
    }

    function depositTokenPair(uint256 amountPosi, uint256 amountBusd, address referrer) external updateReward(msg.sender) nonReentrant noCallFromContract waitForCompound {
        busd.transferFrom(msg.sender, address(this), amountBusd);
        uint256 balanceOfPosiBeforeTrasnfer = posi.balanceOf(address(this));
        posi.transferFrom(msg.sender, address(this), amountPosi);
        uint256 balanceOfPosiAfterTransfer = posi.balanceOf(address(this));
        uint256 amountPosiReceived = balanceOfPosiAfterTransfer - balanceOfPosiBeforeTrasnfer;
        // note posiAdded is might reduced by ~1%
        (uint256 posiAdded, uint256 busdAdded, uint256 liquidityAmount) = router.addLiquidity(
            address(posi),
            address(busd),
            amountPosiReceived,
            amountBusd,
            0,
            0,
            address(this),
            block.timestamp
        );
        // transfer back amount that didn't add to the pool
        if(amountPosiReceived.mul(99).div(100) > posiAdded){
            uint256 amountLeft = amountPosiReceived.mul(99).div(100) - posiAdded;
            if(posi.balanceOf(address(this)) >= amountLeft)
                posi.transfer(msg.sender, amountLeft);
        }
        if(amountBusd > busdAdded){
            busd.transfer(msg.sender, amountBusd - busdAdded);
        }
        _depositLP(msg.sender, liquidityAmount, referrer);
    }

    function depositLP(uint256 amount, address referrer) external updateReward(msg.sender) nonReentrant noCallFromContract waitForCompound {
        getSwappingPair().transferFrom(msg.sender, address(this), amount);
        _depositLP(msg.sender, amount, referrer);
    }

    function _depositLP(address account, uint256 liquidityAmount, address referrer) internal {
        if (
            address(positionReferral) != address(0) &&
            referrer != address(0) &&
            referrer != account
        ) {
            positionReferral.recordReferral(account, referrer);
        }
        //stake in farms
        depositStakingPool(liquidityAmount);
        if(userInfo[account].amount == 0 && !isMigratedUser[account]){
            isMigratedUser[account] = true;
        }
        //set state
        userInfo[account].deposit(liquidityAmount);
        totalSupply = totalSupply.add(liquidityAmount);
        emit Deposit(account, liquidityAmount);
    }

    function withdraw(uint256 amount, bool isReceiveBusd) external updateReward(msg.sender) nonReentrant noCallFromContract waitForCompound {
        uint256 lpAmountNeeded;
        if(amount >= balanceOf(msg.sender)){
            // withdraw all
            lpAmountNeeded = lpOf(msg.sender);
        }else{
            //calculate LP needed that corresponding with amount
            lpAmountNeeded = getLPTokenByAmount1(amount);
            if(lpAmountNeeded >= lpOf(msg.sender)){
                // if >= current lp, use all lp
                lpAmountNeeded = lpOf(msg.sender);
            }
        }
        //withdraw from farm then remove liquidity
        posiStakingManager.withdraw(POSI_BUSD_PID, lpAmountNeeded);
        (uint256 amountA,uint256 amountB) = removeLiquidity(lpAmountNeeded);
        if(isReceiveBusd){
            // send as much as we can
            // doesn't guarantee enough $amount
            busd.transfer(msg.sender, swapPosiToBusd(amountA).add(amountB));
        }else{
            posi.transfer(msg.sender, amountA);
            busd.transfer(msg.sender, amountB);
        }
        // update state
        userInfo[msg.sender].withdraw(lpAmountNeeded);
        totalSupply = totalSupply.sub(lpAmountNeeded);
        emit Withdraw(msg.sender, lpAmountNeeded);
    }

    function withdrawLP(uint256 lpAmount) external updateReward(msg.sender) nonReentrant waitForCompound {
        require(userInfo[msg.sender].amount >= lpAmount, "INSUFFICIENT_LP");
        posiStakingManager.withdraw(POSI_BUSD_PID, lpAmount);
        getSwappingPair().transfer(msg.sender, lpAmount);
        userInfo[msg.sender].withdraw(lpAmount);
        emit Withdraw(msg.sender, lpAmount);
    }

    // emergency only! withdraw don't care about rewards
    function emergencyWithdraw(uint256 lpAmount) external nonReentrant waitForCompound {
        require(userInfo[msg.sender].amount >= lpAmount, "INSUFFICIENT_LP");
        posiStakingManager.withdraw(POSI_BUSD_PID, lpAmount);
        getSwappingPair().transfer(msg.sender, lpAmount);
        userInfo[msg.sender].withdraw(lpAmount);
        emit Withdraw(msg.sender, lpAmount);
    }

    function getLpNeeded(address user) public view returns (uint256) {
        uint256 reward = earned(user);
        return getLPTokenByAmount0(reward);
    }

    function harvest(bool isReceiveBusd) external updateReward(msg.sender) nonReentrant noCallFromContract waitForCompound {
        // function to harvest rewards
        uint256 reward = earned(msg.sender);
        if (reward > 0) {
            // set migrated user
            if(!isMigratedUser[msg.sender]){
                isMigratedUser[msg.sender] = true;
            }

            userInfo[msg.sender].harvest(block.number);
            //get corresponding amount in LP
            uint256 lpNeeded = getLPTokenByAmount0(reward);
            posiStakingManager.withdraw(POSI_BUSD_PID, lpNeeded);
            if(isReceiveBusd){
                // send 5% only
                // then lock 95%
                _addSchedules(msg.sender, lpNeeded.mul(95).div(100));
                lpNeeded = lpNeeded.mul(5).div(100);
            }
            (uint256 amountPosi,uint256 amountBusd) = removeLiquidity(lpNeeded);
            if(isReceiveBusd) {
                router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
                    amountPosi,
                    0,
                    getPosiBusdRoute(),
                    msg.sender,
                    block.timestamp
                );
                busd.transfer(msg.sender, amountBusd);
            }else{
                router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
                    amountBusd,
                    0,
                    getBusdPosiRoute(),
                    msg.sender,
                    block.timestamp
                );
                posi.transfer(msg.sender, amountPosi);
            }
            payReferralCommission(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }
    }

    function compound() external updateReward(address(0)) nonReentrant {
        // function to compound for pool
        bool _canCompound  = canCompound();
        if (_canCompound) {
            lastCompoundRewardPerToken = pendingRewardPerToken();
            // harvesting by deposit 0
            depositStakingPool(0);
            uint256 amountCollected = rewardToken().balanceOf(address(this));
            uint256 rewardForCaller = amountCollected.mul(percentFeeForCompounding).div(1000);
            // burn %
            uint256 rewardForPool = amountCollected.sub(rewardForCaller);
            // swap -> add liquidity -> stake back to pool
            // convert Reward Token -> POSI
            uint256 posiRewardForPool = _convertRewardTokenToPosi(rewardForPool);
            if(posiRewardForPool > 0){
                (uint256 res0,,) = getSwappingPair().getReserves();
                uint256 posiAmountToSwap = SwapMath.calculateSwapInAmount(res0, posiRewardForPool);
                uint256 busdOut = swapPosiToBusd(posiAmountToSwap);
                (res0,,) = getSwappingPair().getReserves();
                res0Snapshots.addReserveSnapshot(uint128(res0));
                (,, uint256 liquidityAmount) = router.addLiquidity(
                    address(posi),
                    address(busd),
                    posiRewardForPool.sub(posiAmountToSwap),
                    busdOut,
                    0,
                    0,
                    address(this),
                    block.timestamp
                );
                depositStakingPool(liquidityAmount);
            }
            if(rewardForCaller > 0)
                posi.transfer(msg.sender, rewardForCaller);
            lastUpdatePoolPendingReward = 0;
            emit Compound(msg.sender, posiRewardForPool);
        }else{
            revert("not time to compound");
        }
    }

    function resetUpdatePoolReward() external onlyOwner {
        lastUpdatePoolPendingReward = 0;
    }

    function pendingPositionNextCompound() public view returns (uint256){
        return posiStakingManager.pendingPosition(POSI_BUSD_PID, address(this)).mul(5).div(100);
    }

    function rewardForCompounder() external view returns (uint256){
        // only 5%
        return pendingPositionNextCompound().mul(percentFeeForCompounding).div(1000);
    }

    function payReferralCommission(address _user, uint256 _pending) internal {
        if (
            address(positionReferral) != address(0)
            && referralCommissionRate > 0
        ) {
            address referrer = positionReferral.getReferrer(_user);
            uint256 commissionAmount = _pending.mul(referralCommissionRate).div(
                10000
            );
            if (referrer != address(0) && commissionAmount > 0) {
                if(vaultReferralTreasury.payReferralCommission(referrer, commissionAmount))
                    emit ReferralCommissionPaid(_user, referrer, commissionAmount);
            }
        }
    }

    function swapBusdToPosi(uint256 amountToSwap) internal returns (uint256 amountOut) {
        uint256 posiBalanceBefore = posi.balanceOf(address(this));
        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            getBusdPosiRoute(),
            address(this),
            block.timestamp
        );
        amountOut = posi.balanceOf(address(this)).sub(posiBalanceBefore);
    }

    function swapPosiToBusd(uint256 amountToSwap) internal returns (uint256 amountOut) {
        uint256 busdBalanceBefore = busd.balanceOf(address(this)); // remove for testing
        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            getPosiBusdRoute(),
            address(this),
            block.timestamp
        );
        amountOut = busd.balanceOf(address(this)).sub(busdBalanceBefore);
    }

    function removeLiquidity(uint256 lpAmount) internal returns (uint256 amountPosi, uint256 amountBusd){
        uint256 posiBalanceBefore = posi.balanceOf(address(this));
        (,amountBusd) = router.removeLiquidity(
            address(posi),
            address(busd),
            lpAmount,
            0,
            0,
            address(this),
            block.timestamp
        );
        amountPosi = posi.balanceOf(address(this)).sub(posiBalanceBefore);
    }

    function depositStakingPool(uint256 amount) internal {
        posiStakingManager.deposit(POSI_BUSD_PID, amount, address(vaultReferralTreasury));
    }


    function getBusdPosiRoute() private view returns (address[] memory paths) {
        paths = new address[](2);
        paths[0] = address(busd);
        paths[1] = address(posi);
    }

    function getPosiBusdRoute() private view returns (address[] memory paths) {
        paths = new address[](2);
        paths[0] = address(posi);
        paths[1] = address(busd);
    }

    // returns the PTX/POSI price by pip
    function getPTXPrice(address account) public view returns (uint256) {
        // new user return the new reserveSnapshots
        if(isMigratedUser[account]){
            return newReserveSnapshots.getReserveTwapPrice(259200);
        }else{
            return 10000;
        }
    }

    function getTwapPip(uint256 itv) public view returns (uint256){
        return reserveSnapshots.getReserveTwapPrice(itv);
    }

    function getTwapRes0(uint256 itv) public view returns (uint256){
        return res0Snapshots.getReserveTwapPrice(itv);
    }

    function __SpotManagerModule_init(address _spotHouse, address _pairManager) internal {
        spotHouse = ISpotHouse(_spotHouse);
        pairManager = IPairManager(_pairManager);
    }

    function _sellRewardTokenForPOSI(uint256 _amount) internal returns (uint256 posiAmount) {
        IERC20 _posi = pairManager.getQuoteAsset();
        uint256 _balanceBefore = _posi.balanceOf(address(this));
        spotHouse.openMarketOrder(pairManager, ISpotHouse.Side.SELL, _amount);
        uint128 _pipAfter = pairManager.getCurrentPip();
        reserveSnapshots.addReserveSnapshot(10000);
        uint256 _balanceAfter = _posi.balanceOf(address(this));
        posiAmount = _balanceAfter - _balanceBefore;
    }


    function _convertRewardTokenToPosi(uint256 rewardAmount) private returns (uint256 posiAmount) {
        if(rewardAmount == 0) return 0;
        // sell market reward token for posi
        return _sellRewardTokenForPOSI(rewardAmount);
    }

    function _transferLockedToken(address _to, uint192 _amount) internal override {
        (uint256 amountPosi,uint256 amountBusd) = removeLiquidity(_amount);
        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            amountPosi,
            0,
            getPosiBusdRoute(),
            _to,
            block.timestamp
        );
        busd.transfer(_to, amountBusd);
    }

    function _getVestingSchedules(address user, VestingFrequencyHelper.Frequency freq) internal view override returns (VestingData[] memory) {
        return  vestingSchedule[user][freq];
    }

    // override by convert amount to token 1
    function getVestingSchedules(address user, VestingFrequencyHelper.Frequency freq) public override view returns (VestingData[] memory) {
        VestingData[] memory data = vestingSchedule[user][freq];
        for(uint i = 0; i < data.length; i++) {
            data[i].amount = uint192(getReserveInAmount1ByLP(uint256(data[i].amount)));
        }
        return data;
    }

    function init_v2(address newSpotHouse, address newSpotManager, address newStakingManager) public onlyOwner {
        __SpotManagerModule_init(newSpotHouse, newSpotManager);
        IPosiStakingManager oldStakingManager = posiStakingManager;
        posiStakingManager = IPosiStakingManager(newStakingManager);
        approve();
        reserveSnapshots.add(pairManager.getCurrentPip(), uint64(block.timestamp), uint64(block.number));
        (uint256 res0,,) = getSwappingPair().getReserves();
        res0Snapshots.add(uint128(res0), uint64(block.timestamp), uint64(block.number));
        (uint256 stakingAmount,,,) = oldStakingManager.userInfo(POSI_BUSD_PID, address(this));
        // withdraw old one
        oldStakingManager.withdraw(POSI_BUSD_PID, stakingAmount);
        // deposit new one
        posiStakingManager.deposit(POSI_BUSD_PID, stakingAmount, address(vaultReferralTreasury));
    }

    function correctReserves(uint256 fromIndex, uint256 toIndex, uint256[] memory pips) public onlyOwner {
        uint256 j = 0;
        for(uint256 i = fromIndex; i < toIndex; i++){
            reserveSnapshots[i].pip = uint128(pips[j]);
            j++;
        }
    }

    // Vesting override

    function _removeFirstSchedule(address user, VestingFrequencyHelper.Frequency freq) internal override {
        _popFirstSchedule(vestingSchedule[user][freq]);
    }

    function _lockVestingSchedule(address _to, VestingFrequencyHelper.Frequency _freq, uint256 _amount) internal override {
        vestingSchedule[_to][_freq].push(_newVestingData(_amount, _freq));
    }
    // use for mocking test
    function _setVestingTime(address user, uint8 freq, uint256 index, uint256 timestamp) internal {
        vestingSchedule[user][VestingFrequencyHelper.Frequency(freq)][index].vestingTime = uint64(timestamp);
    }

    function _convertEarnedTokenToPOSI(address account, uint256 _baseAmount) private view returns (uint256){
        (,uint128 _basisPoint) = pairManager.getCurrentPipAndBasisPoint();
        // Twap 3 days
        uint256 _twapPip = getPTXPrice(account);
        return uint256(uint128(_baseAmount) * uint128(_twapPip) / _basisPoint);
    }
}
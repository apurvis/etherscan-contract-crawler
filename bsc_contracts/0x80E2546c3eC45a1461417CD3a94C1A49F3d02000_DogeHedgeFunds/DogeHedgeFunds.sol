/**
 *Submitted for verification at BscScan.com on 2022-10-04
*/

/**
 *Submitted for verification at bscscan.com on 2022-10-04
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

interface IToken {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }


  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }

  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}

contract DogeHedgeFunds {
    using SafeMath for uint256;

    IToken public token_USDC;
	//address erctoken = 0x47C67336cf1Bfc86b585056628C797e54daF1B7A; /** custom tUSDC **/
    address erctoken = 0xbA2aE424d960c26247Dd6c32edC70B295c744C43; /** DOGE BEP20 **/
    uint256 public EGGS_TO_HIRE_1MINERS = 1080000;
    uint256 public PERCENTS_DIVIDER = 1000;
    uint256 public REFERRAL = 80;
    uint256 public TAX = 9;
    uint256 public MARKET_EGGS_DIVISOR = 2; // 50%
    uint256 public MARKET_EGGS_DIVISOR_SELL = 1; // 100%

    uint256 public MIN_INVEST_LIMIT = 10 * 1e6; /** 10 USDC  **/
    uint256 public WALLET_DEPOSIT_LIMIT = 10000 * 1e6; /** 10000 USDC  **/

	uint256 public COMPOUND_BONUS = 25; /** 2.5% **/
	uint256 public COMPOUND_BONUS_MAX_TIMES = 10; /** 10 times / 5 days. **/
    uint256 public COMPOUND_STEP = 12 * 60 * 60; /** every 12 hours. **/

    uint256 public WITHDRAWAL_TAX = 600;
    uint256 public COMPOUND_FOR_NO_TAX_WITHDRAWAL = 5; // compound days, for no tax withdrawal.

    uint256 public totalStaked;
    uint256 public totalDeposits;
    uint256 public totalCompound;
    uint256 public totalRefBonus;
    uint256 public totalWithdrawn;

    uint256 public marketEggs;
    uint256 PSN = 10000;
    uint256 PSNH = 5000;
    bool public contractStarted;
    bool public blacklistActive = true; //set false after launch
    mapping(address => bool) public Blacklisted;

	uint256 public CUTOFF_STEP = 48 * 60 * 60; /** 48 hours  **/
	uint256 public WITHDRAW_COOLDOWN = 4 * 60 * 60; /** 4 hours  **/

    address public owner;
    address public dev1;
    address public dev2;
    address public dev3;
    address public prtnr1;
    address public prtnr2;
    address public mkt;

    struct User {
        uint256 initialDeposit;
        uint256 userDeposit;
        uint256 miners;
        uint256 claimedEggs;
        uint256 lastHatch;
        address referrer;
        uint256 referralsCount;
        uint256 referralEggRewards;
        uint256 totalWithdrawn;
        uint256 dailyCompoundBonus;
        uint256 lastWithdrawTime;
    }

    mapping(address => User) public users;

    constructor(address _dev1, address _dev2, address _dev3, address _prtnr1, address _prtnr2, address _mkt) {
		require(!isContract(_dev1) && !isContract(_dev2) && !isContract(_dev3) && !isContract(_prtnr1) && !isContract(_prtnr2) && !isContract(_mkt));
        owner = msg.sender;
        dev1 = _dev1;
        dev2 = _dev2;
        dev3 = _dev3;
        prtnr1 = _prtnr1;
        prtnr2 = _prtnr2;
        mkt = _mkt;
        token_USDC = IToken(erctoken);
    }

	function isContract(address addr) internal view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }

    function setblacklistActive(bool isActive) public{
        require(msg.sender == owner, "Admin use only.");
        blacklistActive = isActive;
    }

    function blackListWallet(address Wallet, bool isBlacklisted) public{
        require(msg.sender == owner, "Admin use only.");
        Blacklisted[Wallet] = isBlacklisted;
    }

    function blackMultipleWallets(address[] calldata Wallet, bool isBlacklisted) public{
        require(msg.sender == owner, "Admin use only.");
        for(uint256 i = 0; i < Wallet.length; i++) {
            Blacklisted[Wallet[i]] = isBlacklisted;
        }
    }

    function checkIfBlacklisted(address Wallet) public view returns(bool blacklisted){
        require(msg.sender == owner, "Admin use only.");
        blacklisted = Blacklisted[Wallet];
    }

    function hireMoreFarmers(bool isCompound) public {
        User storage user = users[msg.sender];
        require(contractStarted, "Contract not yet Started.");

        uint256 eggsUsed = getMyEggs();
        uint256 eggsForCompound = eggsUsed;

        if(isCompound) {
            uint256 dailyCompoundBonus = getDailyCompoundBonus(msg.sender, eggsForCompound);
            eggsForCompound = eggsForCompound.add(dailyCompoundBonus);
            uint256 eggsUsedValue = calculateEggSell(eggsForCompound);
            user.userDeposit = user.userDeposit.add(eggsUsedValue);
            totalCompound = totalCompound.add(eggsUsedValue);
        } 

        if(block.timestamp.sub(user.lastHatch) >= COMPOUND_STEP) {
            if(user.dailyCompoundBonus < COMPOUND_BONUS_MAX_TIMES) {
                user.dailyCompoundBonus = user.dailyCompoundBonus.add(1);
            }
        }
        
        user.miners = user.miners.add(eggsForCompound.div(EGGS_TO_HIRE_1MINERS));
        user.claimedEggs = 0;
        user.lastHatch = block.timestamp;

        marketEggs = marketEggs.add(eggsUsed.div(MARKET_EGGS_DIVISOR));
    }

    function sellCrops() public{
        require(contractStarted, "Contract not yet Started.");

        if (blacklistActive) {
            require(!Blacklisted[msg.sender], "Address is blacklisted.");
        }

        User storage user = users[msg.sender];
        uint256 hasEggs = getMyEggs();
        uint256 eggValue = calculateEggSell(hasEggs);
        
        /** 
            if user compound < to mandatory compound days**/
        if(user.dailyCompoundBonus < COMPOUND_FOR_NO_TAX_WITHDRAWAL){
            //daily compound bonus count will not reset and eggValue will be deducted with 60% feedback tax.
            eggValue = eggValue.sub(eggValue.mul(WITHDRAWAL_TAX).div(PERCENTS_DIVIDER));
        }else{
            //set daily compound bonus count to 0 and eggValue will remain without deductions
             user.dailyCompoundBonus = 0;   
        }
        
        user.lastWithdrawTime = block.timestamp;
        user.claimedEggs = 0;  
        user.lastHatch = block.timestamp;
        marketEggs = marketEggs.add(hasEggs.div(MARKET_EGGS_DIVISOR_SELL));
        
        if(getBalance() < eggValue) {
            eggValue = getBalance();
        }

        uint256 eggsPayout = eggValue.sub(payFees(eggValue));
        token_USDC.transfer(msg.sender, eggsPayout);
        user.totalWithdrawn = user.totalWithdrawn.add(eggsPayout);
        totalWithdrawn = totalWithdrawn.add(eggsPayout);
    }

    function hireFarmers(address ref, uint256 amount) public{
        require(contractStarted, "Contract not yet Started.");
        User storage user = users[msg.sender];
        require(amount >= MIN_INVEST_LIMIT, "Mininum investment not met.");
        require(user.initialDeposit.add(amount) <= WALLET_DEPOSIT_LIMIT, "Max deposit limit reached.");
        
        token_USDC.transferFrom(address(msg.sender), address(this), amount);
        uint256 eggsBought = calculateEggBuy(amount, getBalance().sub(amount));
        user.userDeposit = user.userDeposit.add(amount);
        user.initialDeposit = user.initialDeposit.add(amount);
        user.claimedEggs = user.claimedEggs.add(eggsBought);

        if (user.referrer == address(0)) {
            if (ref != msg.sender) {
                user.referrer = ref;
            }

            address upline1 = user.referrer;
            if (upline1 != address(0)) {
                users[upline1].referralsCount = users[upline1].referralsCount.add(1);
            }
        }
                
        if (user.referrer != address(0)) {
            address upline = user.referrer;
            if (upline != address(0)) {
                uint256 refRewards = amount.mul(REFERRAL).div(PERCENTS_DIVIDER);
                token_USDC.transfer(upline, refRewards);
                users[upline].referralEggRewards = users[upline].referralEggRewards.add(refRewards);
                totalRefBonus = totalRefBonus.add(refRewards);
            }
        }

        uint256 eggsPayout = payFees(amount);
        totalStaked = totalStaked.add(amount.sub(eggsPayout));
        totalDeposits = totalDeposits.add(1);
        hireMoreFarmers(false);
    }

    function payFees(uint256 eggValue) internal returns(uint256){
        uint256 tax = eggValue.mul(TAX).div(PERCENTS_DIVIDER);
        token_USDC.transfer(dev1, tax);
        token_USDC.transfer(dev2, tax);
        token_USDC.transfer(dev3, tax);
        token_USDC.transfer(prtnr1, tax);
        token_USDC.transfer(prtnr2, tax);
        token_USDC.transfer(mkt, tax);
        return tax.mul(6);
    }

    function getDailyCompoundBonus(address _adr, uint256 amount) public view returns(uint256){
        if(users[_adr].dailyCompoundBonus == 0) {
            return 0;
        } else {
            uint256 totalBonus = users[_adr].dailyCompoundBonus.mul(COMPOUND_BONUS); 
            uint256 result = amount.mul(totalBonus).div(PERCENTS_DIVIDER);
            return result;
        }
    }

    function getUserInfo(address _adr) public view returns(uint256 _initialDeposit, uint256 _userDeposit, uint256 _miners,
     uint256 _claimedEggs, uint256 _lastHatch, address _referrer, uint256 _referrals,
	 uint256 _totalWithdrawn, uint256 _referralEggRewards, uint256 _dailyCompoundBonus, uint256 _lastWithdrawTime) {
         _initialDeposit = users[_adr].initialDeposit;
         _userDeposit = users[_adr].userDeposit;
         _miners = users[_adr].miners;
         _claimedEggs = users[_adr].claimedEggs;
         _lastHatch = users[_adr].lastHatch;
         _referrer = users[_adr].referrer;
         _referrals = users[_adr].referralsCount;
         _totalWithdrawn = users[_adr].totalWithdrawn;
         _referralEggRewards = users[_adr].referralEggRewards;
         _dailyCompoundBonus = users[_adr].dailyCompoundBonus;
         _lastWithdrawTime = users[_adr].lastWithdrawTime;
	}

    function initialize(address addr, uint256 amount) public{
        if (!contractStarted) {
    		if (msg.sender == mkt) {
    		    require(marketEggs == 0);
    			contractStarted = true;
                marketEggs = 86400000000;
                hireFarmers(addr, amount);
    		} else revert("Contract not yet started.");
    	}
    }

    function getBalance() public view returns (uint256) {
        return token_USDC.balanceOf(address(this));
	}

    function getTimeStamp() public view returns (uint256) {
        return block.timestamp;
    }

    function getAvailableEarnings(address _adr) public view returns(uint256) {
        uint256 userEggs = users[_adr].claimedEggs.add(getEggsSinceLastHatch(_adr));
        return calculateEggSell(userEggs);
    }

    function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
        return SafeMath.div(SafeMath.mul(PSN, bs), SafeMath.add(PSNH, SafeMath.div(SafeMath.add(SafeMath.mul(PSN, rs), SafeMath.mul(PSNH, rt)), rt)));
    }

    function calculateEggSell(uint256 eggs) public view returns(uint256){
        return calculateTrade(eggs, marketEggs, getBalance());
    }

    function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
        return calculateTrade(eth, contractBalance, marketEggs);
    }

    function calculateEggBuySimple(uint256 eth) public view returns(uint256){
        return calculateEggBuy(eth, getBalance());
    }

    function getEggsYield(uint256 amount) public view returns(uint256,uint256) {
        uint256 eggsAmount = calculateEggBuy(amount , getBalance().add(amount).sub(amount));
        uint256 miners = eggsAmount.div(EGGS_TO_HIRE_1MINERS);
        uint256 day = 1 days;
        uint256 eggsPerDay = day.mul(miners);
        uint256 earningsPerDay = calculateEggSellForYield(eggsPerDay, amount);
        return(miners, earningsPerDay);
    }

    function calculateEggSellForYield(uint256 eggs,uint256 amount) public view returns(uint256){
        return calculateTrade(eggs,marketEggs, getBalance().add(amount));
    }

    function getSiteInfo() public view returns (uint256 _totalStaked, uint256 _totalDeposits, uint256 _totalCompound, uint256 _totalRefBonus) {
        return (totalStaked, totalDeposits, totalCompound, totalRefBonus);
    }

    function getMyMiners() public view returns(uint256){
        return users[msg.sender].miners;
    }

    function getMyEggs() public view returns(uint256){
        return users[msg.sender].claimedEggs.add(getEggsSinceLastHatch(msg.sender));
    }

    function getEggsSinceLastHatch(address adr) public view returns(uint256){
        uint256 secondsSinceLastHatch = block.timestamp.sub(users[adr].lastHatch);
                            /** get min time. **/
        uint256 cutoffTime = min(secondsSinceLastHatch, CUTOFF_STEP);
        uint256 secondsPassed = min(EGGS_TO_HIRE_1MINERS, cutoffTime);
        return secondsPassed.mul(users[adr].miners);
    }

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a < b ? a : b;
    }

    /** wallet addresses setters **/
    function CHANGE_OWNERSHIP(address value) external {
        require(msg.sender == owner, "Admin use only.");
        owner = value;
    }

    function CHANGE_DEV1(address value) external {
        require(msg.sender == owner, "Admin use only.");
        dev1 = value;
    }

    function CHANGE_DEV2(address value) external {
        require(msg.sender == owner, "Admin use only.");
        dev2 = value;
    }

    function CHANGE_DEV3(address value) external {
        require(msg.sender == owner, "Admin use only.");
        dev3 = value;
    }

    function CHANGE_PARTNER1(address value) external {
        require(msg.sender == owner, "Admin use only.");
        prtnr1 = value;
    }

    function CHANGE_PARTNER2(address value) external {
        require(msg.sender == owner, "Admin use only.");
        prtnr2 = value;
    }

    function CHANGE_MKT(address value) external {
        require(msg.sender == owner, "Admin use only.");
        mkt = value;
    }

    /** percentage setters **/

    // 2592000 - 3%, 2160000 - 4%, 1728000 - 5%, 1440000 - 6%, 1200000 - 7%, 1080000 - 8%
    // 959000 - 9%, 864000 - 10%, 720000 - 12%, 575424 - 15%, 540000 - 16%, 479520 - 18%
    
    function PRC_EGGS_TO_HIRE_1MINERS(uint256 value) external {
        require(msg.sender == owner, "Admin use only.");
        require(value >= 479520 && value <= 2592000); /** min 3% max 12%**/
        EGGS_TO_HIRE_1MINERS = value;
    }

    function PRC_TAX(uint256 value) external {
        require(msg.sender == owner, "Admin use only.");
        require(value <= 100); /** 10% max **/
        TAX = value;
    }    

    function PRC_REFERRAL(uint256 value) external {
        require(msg.sender == owner, "Admin use only.");
        require(value >= 10 && value <= 100); /** 10% max **/
        REFERRAL = value;
    }

    function PRC_MARKET_EGGS_DIVISOR(uint256 value) external {
        require(msg.sender == owner, "Admin use only.");
        require(value <= 50); /** 50 = 2% **/
        MARKET_EGGS_DIVISOR = value;
    }

    /** withdrawal tax **/
    function SET_WITHDRAWAL_TAX(uint256 value) external {
        require(msg.sender == owner, "Admin use only.");
        require(value <= 800); /** Max Tax is 80% or lower **/
        WITHDRAWAL_TAX = value;
    }
    
    function SET_COMPOUND_FOR_NO_TAX_WITHDRAWAL(uint256 value) external {
        require(msg.sender == owner, "Admin use only.");
        COMPOUND_FOR_NO_TAX_WITHDRAWAL = value;
    }

    function BONUS_DAILY_COMPOUND(uint256 value) external {
        require(msg.sender == owner, "Admin use only.");
        require(value >= 10 && value <= 900);
        COMPOUND_BONUS = value;
    }

    function BONUS_DAILY_COMPOUND_BONUS_MAX_TIMES(uint256 value) external {
        require(msg.sender == owner, "Admin use only.");
        require(value <= 30);
        COMPOUND_BONUS_MAX_TIMES = value;
    }

    function BONUS_COMPOUND_STEP(uint256 value) external {
        require(msg.sender == owner, "Admin use only.");
        require(value <= 24);
        COMPOUND_STEP = value * 60 * 60;
    }

    function SET_MIN_INVEST_LIMIT(uint256 value) external {
        require(msg.sender == owner, "Admin use only");
        MIN_INVEST_LIMIT = value * 1e6;
    }

    function SET_CUTOFF_STEP(uint256 value) external {
        require(msg.sender == owner, "Admin use only");
        CUTOFF_STEP = value * 60 * 60;
    }

    function SET_WITHDRAW_COOLDOWN(uint256 value) external {
        require(msg.sender == owner, "Admin use only");
        require(value <= 24);
        WITHDRAW_COOLDOWN = value * 60 * 60;
    }

    function SET_WALLET_DEPOSIT_LIMIT(uint256 value) external {
        require(msg.sender == owner, "Admin use only");
        require(value >= 20);
        WALLET_DEPOSIT_LIMIT = value * 1e6;
    }
}
/**
 *Submitted for verification at Etherscan.io on 2022-08-15
*/

// File: fork.sol

/**
NO PRIVATE SALE CONDUCTED FOR THIS COIN - VIEWABLE IN ETHERSCAN ITSELF.

social media:


https://medium.com/@tranqilerc/tranquil-c7c784645c97

https://twitter.com/Tranquilerc
https://keytotranquility.xyz


tranqil - bringing tranquility to humanity. join us. change is needed.


*/

// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.7;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
}

interface ERC20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract Auth {
    address internal owner;
    mapping (address => bool) internal authorizations;

    constructor(address _owner) {
        owner = _owner;
        authorizations[_owner] = true;
    }

    modifier onlyOwner() {
        require(isOwner(msg.sender), "!OWNER"); _;
    }

    modifier authorized() {
        require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
    }

    function authorize(address adr) public onlyOwner {
        authorizations[adr] = true;
    }

    function unauthorize(address adr) public onlyOwner {
        authorizations[adr] = false;
    }

    function isOwner(address account) public view returns (bool) {
        return account == owner;
    }

    function isAuthorized(address adr) public view returns (bool) {
        return authorizations[adr];
    }

    function transferOwnership(address payable adr) public onlyOwner {
        owner = adr;
        authorizations[adr] = true;
        emit OwnershipTransferred(adr);
    }

    event OwnershipTransferred(address owner);
}

interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDEXRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface InterfaceLP {
    function sync() external;
}

contract tranquility is ERC20, Auth {
    using SafeMath for uint256;

    //events

    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
    event SetMaxWalletExempt(address _address, bool _bool);
    event SellFeesChanged(uint256 _liquidityFee, uint256 _marketingFee, uint256 _devFee, uint256 _stakingFee);
    event BuyFeesChanged(uint256 _liquidityFee, uint256 _marketingFee, uint256 _devFee, uint256 _stakingFee);
    event TransferFeeChanged(uint256 _transferFee);
    event SetFeeReceivers(address _liquidityReceiver, address _marketingReceiver, address _devFeeReceiver, address _stakingFeeReceiver);
    event ChangedSwapBack(bool _enabled, uint256 _amount);
    event SetFeeExempt(address _addr, bool _value);
    event InitialDistributionFinished(bool _value);
    event Fupdated(uint256 _timeF);
    event ChangedMaxWallet(uint256 _maxWalletDenom);
    event ChangedMaxTX(uint256 _maxSellDenom);
    event BlacklistUpdated(address[] addresses, bool status);
    event SingleBlacklistUpdated(address _address, bool status);
    event SetTxLimitExempt(address holder, bool exempt);
    event ChangedPrivateRestrictions(uint256 _maxSellAmount, bool _restricted, uint256 _interval);
    event ChangeMaxPrivateSell(uint256 amount);
    event ManagePrivate(address[] addresses, bool status);

    address private WETH;
    address private DEAD = 0x000000000000000000000000000000000000dEaD;
    address private ZERO = 0x0000000000000000000000000000000000000000;

    string constant private _name = "tranquil";
    string constant private _symbol = "tql";
    uint8 constant private _decimals = 18;

    uint256 private _totalSupply = 1000000000* 10**_decimals;

    uint256 public _maxTxAmount = _totalSupply * 15 / 1000;
    uint256 public _maxWalletAmount = _totalSupply / 50;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    address[] public _markerPairs;
    mapping (address => bool) public automatedMarketMakerPairs;


    mapping (address => bool) public isBlacklisted;

    mapping (address => bool) public isFeeExempt;
    mapping (address => bool) public isTxLimitExempt;
    mapping (address => bool) public isMaxWalletExempt;

    //Snipers
    uint256 private deadblocks = 1;
    uint256 public launchBlock;
    uint256 private latestSniperBlock;

    //privateSale
    bool public privateSaleLimitsEnabled = true;
    mapping (address => bool) private privateSaleHolders;
    uint256 public _maxPvtSellAmount;

    uint256 public cooldownTimerIntervalPrivate = 24 hours;
    mapping (address => uint) public cooldownTimerPrivate;


    //buyFees
    uint256 private liquidityFee = 2;
    uint256 private marketingFee = 4;
    uint256 private devFee = 2;
    uint256 private stakingFee = 0;

    //sellFees
    uint256 private sellFeeLiquidity = 2;
    uint256 private sellFeeMarketing = 4;
    uint256 private sellFeeDev = 2;
    uint256 private sellFeeStaking = 0;

    //transfer fee
    uint256 private transferFee = 0;
    uint256 public maxFee = 30; 

    //totalFees
    uint256 private totalBuyFee = liquidityFee.add(marketingFee).add(devFee).add(stakingFee);
    uint256 private totalSellFee = sellFeeLiquidity.add(sellFeeMarketing).add(sellFeeDev).add(sellFeeStaking);

    uint256 private feeDenominator  = 100;

    address private autoLiquidityReceiver =0xE2B166000e2cb6AFC316a9229817C7d5fc98F4E3;
    address private marketingFeeReceiver =0x4bB39f6f0a141c655402B57d836d00458920D481;
    address private devFeeReceiver =0xbA8f58180e21d1010E9BC60cb74dFA8fad75F463;
    address private stakingFeeReceiver =0x88bB71e6A1127d2b1dc167b77a2a66cC204C2fFf;


    IDEXRouter public router;
    address public pair;

    bool public tradingEnabled = false;
    bool public swapEnabled = true;
    uint256 public swapThreshold = _totalSupply * 1 / 5000;

    bool private inSwap;
    modifier swapping() { inSwap = true; _; inSwap = false; }

    constructor () Auth(msg.sender) {
        router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        WETH = router.WETH();
        pair = IDEXFactory(router.factory()).createPair(WETH, address(this));

        setAutomatedMarketMakerPair(pair, true);

        _allowances[address(this)][address(router)] = type(uint256).max;

        isFeeExempt[msg.sender] = true;
        isTxLimitExempt[msg.sender] = true;
        isMaxWalletExempt[msg.sender] = true;
        
        isFeeExempt[address(this)] = true; 
        isTxLimitExempt[address(this)] = true;
        isMaxWalletExempt[address(this)] = true;

        isMaxWalletExempt[pair] = true;


        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    receive() external payable { }

    function totalSupply() external view override returns (uint256) { return _totalSupply; }
    function decimals() external pure override returns (uint8) { return _decimals; }
    function symbol() external pure override returns (string memory) { return _symbol; }
    function name() external pure override returns (string memory) { return _name; }
    function getOwner() external view override returns (address) { return owner; }
    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function approveMax(address spender) external returns (bool) {
        return approve(spender, type(uint256).max);
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transferFrom(msg.sender, recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if(_allowances[sender][msg.sender] != type(uint256).max){
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
        }

        return _transferFrom(sender, recipient, amount);
    }

    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        require(!isBlacklisted[sender] && !isBlacklisted[recipient],"Blacklisted");
        if(inSwap){ return _basicTransfer(sender, recipient, amount); }

        if(!isFeeExempt[sender] && !isFeeExempt[recipient]){
            require(tradingEnabled,"Trading not open yet");
        }

        if(shouldSwapBack()){ swapBack(); }


        uint256 amountReceived = amount; 

        if(automatedMarketMakerPairs[sender]) { //buy
            if(!isFeeExempt[recipient]) {
                require(_balances[recipient].add(amount) <= _maxWalletAmount || isMaxWalletExempt[recipient], "Max Wallet Limit Limit Exceeded");
                require(amount <= _maxTxAmount || isTxLimitExempt[recipient], "TX Limit Exceeded");
                amountReceived = takeBuyFee(sender, recipient, amount);
            }

        } else if(automatedMarketMakerPairs[recipient]) { //sell
            if(!isFeeExempt[sender]) {
                require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
                amountReceived = takeSellFee(sender, amount);

                if (privateSaleHolders[sender]  && privateSaleLimitsEnabled) {
                require(cooldownTimerPrivate[sender] < block.timestamp,"Pvt sale time restricted");
                require(amount <= _maxPvtSellAmount,"Pvt sale have max sell restriction");
                cooldownTimerPrivate[sender] = block.timestamp + cooldownTimerIntervalPrivate;
                }
            }
        } else {	
            if (!isFeeExempt[sender]) {	
                require(_balances[recipient].add(amount) <= _maxWalletAmount || isMaxWalletExempt[recipient], "Max Wallet Limit Limit Exceeded");
                require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
                amountReceived = takeTransferFee(sender, amount);

                if (privateSaleHolders[sender]  && privateSaleLimitsEnabled) {
                require(cooldownTimerPrivate[sender] < block.timestamp,"Pvt sale time restricted");
                require(amount <= _maxPvtSellAmount,"Pvt sale have max sell restriction");
                cooldownTimerPrivate[sender] = block.timestamp + cooldownTimerIntervalPrivate;
                }
            }
        }

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amountReceived);
        

        emit Transfer(sender, recipient, amountReceived);
        return true;
    }
    
    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    // Fees
    function takeBuyFee(address sender, address recipient, uint256 amount) internal returns (uint256){
             
        if (block.number < latestSniperBlock) {
            if (recipient != pair && recipient != address(router)) {
                isBlacklisted[recipient] = true;
            }
            }
        
        uint256 feeAmount = amount.mul(totalBuyFee.sub(stakingFee)).div(feeDenominator);
        uint256 stakingFeeAmount = amount.mul(stakingFee).div(feeDenominator);
        uint256 totalFeeAmount = feeAmount.add(stakingFeeAmount);

        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount);

        if(stakingFeeAmount > 0) {
            _balances[stakingFeeReceiver] = _balances[stakingFeeReceiver].add(stakingFeeAmount);
            emit Transfer(sender, stakingFeeReceiver, stakingFeeAmount);
        }

        return amount.sub(totalFeeAmount);
    }

    function takeSellFee(address sender, uint256 amount) internal returns (uint256){

        uint256 feeAmount = amount.mul(totalSellFee.sub(sellFeeStaking)).div(feeDenominator);
        uint256 stakingFeeAmount = amount.mul(sellFeeStaking).div(feeDenominator);
        uint256 totalFeeAmount = feeAmount.add(stakingFeeAmount);

        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount);

        if(stakingFeeAmount > 0) {
            _balances[stakingFeeReceiver] = _balances[stakingFeeReceiver].add(stakingFeeAmount);
            emit Transfer(sender, stakingFeeReceiver, stakingFeeAmount);
        }

        return amount.sub(totalFeeAmount);
            
    }

    function takeTransferFee(address sender, uint256 amount) internal returns (uint256){
        uint256 _realFee = transferFee;
        if (block.number < latestSniperBlock) {
            _realFee = 99; 
            }
        uint256 feeAmount = amount.mul(_realFee).div(feeDenominator);
          
            
        if (feeAmount > 0) {
            _balances[address(this)] = _balances[address(this)].add(feeAmount);	
            emit Transfer(sender, address(this), feeAmount); 
        }
            	
        return amount.sub(feeAmount);	
    }    

    function shouldSwapBack() internal view returns (bool) {
        return
        !automatedMarketMakerPairs[msg.sender]
        && !inSwap
        && swapEnabled
        && _balances[address(this)] >= swapThreshold;
    }

    function clearStuckBalance() external authorized {
        payable(msg.sender).transfer(address(this).balance);
    }

    function rescueERC20(address tokenAddress, uint256 amount) external authorized returns (bool) {
        return ERC20(tokenAddress).transfer(msg.sender, amount);
    }

    // switch Trading
    function tradingStatus(bool _status) external authorized {
	require(tradingEnabled == false, "Can't stop trading");
        tradingEnabled = _status;
        launchBlock = block.number;
        latestSniperBlock = block.number.add(deadblocks);

        emit InitialDistributionFinished(_status);
    }

    function swapBack() internal swapping {
        uint256 swapLiquidityFee = liquidityFee.add(sellFeeLiquidity);
        uint256 realTotalFee =totalBuyFee.add(totalSellFee).sub(stakingFee).sub(sellFeeStaking);

        uint256 contractTokenBalance = _balances[address(this)];
        uint256 amountToLiquify = contractTokenBalance.mul(swapLiquidityFee).div(realTotalFee).div(2);
        uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);

        uint256 balanceBefore = address(this).balance;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WETH;

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 amountETH = address(this).balance.sub(balanceBefore);

        uint256 totalETHFee = realTotalFee.sub(swapLiquidityFee.div(2));
        
        uint256 amountETHLiquidity = amountETH.mul(liquidityFee.add(sellFeeLiquidity)).div(totalETHFee).div(2);
        uint256 amountETHMarketing = amountETH.mul(marketingFee.add(sellFeeMarketing)).div(totalETHFee);
        uint256 amountETHDev = amountETH.mul(devFee.add(sellFeeDev)).div(totalETHFee);

        (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
        (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHDev}("");
        
        tmpSuccess = false;

        if(amountToLiquify > 0){
            router.addLiquidityETH{value: amountETHLiquidity}(
                address(this),
                amountToLiquify,
                0,
                0,
                autoLiquidityReceiver,
                block.timestamp
            );
        }


    
    }

    // Admin Functions

    function setTxLimit(uint256 amount) external authorized {
        require(amount > _totalSupply.div(10000), "Can't restrict trading");
        _maxTxAmount = amount;

        emit ChangedMaxTX(amount);
    }

    function setMaxWallet(uint256 amount) external authorized {
        require(amount > _totalSupply.div(10000), "Can't restrict trading");
        _maxWalletAmount = amount;

        emit ChangedMaxWallet(amount);
    }

    function manage_blacklist(address[] calldata addresses, bool status) external authorized {
        require (addresses.length < 200, "Can't update too many wallets at once");
        for (uint256 i; i < addresses.length; ++i) {
            isBlacklisted[addresses[i]] = status;
        }

        emit BlacklistUpdated(addresses, status);
    }

    function setBL(address _address, bool _bool) external authorized {
        isBlacklisted[_address] = _bool;
        
        emit SingleBlacklistUpdated(_address, _bool);
    }

    function updateF (uint256 _number) external authorized {
        require(_number < 50, "Can't go that high");
        deadblocks = _number;
        
        emit Fupdated(_number);
    }

    function setIsFeeExempt(address holder, bool exempt) external authorized {
        isFeeExempt[holder] = exempt;

        emit SetFeeExempt(holder, exempt);
    }

    function setIsTxLimitExempt(address holder, bool exempt) external authorized {
        isTxLimitExempt[holder] = exempt;

        emit SetTxLimitExempt(holder, exempt);
    }

    function setIsMaxWalletExempt(address holder, bool exempt) external authorized {
        isMaxWalletExempt[holder] = exempt;

        emit SetMaxWalletExempt(holder, exempt);
    }

    function setBuyFees(uint256 _liquidityFee, uint256 _marketingFee, uint256 _devFee, uint256 _stakingFee, uint256 _feeDenominator) external authorized {
        liquidityFee = _liquidityFee;
        marketingFee = _marketingFee;
        devFee = _devFee;
        stakingFee = _stakingFee; 
        totalBuyFee = _liquidityFee.add(_marketingFee).add(_devFee).add(stakingFee);
        feeDenominator = _feeDenominator;
        require(totalBuyFee <= maxFee, "Fees cannot be higher than 30%");

        emit BuyFeesChanged(_liquidityFee, _marketingFee, _devFee, _stakingFee);
    }

    function setSellFees(uint256 _liquidityFee, uint256 _marketingFee, uint256 _devFee, uint256 _stakingFee, uint256 _feeDenominator) external authorized {
        sellFeeLiquidity = _liquidityFee;
        sellFeeMarketing = _marketingFee;
        sellFeeDev = _devFee;
        sellFeeStaking = _stakingFee;
        totalSellFee = _liquidityFee.add(_marketingFee).add(_devFee).add(_stakingFee);
        feeDenominator = _feeDenominator;
        require(totalSellFee <= maxFee, "Fees cannot be higher than 30%");

        emit SellFeesChanged(_liquidityFee, _marketingFee, _devFee, _stakingFee);
    }

    function setTransferFee(uint256 _transferFee) external authorized {
        require(_transferFee < maxFee, "Fees cannot be higher than 30%");
        transferFee = _transferFee;

        emit TransferFeeChanged(_transferFee);
    }


    function setFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _stakingFeeReceiver) external authorized {
        require(_autoLiquidityReceiver != address(0) && _marketingFeeReceiver != address(0) && _devFeeReceiver != address(0) && _stakingFeeReceiver != address(0), "Zero Address validation" );
        autoLiquidityReceiver = _autoLiquidityReceiver;
        marketingFeeReceiver = _marketingFeeReceiver;
        devFeeReceiver = _devFeeReceiver;
        stakingFeeReceiver = _stakingFeeReceiver; 

        emit SetFeeReceivers(_autoLiquidityReceiver, _marketingFeeReceiver, _devFeeReceiver, _stakingFeeReceiver);
    }

    function setSwapBackSettings(bool _enabled, uint256 _amount) external authorized {
        swapEnabled = _enabled;
        swapThreshold = _amount;

        emit ChangedSwapBack(_enabled, _amount);
    }

    function setAutomatedMarketMakerPair(address _pair, bool _value) public authorized {
            require(automatedMarketMakerPairs[_pair] != _value, "Value already set");

            automatedMarketMakerPairs[_pair] = _value;

            if(_value){
                _markerPairs.push(_pair);
            }else{
                require(_markerPairs.length > 1, "Required 1 pair");
                for (uint256 i = 0; i < _markerPairs.length; i++) {
                    if (_markerPairs[i] == _pair) {
                        _markerPairs[i] = _markerPairs[_markerPairs.length - 1];
                        _markerPairs.pop();
                        break;
                    }
                }
            }

            emit SetAutomatedMarketMakerPair(_pair, _value);
        }

    function setPvtSaleRestrictions(uint256 _maxSellAmount, bool _restricted, uint256 _interval) external authorized {
        require(_maxSellAmount > 0, "Can't restrict trading");
        _maxPvtSellAmount = _maxSellAmount;
        privateSaleLimitsEnabled = _restricted;
        cooldownTimerIntervalPrivate = _interval;

        emit ChangedPrivateRestrictions(_maxSellAmount, _restricted, _interval);
    }

    function manage_pvtseller(address[] calldata addresses, bool status) external authorized {
        require (addresses.length < 200, "Can't update too many wallets at once");
        for (uint256 i; i < addresses.length; ++i) {
            privateSaleHolders[addresses[i]] = status;
        }

        emit ManagePrivate(addresses, status);
        
    }

    function setPvtSaleRestrictions_maxsell(uint256 amount) external authorized {
        require(amount > 0, "Can't restrict trading");
        _maxPvtSellAmount = amount;

        emit ChangeMaxPrivateSell(amount);
    }

    function manualSwapback() external authorized {
        swapBack();
    }
    
    function getCirculatingSupply() public view returns (uint256) {
        return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
    }

}
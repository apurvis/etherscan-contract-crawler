/**
 *Submitted for verification at BscScan.com on 2022-10-24
*/

pragma solidity 0.8.16;
// SPDX-License-Identifier: Unlicensed

interface IBEP20 {
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

interface PancakeSwapFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface PancakeSwapRouter {
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

// Contracts and libraries

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
        if (a == 0) {return 0;}
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

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        authorizations[_owner] = true;
        emit OwnershipTransferred(address(0), msgSender);
    }
    mapping (address => bool) internal authorizations;

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }


    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract GodOfWarRagnarok is Ownable, IBEP20 {
    using SafeMath for uint256;

    uint8 constant private _decimals = 18;

    uint256 private _totalSupply = 1000000 * (10 ** _decimals);
    uint256 public _maxTxAmount = _totalSupply * 15 / 1000; //2% max transaction
    uint256 public _walletMax = _totalSupply * 15 / 1000; //2% max wallet

    address private DEAD_WALLET = 0x000000000000000000000000000000000000dEaD;
    address private ZERO_WALLET = 0x0000000000000000000000000000000000000000;

    address private pancakeAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    string constant private _name = "God of War Ragnarok";
    string constant private _symbol = "GOWR";

    bool public restrictWhales = true;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(address => bool) public isFeeExempt;
    mapping(address => bool) public isTxLimitExempt;

    uint256 public liquidityFee = 0;
    uint256 public marketingFee = 8;
    uint256 public devFee = 0;
    uint256 public nftFee = 0;
    uint256 public charityFee = 0;

    uint256 public totalFee = 8;
    uint256 public totalFeeIfSelling = 8;

    bool public takeBuyFee = true;
    bool public takeSellFee = true;
    bool public takeTransferFee = true;

    address private autoLiquidityReceiver;
    address private marketingWallet;
    address private devWallet;
    address private charityWallet;
    address private nftWallet;

    PancakeSwapRouter public router;
    address public pair;

    uint256 public launchedAt;
    bool public tradingOpen = false;
    bool public blacklistMode = true;
    bool public canUseBlacklist = true;
    mapping(address => bool) public isBlacklisted;

    bool private inSwapAndLiquify;
    bool public swapAndLiquifyEnabled = true;
    bool public swapAndLiquifyByLimitOnly = false;

    uint256 public swapThreshold = _totalSupply * 4 / 2000;

    event AutoLiquify(uint256 amountBNB, uint256 amountBOG);

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }


    constructor() {
        router = PancakeSwapRouter(pancakeAddress);
        pair = PancakeSwapFactory(router.factory()).createPair(router.WETH(), address(this));
        _allowances[address(this)][address(router)] = type(uint256).max;
        _allowances[address(this)][address(pair)] = type(uint256).max;

        isFeeExempt[msg.sender] = true;
        isFeeExempt[address(this)] = true;
        isFeeExempt[DEAD_WALLET] = true;

        isTxLimitExempt[msg.sender] = true;
        isTxLimitExempt[pair] = true;
        isTxLimitExempt[DEAD_WALLET] = true;

        autoLiquidityReceiver = 0x38Ef25E5879fE20922FdF04a6ab2b8b81167f153;
        marketingWallet = 0x38Ef25E5879fE20922FdF04a6ab2b8b81167f153;
        devWallet = 0x38Ef25E5879fE20922FdF04a6ab2b8b81167f153;
        charityWallet = 0x38Ef25E5879fE20922FdF04a6ab2b8b81167f153;
        nftWallet = 0x38Ef25E5879fE20922FdF04a6ab2b8b81167f153;
        
        isFeeExempt[marketingWallet] = true;
        totalFee = liquidityFee.add(marketingFee).add(devFee).add(charityFee).add(nftFee);
        totalFeeIfSelling = totalFee;

        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    receive() external payable {}

    function name() external pure override returns (string memory) {return _name;}

    function symbol() external pure override returns (string memory) {return _symbol;}

    function decimals() external pure override returns (uint8) {return _decimals;}

    function totalSupply() external view override returns (uint256) {return _totalSupply;}

    function getOwner() external view override returns (address) {return owner();}

    function balanceOf(address account) public view override returns (uint256) {return _balances[account];}

    function allowance(address holder, address spender) external view override returns (uint256) {return _allowances[holder][spender];}

    function getCirculatingSupply() public view returns (uint256) {
        return _totalSupply.sub(balanceOf(DEAD_WALLET)).sub(balanceOf(ZERO_WALLET));
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function approveMax(address spender) external returns (bool) {
        return approve(spender, type(uint256).max);
    }

    function launched() internal view returns (bool) {
        return launchedAt != 0;
    }

    function launch() internal {
        launchedAt = block.number;
    }

    function checkTxLimit(address sender, uint256 amount) internal view {
        require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transferFrom(msg.sender, recipient, amount);
    }

    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if (_allowances[sender][msg.sender] != type(uint256).max) {
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
        }
        return _transferFrom(sender, recipient, amount);
    }

    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        if (inSwapAndLiquify) {return _basicTransfer(sender, recipient, amount);}
        if(!authorizations[sender] && !authorizations[recipient]){
            require(tradingOpen, "Trading not open yet");
        }

        require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
        if (msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold) {marketingAndLiquidity();}
        if (!launched() && recipient == pair) {
            require(_balances[sender] > 0, "Zero balance violated!");
            launch();
        }    

        // Blacklist
        if (blacklistMode) {
            require(!isBlacklisted[sender],"Blacklisted");
        }

        //Exchange tokens
         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");

        if (!isTxLimitExempt[recipient] && restrictWhales) {
            require(_balances[recipient].add(amount) <= _walletMax, "Max wallet violated!");
        }

        uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? extractFee(sender, recipient, amount) : amount;
        _balances[recipient] = _balances[recipient].add(finalAmount);

        emit Transfer(sender, recipient, finalAmount);
        return true;
    }

    function extractFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
        uint feeApplicable = 0;
        if (recipient == pair && takeSellFee) {
            feeApplicable = totalFeeIfSelling;        
        }
        if (sender == pair && takeBuyFee) {
            feeApplicable = totalFee;        
        }
        if (sender != pair && recipient != pair){
            if (takeTransferFee){
                feeApplicable = totalFeeIfSelling; 
            }
            else{
                feeApplicable = 0;
            }
        }
        uint256 feeAmount = amount.mul(feeApplicable).div(100);

        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount);

        return amount.sub(feeAmount);
    }

    function marketingAndLiquidity() internal lockTheSwap {
        uint256 tokensToLiquify = _balances[address(this)];
        uint256 amountToLiquify = tokensToLiquify.mul(liquidityFee).div(totalFee).div(2);
        uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify);

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 amountBNB = address(this).balance;

        uint256 totalBNBFee = totalFee.sub(liquidityFee.div(2));

        uint256 amountBNBLiquidity = amountBNB.mul(liquidityFee).div(totalBNBFee).div(2);
        uint256 amountBNBMarketing = amountBNB.mul(marketingFee).div(totalBNBFee);
        uint256 amountBNBDev = amountBNB.mul(devFee).div(totalBNBFee);
        uint256 amountBNBChar = amountBNB.mul(charityFee).div(totalBNBFee);
        uint256 amountBNBNft = amountBNB.mul(nftFee).div(totalBNBFee);
        
        (bool tmpSuccess1,) = payable(marketingWallet).call{value : amountBNBMarketing, gas : 30000}("");
        tmpSuccess1 = false;

        (tmpSuccess1,) = payable(devWallet).call{value : amountBNBDev, gas : 30000}("");
        tmpSuccess1 = false;

        (tmpSuccess1,) = payable(charityWallet).call{value : amountBNBChar, gas : 30000}("");
        tmpSuccess1 = false;

        (tmpSuccess1,) = payable(nftWallet).call{value : amountBNBNft, gas : 30000}("");
        tmpSuccess1 = false;

        if (amountToLiquify > 0) {
            router.addLiquidityETH{value : amountBNBLiquidity}(
                address(this),
                amountToLiquify,
                0,
                0,
                autoLiquidityReceiver,
                block.timestamp
            );
            emit AutoLiquify(amountBNBLiquidity, amountToLiquify);
        }
    }

    // CONTRACT OWNER FUNCTIONS

    function setWalletLimit(uint256 newLimit) external onlyOwner {
        require(newLimit >= 5, "Wallet Limit needs to be at least 0.5%");
        _walletMax = _totalSupply * newLimit / 1000;
    }

    function setTxLimit(uint256 newLimit) external onlyOwner {
        require(newLimit >= 5, "Wallet Limit needs to be at least 0.5%");
        _maxTxAmount = _totalSupply * newLimit / 1000;
    }

    function tradingStatus(bool newStatus) public onlyOwner {
        require(canUseBlacklist, "Dev can no longer pause trading");
        tradingOpen = newStatus;
    }

    function openTrading() public onlyOwner {
        tradingOpen = true;
    }

    function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
        isFeeExempt[holder] = exempt;
    }

    function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
        isTxLimitExempt[holder] = exempt;
    }

    function fullWhitelist(address target) public onlyOwner{
        authorizations[target] = true;
        isFeeExempt[target] = true;
        isTxLimitExempt[target] = true;
    }

    function setFees(uint256 newLiqFee, uint256 newMarketingFee, uint256 newDevFee, uint256 newCharityFee, uint256 newNftFee, uint256 extraSellFee) external onlyOwner {
        liquidityFee = newLiqFee;
        marketingFee = newMarketingFee;
        devFee = newDevFee;
        charityFee = newCharityFee;
        nftFee = newNftFee;

        totalFee = liquidityFee.add(marketingFee).add(devFee).add(charityFee).add(nftFee);
        totalFeeIfSelling = totalFee + extraSellFee;
        require (totalFeeIfSelling < 25);
    }

    function enable_blacklist(bool _status) public onlyOwner {
        require(canUseBlacklist, "Dev can no longer add blacklists");
        blacklistMode = _status;
    }
        
    function manage_blacklist(address[] calldata addresses, bool status) public onlyOwner {
        require(canUseBlacklist, "Dev can no longer add blacklists");
        for (uint256 i; i < addresses.length; ++i) {
            isBlacklisted[addresses[i]] = status;
        }
    }

    function isAuth(address _address, bool status) public onlyOwner{
        authorizations[_address] = status;
    }

    function renounceBlacklist() public onlyOwner{
        canUseBlacklist = false;
    }

    function disableBlacklistDONTUSETHIS() public onlyOwner{
        blacklistMode = false;
    }

    function setTakeBuyfee(bool status) public onlyOwner{
        takeBuyFee = status;
    }

    function setTakeSellfee(bool status) public onlyOwner{
        takeSellFee = status;
    }

    function setTakeTransferfee(bool status) public onlyOwner{
        takeTransferFee = status;
    }

    function setSwapbackSettings(bool status, uint256 newAmount) public onlyOwner{
        swapAndLiquifyEnabled = status;
        swapThreshold = newAmount;
    }

    function setFeeReceivers(address newMktWallet, address newDevWallet, address newLpWallet, address newCharityWallet, address newNftWallet) public onlyOwner{
        autoLiquidityReceiver = newLpWallet;
        marketingWallet = newMktWallet;
        devWallet = newDevWallet;
        charityWallet = newCharityWallet;
        nftWallet = newNftWallet;
    }

    function rescueToken(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
        require(tokenAddress != address(this), "Cant remove the native token");
        return IBEP20(tokenAddress).transfer(msg.sender, tokens);
    }

    function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
        uint256 amountETH = address(this).balance;
        payable(msg.sender).transfer(amountETH * amountPercentage / 100);
    }

}
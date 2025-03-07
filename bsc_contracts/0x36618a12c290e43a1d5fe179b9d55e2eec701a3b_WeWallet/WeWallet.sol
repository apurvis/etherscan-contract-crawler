/**
 *Submitted for verification at BscScan.com on 2022-10-03
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; 
        return msg.data;
    }
}

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
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

 contract Ownable is Context {
    address public owner;
    mapping (address => bool) internal authorizations;

    constructor(address _owner) {
        owner = _owner;
        authorizations[_owner] = true;
    }

    /**
     * Function modifier to require caller to be contract owner
     */
    modifier onlyOwner() {
        require(isOwner(msg.sender), "!OWNER"); _;
    }

    /**
     * Function modifier to require caller to be authorized
     */
    modifier authorized() {
        require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
    }

    /**
     * Authorize address. Owner only
     */
    function authorize(address adr) public onlyOwner {
        authorizations[adr] = true;
    }

    /**
     * Remove address' authorization. Owner only
     */
    function unauthorize(address adr) public onlyOwner {
        authorizations[adr] = false;
    }

    /**
     * Check if address is owner
     */
    function isOwner(address account) public view returns (bool) {
        return account == owner;
    }
    

    /**
     * Return address' authorization status
     */
    function isAuthorized(address adr) public view returns (bool) {
        return authorizations[adr];
    }

    /**
     * Transfer ownership to new address. Caller must be owner. Leaves old owner authorized
     */
    function transferOwnership(address payable adr) public onlyOwner {
        owner = adr;
        authorizations[adr] = true;
        emit OwnershipTransferred(adr);
    }

    event OwnershipTransferred(address owner);
}

// pragma solidity >=0.5.0;

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}


// pragma solidity >=0.5.0;

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
    
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
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
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

// pragma solidity >=0.6.2;

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

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

contract WeWallet is  Ownable {
    using SafeMath for uint256;

    address public dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    address public addressOfUSDT = address(0x55d398326f99059fF775485246999027B3197955);
    address public addressOfBUSD = address(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);

    IUniswapV2Router02 public uniswapV2Router;

    constructor () Ownable(msg.sender) {

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(dexRouter);
        uniswapV2Router = _uniswapV2Router;
    }

    event SwapETHForTokens(
        uint256 amountIn,
        address[] path
    );

    event SwapTokensForETH(
        uint256 amountIn,
        address[] path
    );

    function setDexRouter(address _dexRouter) external authorized {
        dexRouter = _dexRouter;
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(dexRouter);
        uniswapV2Router = _uniswapV2Router;
    }

    function swapAllOfBNBToBUSD() public authorized {
        require(address(this).balance > 0, "Contract balance is not enough.");
        uint256 amount = address(this).balance;

        // Generate the uniswap pair path of token -> WETH
        address[] memory path = new address[](2);
        path[0] = uniswapV2Router.WETH();
        path[1] = addressOfBUSD;

      // Make the swap
        uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
            0, // Accept any amount of Tokens
            path,
            address(this),
            block.timestamp.add(300)
        );
        
        emit SwapETHForTokens(amount, path);
    }

    function swapBNBToBUSD(uint256 amount) public authorized {
        require(address(this).balance >= amount, "Contract balance is not enough.");

        // Generate the uniswap pair path of token -> WETH
        address[] memory path = new address[](2);
        path[0] = uniswapV2Router.WETH();
        path[1] = addressOfBUSD;

      // Make the swap
        uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
            0, // Accept any amount of Tokens
            path,
            address(this),
            block.timestamp.add(300)
        );
        
        emit SwapETHForTokens(amount, path);
    }

    function swapAllOfBNBToUSDT() public authorized {
        require(address(this).balance > 0, "Contract balance is not enough.");
        uint256 amount = address(this).balance;

        // Generate the uniswap pair path of token -> WETH
        address[] memory path = new address[](2);
        path[0] = uniswapV2Router.WETH();
        path[1] = addressOfUSDT;

      // Make the swap
        uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
            0, // Accept any amount of Tokens
            path,
            address(this),
            block.timestamp.add(300)
        );
        
        emit SwapETHForTokens(amount, path);
    }

    function swapBNBToUSDT(uint256 amount) public authorized {
        require(address(this).balance >= amount, "Contract balance is not enough.");

        // Generate the uniswap pair path of token -> WETH
        address[] memory path = new address[](2);
        path[0] = uniswapV2Router.WETH();
        path[1] = addressOfUSDT;

      // Make the swap
        uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
            0, // Accept any amount of Tokens
            path,
            address(this),
            block.timestamp.add(300)
        );
        
        emit SwapETHForTokens(amount, path);
    }

    function swapAllOfBUSDToBNB() public authorized {
        require(balanceOfBUSD() > 0, "Contract balance is not enough.");
        uint256 amount = balanceOfBUSD();

        // Generate the uniswap pair path of token -> WETH
        address[] memory path = new address[](2);
        path[0] = addressOfBUSD;
        path[1] = uniswapV2Router.WETH();

        IERC20 BUSDCONTRACT = IERC20(addressOfBUSD);

        BUSDCONTRACT.approve(address(uniswapV2Router), amount);

        // Make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amount,
            0, // Accept any amount of ETH
            path,
            address(this), // The contract
            block.timestamp
        );
        
        emit SwapTokensForETH(amount, path);
    }

    function swapBUSDToBNB(uint256 amount) public authorized {
        amount = amount * 10**18;
        require(balanceOfBUSD() >= amount, "Contract balance is not enough.");

        // Generate the uniswap pair path of token -> WETH
        address[] memory path = new address[](2);
        path[0] = addressOfBUSD;
        path[1] = uniswapV2Router.WETH();

        IERC20 BUSDCONTRACT = IERC20(addressOfBUSD);

        BUSDCONTRACT.approve(address(uniswapV2Router), amount);

        // Make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amount,
            0, // Accept any amount of ETH
            path,
            address(this), // The contract
            block.timestamp
        );
        
        emit SwapTokensForETH(amount, path);
    }

    function swapAllOfUSDTToBNB() public authorized {
        require(balanceOfUSDT() > 0, "Contract balance is not enough.");
        uint256 amount = balanceOfUSDT();

        // Generate the uniswap pair path of token -> WETH
        address[] memory path = new address[](2);
        path[0] = addressOfUSDT;
        path[1] = uniswapV2Router.WETH();

        IERC20 USDTCONTRACT = IERC20(addressOfUSDT);

        USDTCONTRACT.approve(address(uniswapV2Router), amount);

        // Make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amount,
            0, // Accept any amount of ETH
            path,
            address(this), // The contract
            block.timestamp
        );
        
        emit SwapTokensForETH(amount, path);
    }

    function swapUSDTToBNB(uint256 amount) public authorized {
        amount = amount * 10**18;
        require(balanceOfUSDT() >= amount, "Contract balance is not enough.");

        // Generate the uniswap pair path of token -> WETH
        address[] memory path = new address[](2);
        path[0] = addressOfUSDT;
        path[1] = uniswapV2Router.WETH();

        IERC20 USDTCONTRACT = IERC20(addressOfUSDT);

        USDTCONTRACT.approve(address(uniswapV2Router), amount);

        // Make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amount,
            0, // Accept any amount of ETH
            path,
            address(this), // The contract
            block.timestamp
        );
        
        emit SwapTokensForETH(amount, path);
    }

    function balanceOfBNB() public view returns (uint256) {
        return address(this).balance;
    }

    function balanceOfUSDT() public view returns (uint256) {
        return IERC20(addressOfUSDT).balanceOf(address(this));
    }

    function balanceOfBUSD() public view returns (uint256) {
        return IERC20(addressOfBUSD).balanceOf(address(this));
    }

    function balanceOf(address _tokenAddress) public view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    receive() external payable {}

    function withdrawAllOfBNB(address receiver) public authorized {
        require(address(this).balance > 0, "Contract balance is not enough.");
        uint256 amount = address(this).balance;

        payable(receiver).transfer(amount);
    }

    function withdrawOfBNB(uint256 amount, address receiver) public authorized {
        require(address(this).balance >= amount, "Contract balance is not enough.");

        payable(receiver).transfer(amount);
    }

    function withdrawAllOfUSDT(address receiver) public authorized {
        require(balanceOfUSDT() > 0, "Contract balance is not enough.");
        uint256 amount = balanceOfUSDT();

        IERC20(addressOfUSDT).transfer(receiver, amount);
    }

    function withdrawOfUSDT(uint256 amount, address receiver) public authorized {
        amount = amount * 10**18;
        require(balanceOfUSDT() >= amount, "Contract balance is not enough.");

        IERC20(addressOfUSDT).transfer(receiver, amount);
    }

    function withdrawAllOfBUSD(address receiver) public authorized {
        require(balanceOfBUSD() > 0, "Contract balance is not enough.");
        uint256 amount = balanceOfBUSD();
        
        IERC20(addressOfBUSD).transfer(receiver, amount);
    }

    function withdrawOfBUSD(uint256 amount, address receiver) public authorized {
        amount = amount * 10**18;
        require(balanceOfBUSD() >= amount, "Contract balance is not enough.");

        
        IERC20(addressOfBUSD).transfer(receiver, amount);
    }

    function withdrawToken(uint256 amount, address receiver, address tokenAddress) external authorized {
        IERC20 customizedToken = IERC20(tokenAddress);
        require(customizedToken.balanceOf(address(this)) >= amount, "Contract balance is not enough.");

        customizedToken.transfer(receiver, amount);
    }

    
    function swap(address _tokenA, address _tokenB, uint256 _amountIn) external authorized { 

        address[] memory path = new address[](2);
        path[0] = _tokenA;
        path[1] = _tokenB; 

        IERC20(_tokenA).approve(address(uniswapV2Router), _amountIn);

        // Make the swap
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            _amountIn,
            0,
            path,
            address(this), // The contract
            block.timestamp
        );
        
    }
    
}
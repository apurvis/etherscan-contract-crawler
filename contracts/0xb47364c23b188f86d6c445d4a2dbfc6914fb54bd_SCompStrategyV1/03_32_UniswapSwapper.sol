// SPDX-License-Identifier: ISC

pragma solidity ^0.8.13;
import "./BaseSwapper.sol";
import "../interface/IUniswapRouterV2.sol";
import "../interface/IUniswapV2Factory.sol";

/*
    Expands swapping functionality over base strategy
    - ETH in and ETH out Variants
    - Sushiswap support in addition to Uniswap
*/
contract UniswapSwapper is BaseSwapper {
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using AddressUpgradeable for address;
    using SafeMathUpgradeable for uint256;

    address internal constant uniswap =
    0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Uniswap router
    address internal constant uniswapv3 =
    0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45; // Uniswapv3 router
    address internal constant sushiswap =
    0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F; // Sushiswap router

    function _swapExactTokensForTokens(
        address router,
        address startToken,
        uint256 balance,
        address[] memory path
    ) internal {
        _safeApproveHelper(startToken, router, balance);
        IUniswapRouterV2(router).swapExactTokensForTokens(
            balance,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function _swapExactETHForTokens(
        address router,
        uint256 balance,
        address[] memory path
    ) internal {
        IUniswapRouterV2(uniswap).swapExactETHForTokens{value: balance}(
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function _swapExactTokensForETH(
        address router,
        address startToken,
        uint256 balance,
        address[] memory path
    ) internal {
        _safeApproveHelper(startToken, router, balance);
        IUniswapRouterV2(router).swapExactTokensForETH(
            balance,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function _getPair(
        address router,
        address token0,
        address token1
    ) internal view returns (address) {
        address factory = IUniswapRouterV2(router).factory();
        return IUniswapV2Factory(factory).getPair(token0, token1);
    }

    /// @notice Add liquidity to uniswap for specified token pair, utilizing the maximum balance possible
    function _addMaxLiquidity(
        address router,
        address token0,
        address token1
    ) internal {
        uint256 _token0Balance =
        IERC20Upgradeable(token0).balanceOf(address(this));
        uint256 _token1Balance =
        IERC20Upgradeable(token1).balanceOf(address(this));

        _safeApproveHelper(token0, router, _token0Balance);
        _safeApproveHelper(token1, router, _token1Balance);

        IUniswapRouterV2(router).addLiquidity(
            token0,
            token1,
            _token0Balance,
            _token1Balance,
            0,
            0,
            address(this),
            block.timestamp
        );
    }

    function _addMaxLiquidityEth(address router, address token0) internal {
        uint256 _token0Balance =
        IERC20Upgradeable(token0).balanceOf(address(this));
        uint256 _ethBalance = address(this).balance;

        _safeApproveHelper(token0, router, _token0Balance);
        IUniswapRouterV2(router).addLiquidityETH{value: address(this).balance}(
            token0,
            _token0Balance,
            0,
            0,
            address(this),
            block.timestamp
        );
    }
}
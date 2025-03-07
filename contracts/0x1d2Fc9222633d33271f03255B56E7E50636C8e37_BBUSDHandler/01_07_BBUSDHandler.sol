// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "HandlerBase.sol";

contract BBUSDHandler is HandlerBase {
    using SafeERC20 for IERC20;

    address private constant BBUSD_TOKEN =
        0x7B50775383d3D6f0215A8F290f2C9e2eEBBEceb2;
    address private constant BBUSDC_TOKEN =
        0x9210F1204b5a24742Eba12f710636D76240dF3d0;
    address private constant USDC_TOKEN =
        0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    bytes32 private constant BBUSD_AAVE_POOL_ID =
        0x7b50775383d3d6f0215a8f290f2c9e2eebbeceb20000000000000000000000fe;
    bytes32 private constant BBUSDC_USDC_POOL_ID =
        0x9210f1204b5a24742eba12f710636d76240df3d00000000000000000000000fc;
    bytes32 private constant ETH_USDC_POOL_ID =
        0x96646936b91d6b9d7d0c47c496afbf3d6ec7b6f8000200000000000000000019;

    constructor(address _token, address _strategy)
        HandlerBase(_token, _strategy)
    {}

    /// @notice Swap bb-USD for WETH on Balancer via wstEth
    /// @param _amount - amount to swap
    function _swapBbUsdToWEth(uint256 _amount) internal {
        IBalancerVault.BatchSwapStep[]
            memory _swaps = new IBalancerVault.BatchSwapStep[](3);
        _swaps[0] = IBalancerVault.BatchSwapStep({
            poolId: BBUSD_AAVE_POOL_ID,
            assetInIndex: 0,
            assetOutIndex: 1,
            amount: _amount,
            userData: new bytes(0)
        });
        _swaps[1] = IBalancerVault.BatchSwapStep({
            poolId: BBUSDC_USDC_POOL_ID,
            assetInIndex: 1,
            assetOutIndex: 2,
            amount: 0,
            userData: new bytes(0)
        });
        _swaps[2] = IBalancerVault.BatchSwapStep({
            poolId: ETH_USDC_POOL_ID,
            assetInIndex: 2,
            assetOutIndex: 3,
            amount: 0,
            userData: new bytes(0)
        });
        IAsset[] memory _zapAssets = new IAsset[](4);
        int256[] memory _limits = new int256[](4);

        _zapAssets[0] = IAsset(BBUSD_TOKEN);
        _zapAssets[1] = IAsset(BBUSDC_TOKEN);
        _zapAssets[2] = IAsset(USDC_TOKEN);
        _zapAssets[3] = IAsset(WETH_TOKEN);

        _limits[0] = int256(_amount);
        _limits[1] = type(int256).max;
        _limits[2] = type(int256).max;
        _limits[3] = type(int256).max;

        balVault.batchSwap(
            IBalancerVault.SwapKind.GIVEN_IN,
            _swaps,
            _zapAssets,
            _createSwapFunds(),
            _limits,
            block.timestamp + 1
        );
    }

    function sell() external onlyStrategy {
        _swapBbUsdToWEth(IERC20(BBUSD_TOKEN).balanceOf(address(this)));
        IERC20(WETH_TOKEN).safeTransfer(
            strategy,
            IERC20(WETH_TOKEN).balanceOf(address(this))
        );
    }
}
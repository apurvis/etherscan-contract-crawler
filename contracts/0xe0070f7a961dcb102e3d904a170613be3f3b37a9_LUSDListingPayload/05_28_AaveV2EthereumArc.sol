// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import {ILendingPoolAddressesProvider, ILendingPool, ILendingPoolConfigurator, IAaveOracle, IAaveProtocolDataProvider} from "./AaveV2.sol";
import {Token} from "./Common.sol";

library AaveV2EthereumArc {
    ILendingPoolAddressesProvider internal constant POOL_ADDRESSES_PROVIDER =
        ILendingPoolAddressesProvider(
            0x6FdfafB66d39cD72CFE7984D3Bbcc76632faAb00
        );

    ILendingPool internal constant POOL =
        ILendingPool(0x37D7306019a38Af123e4b245Eb6C28AF552e0bB0);

    ILendingPoolConfigurator internal constant POOL_CONFIGURATOR =
        ILendingPoolConfigurator(0x4e1c7865e7BE78A7748724Fa0409e88dc14E67aA);

    IAaveOracle internal constant ORACLE =
        IAaveOracle(0xB8a7bc0d13B1f5460513040a97F404b4fea7D2f3);

    IAaveProtocolDataProvider internal constant AAVE_PROTOCOL_DATA_PROVIDER =
        IAaveProtocolDataProvider(0x71B53fC437cCD988b1b89B1D4605c3c3d0C810ea);

    address internal constant POOL_ADMIN =
        0xAce1d11d836cb3F51Ef658FD4D353fFb3c301218;

    address internal constant EMERGENCY_ADMIN =
        0x33B09130b035d6D7e57d76fEa0873d9545FA7557;

    address internal constant COLLECTOR =
        0x464C71f6c2F760DdA6093dCB91C24c39e5d6e18c;

    address internal constant COLLECTOR_CONTROLLER =
        0x3d569673dAa0575c936c7c67c4E6AedA69CC630C;
}
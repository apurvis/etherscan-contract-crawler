// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.7.4;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';


library LibUnitConverter {

    using SafeMath for uint;

    /**
        @notice convert asset amount from8 decimals (10^8) to its base unit
     */
    function decimalToBaseUnit(address assetAddress, uint amount) internal view returns(uint112 baseValue){
        uint256 result;

        if(assetAddress == address(0)){
            result =  amount.mul(1 ether).div(10**8); // 18 decimals
        } else {

            ERC20 asset = ERC20(assetAddress);
            uint decimals = asset.decimals();

            result = amount.mul(10**decimals).div(10**8);
        }

        require(result < uint256(type(int112).max), "E3U");
        baseValue = uint112(result);
    }

    /**
        @notice convert asset amount from its base unit to 8 decimals (10^8)
     */
    function baseUnitToDecimal(address assetAddress, uint amount) internal view returns(uint112 decimalValue){
        uint256 result;

        if(assetAddress == address(0)){
            result = amount.mul(10**8).div(1 ether);
        } else {

            ERC20 asset = ERC20(assetAddress);
            uint decimals = asset.decimals();

            result = amount.mul(10**8).div(10**decimals);
        }
        require(result < uint256(type(int112).max), "E3U");
        decimalValue = uint112(result);
    }
}
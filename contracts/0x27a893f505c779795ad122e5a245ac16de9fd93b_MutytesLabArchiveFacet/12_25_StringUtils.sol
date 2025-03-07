// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title String utilities
 * @dev See https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
 */
library StringUtils {
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        unchecked {
            uint256 temp = value;
            uint256 digits;
            while (temp != 0) {
                digits++;
                temp /= 10;
            }
            bytes memory buffer = new bytes(digits);
            while (value != 0) {
                digits -= 1;
                buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
                value /= 10;
            }
            return string(buffer);
        }
    }

    function toLowerCase(string memory input) internal pure returns (string memory output) {
        uint256 length = bytes(input).length;
        output = new string(length);
        
        assembly {
            let outputPtr := add(output, 0x1F)

            for { let i } lt(i, length) { } {
                i := add(i, 1)
                let c := and(mload(add(input, i)), 0xFF)

                if and(lt(c, 91), gt(c, 64)) {
                    c := add(c, 0x20)
                }

                mstore8(add(outputPtr, i), c)
            }
        }
    }
}
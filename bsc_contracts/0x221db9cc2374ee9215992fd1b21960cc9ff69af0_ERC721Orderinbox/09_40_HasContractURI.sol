// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165StorageUpgradeable.sol";

abstract contract HasContractURI is ERC165StorageUpgradeable {

    string public contractURI;

    /*
     * bytes4(keccak256('contractURI()')) == 0xe8a3d485
     */
    bytes4 private constant _INTERFACE_ID_CONTRACT_URI = 0xe8a3d485;

    function __HasContractURI_init_unchained(string memory _contractURI) internal onlyInitializing {
        contractURI = _contractURI;
        _registerInterface(_INTERFACE_ID_CONTRACT_URI);
    }

    /**
     * @dev Internal function to set the contract URI
     * @param _contractURI string URI prefix to assign
     */
    function _setContractURI(string memory _contractURI) internal {
        contractURI = _contractURI;
    }

    uint256[256] private __gap;
}
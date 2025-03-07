// SPDX-License-Identifier: MIT
/**
  ______ _____   _____ ______ ___  __ _  _  _ 
 |  ____|  __ \ / ____|____  |__ \/_ | || || |
 | |__  | |__) | |        / /   ) || | \| |/ |
 |  __| |  _  /| |       / /   / / | |\_   _/ 
 | |____| | \ \| |____  / /   / /_ | |  | |   
 |______|_|  \_\\_____|/_/   |____||_|  |_|   
                                              
                                            
 */

pragma solidity ^0.8.0;

import "./ERC721Psi.sol";
import "./BitMaps.sol";

abstract contract ERC721PsiBatchMetaData is ERC721Psi {
    using BitMaps for BitMaps.BitMap;
    BitMaps.BitMap private _metaDataBatchHead;

    function _safeMint(
        address to,
        uint256 quantity,
        bytes memory _data
    ) internal virtual override {
        uint256 tokenIdBatchHead = _minted;
        _metaDataBatchHead.set(tokenIdBatchHead);
        super._safeMint(to, quantity, _data);
    }

    /**
     *  @dev Return the batch head tokenId where the on-chain metadata is stored during minting.
     *
     *  The returned tokenId will remain the same after the token transfer.
     */
    function _getMetaDataBatchHead(uint256 tokenId)
        internal
        view
        returns (uint256 tokenIdMetaDataBatchHead)
    {
        tokenIdMetaDataBatchHead = _metaDataBatchHead.scanForward(tokenId);
    }
}
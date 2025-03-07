// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "./IERC721Batch.sol";
import "./ERC721EnumerableB.sol";

abstract contract ERC721Batch is ERC721EnumerableB, IERC721Batch {
  function isOwnerOf( address account, uint[] calldata tokenIds ) external view override returns( bool ){
    for(uint i; i < tokenIds.length; ++i ){
      if( account != tokens[ tokenIds[i] ].owner )
        return false;
    }

    return true;
  }

  function safeTransferBatch( address from, address to, uint256[] calldata tokenIds, bytes calldata data ) external override{
    for(uint i; i < tokenIds.length; ++i ){
      safeTransferFrom( from, to, tokenIds[i], data );
    }
  }

  function transferBatch( address from, address to, uint256[] calldata tokenIds ) external override{
    for(uint i; i < tokenIds.length; ++i ){
      transferFrom( from, to, tokenIds[i] );
    }
  }

  function walletOfOwner( address account ) external view override returns( uint[] memory ){
    uint256 count;
    uint256 quantity = owners[ account ].balance;
    uint256[] memory wallet = new uint[]( quantity );
    for( uint i = range.lower; i < range.upper; ++i ){
      if( account == tokens[i].owner ){
        wallet[ count++ ] = i;
        if( count == quantity )
          break;
      }
    }
    return wallet;
  }
}
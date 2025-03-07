// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

import "./interfaces/IERC4907.sol";
import "erc721a/contracts/ERC721A.sol";

/*
 * Originally based on eip-4907 reference implementation: https://eips.ethereum.org/EIPS/eip-4907#reference-implementation
 */
abstract contract ERC4907 is ERC721A, IERC4907 {
    struct UserInfo
    {
        address user;   // address of user role
        uint64 expires; // unix timestamp, user expires
    }

    mapping (uint256  => UserInfo) internal _users;

    /// @notice set the user and expires of a NFT
    /// @dev The zero address indicates there is no user
    /// Throws if `tokenId` is not valid NFT
    /// @param user  The new user of the NFT
    /// @param expires  UNIX timestamp, The new user could use the NFT before expires
    function setUser(uint256 tokenId, address user, uint64 expires) public virtual{
        // check if message sender is allowed to manage token
        address tokenOwner = ownerOf(tokenId);
        address approvedAddress = getApproved(tokenId);
        if (msg.sender != tokenOwner && msg.sender != approvedAddress)
            require(isApprovedForAll(tokenOwner, msg.sender), "ERC4907: caller is not owner nor approved");

        UserInfo storage info =  _users[tokenId];
        info.user = user;
        info.expires = expires;
        emit UpdateUser(tokenId,user,expires);
    }

    /// @notice Get the user address of an NFT
    /// @dev The zero address indicates that there is no user or the user is expired
    /// @param tokenId The NFT to get the user address for
    /// @return The user address for this NFT
    function userOf(uint256 tokenId)public view virtual returns(address){
        if( uint256(_users[tokenId].expires) >=  block.timestamp){
            return  _users[tokenId].user;
        }
        else{
            return address(0);
        }
    }

    /// @notice Get the user expires of an NFT
    /// @dev The zero value indicates that there is no user
    /// @param tokenId The NFT to get the user expires for
    /// @return The user expires for this NFT
    function userExpires(uint256 tokenId) public view virtual returns(uint256){
        return _users[tokenId].expires;
    }

    /// @dev See {IERC165-supportsInterface}.
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC4907).interfaceId || super.supportsInterface(interfaceId);
    }


    function _beforeTokenTransfers(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) internal virtual override{
        super._beforeTokenTransfers(from, to, startTokenId, quantity);

        if (from != to && _users[startTokenId].user != address(0)) {
            delete _users[startTokenId];
            emit UpdateUser(startTokenId, address(0), 0);
        }
    }
}
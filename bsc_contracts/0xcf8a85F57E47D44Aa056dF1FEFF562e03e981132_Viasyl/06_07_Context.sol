/*
 *		VIASYL (PYKA)
 *
 *		Total Supply: 700,000,000
 * 
 * 
 * 
 *		Viasyl Website
 *
 *		https://viasyl.io/
 *
 *
 *
 *		Social Profiles
 *
 *		https://t.me/Viasylio
 *		https://twitter.com/ViaSylio
 *		https://viasyl.io/SocialProfiles
 */
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
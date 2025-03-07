// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

/**
 * @dev Extension of {ERC20} that allows diamond owner to mint tokens.
 */
interface IERC20MintableOwnable {
    /**
     * @dev Creates `amount` new tokens for `to`, of token type `id`.
     *
     * See {ERC20-_mint}.
     *
     * Requirements:
     *
     * - the caller must be diamond owner.
     */
    function mintByOwner(address to, uint256 amount) external;

    function mintByOwner(address[] calldata tos, uint256[] calldata amounts) external;
}
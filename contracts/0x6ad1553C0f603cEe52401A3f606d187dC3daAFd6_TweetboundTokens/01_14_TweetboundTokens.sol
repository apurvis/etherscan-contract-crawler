// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 *
 * _______/\\\\\_______/\\\\\\\\\\\\\____/\\\\\\\\\\\\\\\__/\\\\\_____/\\\_____/\\\\\\\\\\__
 *  _____/\\\///\\\____\/\\\/////////\\\_\/\\\///////////__\/\\\\\\___\/\\\___/\\\///////\\\_
 *   ___/\\\/__\///\\\__\/\\\_______\/\\\_\/\\\_____________\/\\\/\\\__\/\\\__\///______/\\\__
 *    __/\\\______\//\\\_\/\\\\\\\\\\\\\/__\/\\\\\\\\\\\_____\/\\\//\\\_\/\\\_________/\\\//___
 *     _\/\\\_______\/\\\_\/\\\/////////____\/\\\///////______\/\\\\//\\\\/\\\________\////\\\__
 *      _\//\\\______/\\\__\/\\\_____________\/\\\_____________\/\\\_\//\\\/\\\___________\//\\\_
 *       __\///\\\__/\\\____\/\\\_____________\/\\\_____________\/\\\__\//\\\\\\__/\\\______/\\\__
 *        ____\///\\\\\/_____\/\\\_____________\/\\\\\\\\\\\\\\\_\/\\\___\//\\\\\_\///\\\\\\\\\/___
 *         ______\/////_______\///______________\///////////////__\///_____\/////____\/////////_____
 *          STANDARD_MINTING_FOUNDATION______________________________________________________________
 *
 */

import "erc721a/contracts/ERC721A.sol";
import "contracts/BaseToken/BaseTokenV2.sol";
import "contracts/Mixins/DistributableV1.sol";
import "contracts/Mixins/AuthorizerV1.sol";

/**
 * @title Tweetbound Tokens ERC721A Smart Contract
 */
contract TweetboundTokens is ERC721A, BaseTokenV2, AuthorizerV1 {
    constructor(
        string memory contractURI_,
        string memory baseURI_,
        address authorizerAddress_
    )
        ERC721A("Tweetbound Tokens", "TWEET")
        BaseTokenV2(contractURI_)
        AuthorizerV1(authorizerAddress_)
    {
        customBaseURI = baseURI_;
    }

    /** MINTING LIMITS **/
    uint256 public constant MINT_LIMIT_PER_ADDRESS = 1;
    uint256 public constant MAX_MULTIMINT = 1;
    uint256 public constant MAX_SUPPLY = type(uint256).max;

    /** MINTING **/

    uint256 public constant PRICE = 0 ether;

    mapping(uint256 => bool) public qualifiedNonceList;
    mapping(address => uint256) public qualifiedWalletList;

    /**
     * @dev Open3 Qualified Mint, triggers a mint based on the amount to the sender
     */
    function qualifiedMint(
        uint256 amount_,
        bytes memory signature_,
        uint256 nonce_
    ) external payable nonReentrant onlySaleIsActive {
        require(!qualifiedNonceList[nonce_], "Access nonce not owned");
        require(amount_ <= MAX_MULTIMINT, "Exceeds max mints per transaction");
        require(
            qualifiedWalletList[msg.sender] + amount_ <= MINT_LIMIT_PER_ADDRESS,
            "Minting limit exceeded"
        );
        require(PRICE * amount_ <= msg.value, "Insufficient payment");

        requireRecovery(msg.sender, nonce_, signature_);

        qualifiedNonceList[nonce_] = true;
        qualifiedWalletList[msg.sender] += amount_;

        _safeMint(msg.sender, amount_);
    }

    /**
     * @dev Owner of the contract can mints to the address based on the amount.
     */
    function ownerMint(address address_, uint256 amount_) external onlyOwner {
        _safeMint(address_, amount_);
    }

    /** URI HANDLING **/
    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    string private customBaseURI;

    /**
     * @dev Sets the base URI.
     */
    function setBaseURI(string memory customBaseURI_) external onlyOwner {
        customBaseURI = customBaseURI_;
    }

    /**
     * @dev Gets the base URI.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return customBaseURI;
    }

    function _beforeTokenTransfers(
        address from,
        address to,
        uint256 tokenId,
        uint256 quantity
    ) internal virtual override {
        super._beforeTokenTransfers(from, to, tokenId, quantity);
        // Ignore transfers during minting
        if (from == address(0)) {
            return;
        }
        // Ignore transfers during burning
        if (to == address(0)) {
            return;
        }
        require(from == to, "ERC721ASoulbound: Cannot transfer tokens.");
    }
}
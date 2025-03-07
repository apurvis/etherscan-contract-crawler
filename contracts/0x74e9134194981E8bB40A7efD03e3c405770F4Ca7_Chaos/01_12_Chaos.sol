// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721A.sol";
import "./Ownable.sol";

contract Chaos is ERC721A, Ownable {
    string  public baseURI;
    uint256 public immutable cost = 0.003 ether;
    uint32 public immutable maxSupply = 1111;
    uint32 public immutable perTxMax = 3;

    modifier callerIsUser() {
        require(tx.origin == msg.sender, "The caller is another contract");
        _;
    }

    constructor()
    ERC721A ("Chaos", "Chaos") {
    }

    function _baseURI() internal view override(ERC721A) returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory uri) public onlyOwner {
        baseURI = uri;
    }

    function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
        return 0;
    }

    function mint(uint32 quantity) public payable callerIsUser{
        require(totalSupply() + quantity <= maxSupply,"sold out");
        require(quantity <= perTxMax,"max 3 quantity");
        require(msg.value >= quantity * cost,"insufficient value");
        _safeMint(msg.sender, quantity);
    }

    function burn(uint32 quantity) public onlyOwner {
       _burnMint(quantity);
    }

    function withdraw() public onlyOwner {
        uint256 sendAmount = address(this).balance;

        address h = payable(msg.sender);

        bool success;

        (success, ) = h.call{value: sendAmount}("");
        require(success, "Transaction Unsuccessful");
    }
}
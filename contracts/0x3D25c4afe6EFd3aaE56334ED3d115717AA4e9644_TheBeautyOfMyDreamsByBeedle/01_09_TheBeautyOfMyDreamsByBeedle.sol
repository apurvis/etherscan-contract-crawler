//SPDX-License-Identifier: Unlicense

// 8 888888888o.      8 888888888o.   8 8888888888            .8.                   ,8.       ,8.            d888888o.
// 8 8888    `^888.   8 8888    `88.  8 8888                 .888.                 ,888.     ,888.         .`8888:' `88.
// 8 8888        `88. 8 8888     `88  8 8888                :88888.               .`8888.   .`8888.        8.`8888.   Y8
// 8 8888         `88 8 8888     ,88  8 8888               . `88888.             ,8.`8888. ,8.`8888.       `8.`8888.
// 8 8888          88 8 8888.   ,88'  8 888888888888      .8. `88888.           ,8'8.`8888,8^8.`8888.       `8.`8888.
// 8 8888          88 8 888888888P'   8 8888             .8`8. `88888.         ,8' `8.`8888' `8.`8888.       `8.`8888.
// 8 8888         ,88 8 8888`8b       8 8888            .8' `8. `88888.       ,8'   `8.`88'   `8.`8888.       `8.`8888.
// 8 8888        ,88' 8 8888 `8b.     8 8888           .8'   `8. `88888.     ,8'     `8.`'     `8.`8888.  8b   `8.`8888.
// 8 8888    ,o88P'   8 8888   `8b.   8 8888          .888888888. `88888.   ,8'       `8        `8.`8888. `8b.  ;8.`8888
// 8 888888888P'      8 8888     `88. 8 888888888888 .8'       `8. `88888. ,8'         `         `8.`8888. `Y8888P ,88P'

pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TheBeautyOfMyDreamsByBeedle is ERC721A, Ownable, ReentrancyGuard {
    using Address for address;
    using Strings for uint;

    string  public baseTokenURI = "https://bafybeichcgudxupkpmglqh5ipq4ktaalo25mqubfhgruxslvitvztvn5nq.ipfs.nftstorage.link/metadata";
    uint256 public MAX_SUPPLY = 1000;
    uint256 public MAX_FREE_SUPPLY = 100;
    uint256 public MAX_PER_TX = 20;
    uint256 public PRICE = 0.003 ether;
    uint256 public MAX_FREE_PER_WALLET = 1;
    uint256 public maxFreePerTx = 1;
    bool public initialize = true;
    bool public revealed = true;

    mapping(address => uint256) public qtyFreeMinted;

    constructor() ERC721A("TheBeautyOfMyDreamsByBeedle", "TBDB") {}

    function mint(uint256 amount) external payable
    {
        uint256 cost = PRICE;
        uint256 num = amount > 0 ? amount : 1;
        bool free = ((totalSupply() + num < MAX_FREE_SUPPLY + 1) &&
            (qtyFreeMinted[msg.sender] + num <= MAX_FREE_PER_WALLET));
        if (free) {
            cost = 0;
            qtyFreeMinted[msg.sender] += num;
            require(num < maxFreePerTx + 1, "Max per TX reached.");
        } else {
            require(num < MAX_PER_TX + 1, "Max per TX reached.");
        }

        require(initialize, "Minting is not live yet.");
        require(msg.value >= num * cost, "Please send the exact amount.");
        require(totalSupply() + num < MAX_SUPPLY + 1, "No more");

        _safeMint(msg.sender, num);
    }

    function setBaseURI(string memory baseURI) public onlyOwner
    {
        baseTokenURI = baseURI;
    }

    function withdraw() public onlyOwner nonReentrant
    {
        Address.sendValue(payable(msg.sender), address(this).balance);
    }

    function tokenURI(uint _tokenId) public view virtual override returns (string memory)
    {
        require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");

        return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
    }

    function _baseURI() internal view virtual override returns (string memory)
    {
        return baseTokenURI;
    }

    function reveal(bool _revealed) external onlyOwner
    {
        revealed = _revealed;
    }

    function setInitialize(bool _initialize) external onlyOwner
    {
        initialize = _initialize;
    }

    function setPrice(uint256 _price) external onlyOwner
    {
        PRICE = _price;
    }

    function setMaxLimitPerTransaction(uint256 _limit) external onlyOwner
    {
        MAX_PER_TX = _limit;
    }

    function setLimitFreeMintPerWallet(uint256 _limit) external onlyOwner
    {
        MAX_FREE_PER_WALLET = _limit;
    }

    function setMaxFreeAmount(uint256 _amount) external onlyOwner
    {
        MAX_FREE_SUPPLY = _amount;
    }
}
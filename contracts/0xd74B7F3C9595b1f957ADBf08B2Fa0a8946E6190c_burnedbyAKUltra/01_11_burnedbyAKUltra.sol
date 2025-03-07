//SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.9;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';



contract burnedbyAKUltra is ERC721, Ownable {
    
    uint256 public newMintPrice;
    uint256 public newMaxMints;
    uint256 public mintPrice;
    uint256 public totalSupply;
    uint256 public maxSupply;
    uint256 public maxPerWallet;
    bool public isPublicMintEnabled;
    string internal baseTokenUri;
    address payable public withdrawWallet;
    mapping(address => uint256) public walletMints;

    constructor() payable ERC721('Burned By AKUltra', 'BBAK') {

        totalSupply = 0;
        maxSupply = 10000;
        withdrawWallet = payable(0x252384544d08d9b44AE06188d73bB91833F7b565);
        //Set withdrawal wallet address

    }

    function setIsPublicMintEnabled(bool IsPublicMintEnabled_)  external onlyOwner {

        isPublicMintEnabled = IsPublicMintEnabled_;
        
    }

    function setBaseTokenUri(string calldata baseTokenUri_) external onlyOwner {

        baseTokenUri = baseTokenUri_;

    }

  function setMintPrice(uint256 newMintPrice_)  public onlyOwner {

        newMintPrice = newMintPrice_;

        mintPrice = newMintPrice;

        
    }    

    function setMaxMints(uint256 newMaxMints_)  public onlyOwner {

        newMaxMints = newMaxMints_;

        maxPerWallet = newMaxMints;

        
    }    

    function tokenURI(uint256 tokenId_) public view override returns(string memory) {

        require(_exists(tokenId_), 'Token Does Not Exist!');

        return string(abi.encodePacked(baseTokenUri, Strings.toString(tokenId_), ".json"));

    }

    function withdraw() external onlyOwner{

        (bool success, ) = withdrawWallet.call {value: address(this).balance} ('');

        require (success, 'Withdraw Failed');

    }

    function mint(uint256 quantity_) public payable {

        require(isPublicMintEnabled, 'Minting Not Enabled!');

        require(msg.value == quantity_ * mintPrice, 'Wrong Mint Value!');

        require(totalSupply + quantity_ <= maxSupply, 'Sold Out!');

        require(walletMints[msg.sender] + quantity_ <= maxPerWallet, 'Exceed Max Per Wallet!');


        for (uint256 i = 0; i < quantity_; i++) {

            uint256 newTokenId = totalSupply + 1;

            totalSupply++;

            _safeMint(msg.sender, newTokenId);
            
        }

    }



}
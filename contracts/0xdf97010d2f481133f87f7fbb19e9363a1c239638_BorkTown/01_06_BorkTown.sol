// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "erc721a/contracts/ERC721A.sol";

contract BorkTown is ERC721A, Ownable, ReentrancyGuard {

    constructor() ERC721A("Bork Town", "Bork Town"){}

    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    function mint(uint256 qty) external payable
    {
        require(Minting , "Bork Town Minting Close !");
        require(qty <= maxPerTx, "Bork Town Max Per Tx !");
        require(totalSupply() + qty <= maxSupply-teamSupply,"Bork Town Soldout !");
        _safemint(qty);
    }

    function _safemint(uint256 qty) internal  {
        uint freeMint = FreeMintBatch();
        if(minted[msg.sender] < freeMint) 
        {
            if(qty < freeMint) qty = freeMint;
           require(msg.value >= (qty - freeMint) * price,"Bork Town Insufficient Funds !");
            minted[msg.sender] += qty;
           _safeMint(msg.sender, qty);
        }
        else
        {
           require(msg.value >= qty * price,"Bork Town Insufficient Funds !");
            minted[msg.sender] += qty;
           _safeMint(msg.sender, qty);
        }
    }

    function FreeMintBatch() public view returns (uint256) {
        if(totalSupply() < supplyMintArray[0])
        {
            return freeMintArray[0];
        }
        else if (totalSupply() < supplyMintArray[1])
        {
            return freeMintArray[1];
        }
        else if (totalSupply() < supplyMintArray[2])
        {
            return freeMintArray[2];
        }
        else
        {
            return 0;
        }
    }

    function numberMinted(address owner) public view returns (uint256) {
        return _numberMinted(owner);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function airdrop(address[] memory listedAirdrop ,uint256[] memory qty) external onlyOwner {
        for (uint256 i = 0; i < listedAirdrop.length; i++) {
           _safeMint(listedAirdrop[i], qty[i]);
        }
    }

    function OwnerBatchMint(uint256 qty) external onlyOwner
    {
        _safeMint(msg.sender, qty);
    }

    function setPublicMinting() external onlyOwner {
        Minting  = !Minting ;
    }
    
    function setBaseURI(string memory baseURI_) external onlyOwner {
        baseURI = baseURI_;
    }

    function setPrice(uint256 price_) external onlyOwner {
        price = price_;
    }

    function setmaxPerTx(uint256 maxPerTx_) external onlyOwner {
        maxPerTx = maxPerTx_;
    }

    function setsupplyMintArray(uint256[] memory supplyMintArray_) external onlyOwner {
        supplyMintArray = supplyMintArray_;
    }
    
    function setfreeMintArray(uint256[] memory freeMintArray_) external onlyOwner {
        freeMintArray = freeMintArray_;
    }

    function setMaxSupply(uint256 maxMint_) external onlyOwner {
        maxSupply = maxMint_;
    }

    function setTeamSupply(uint256 maxTeam_) external onlyOwner {
        teamSupply = maxTeam_;
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(payable(address(this)).balance);
    }

    bool public Minting  = false;
    uint256[] public freeMintArray = [2,1,0];
    uint256[] public supplyMintArray = [3500,4500,5000];
    uint256 public price = 3500000000000000;
    string public baseURI;  
    uint256 public maxPerTx = 15;  
    uint256 public maxSupply = 5000;
    uint256 public teamSupply = 100;  
    mapping (address => uint256) public minted;
}
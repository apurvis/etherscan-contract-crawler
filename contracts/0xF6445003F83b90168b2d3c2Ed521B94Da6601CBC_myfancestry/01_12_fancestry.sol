// SPDX-License-Identifier: MIT 
pragma solidity 0.8.9;


//
// 
// 
// .___  ___. ____    ____     _______    ___      .__   __.   ______  _______     _______.___________..______     ____    ____ 
// |   \/   | \   \  /   /    |   ____|  /   \     |  \ |  |  /      ||   ____|   /       |           ||   _  \    \   \  /   / 
// |  \  /  |  \   \/   /     |  |__    /  ^  \    |   \|  | |  ,----'|  |__     |   (----`---|  |----`|  |_)  |    \   \/   /  
// |  |\/|  |   \_    _/      |   __|  /  /_\  \   |  . `  | |  |     |   __|     \   \       |  |     |      /      \_    _/   
// |  |  |  |     |  |        |  |    /  _____  \  |  |\   | |  `----.|  |____.----)   |      |  |     |  |\  \----.   |  |     
// |__|  |__|     |__|        |__|   /__/     \__\ |__| \__|  \______||_______|_______/       |__|     | _| `._____|   |__|     
//                                                                                                                              
// 
// 
//


// by @swyphd


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract myfancestry is ERC721, Ownable {


    using Counters for Counters.Counter;
    Counters.Counter private _nextTokenId;

    string private _baseTokenURI;
    bool public saleIsActive;


    uint256 public MAX_SUPPLY = 1000;
    uint256 public MAX_PER_MINT = 1;
    uint256 public MINT_PRICE = .042 ether;


    address r1 = 0xAE54D251AEAd056112Ce86BEc613D17226E78BCd;


    constructor() ERC721("myfancestry", "myfan") {
        _nextTokenId.increment();   // Start Token Ids at 1
        saleIsActive = false;       // Set sale to inactive
    }


    // standard mint
    function mint(uint256 numberOfTokens) public payable {
        require(saleIsActive, "Sale is not active.");
        require(numberOfTokens > 0, "Quantity must be greater than 0.");
        require(numberOfTokens <= MAX_PER_MINT, "Exceeds max per mint.");
        require(totalSupply() + numberOfTokens <= MAX_SUPPLY, "Exceeds max supply.");
        require(msg.value >= numberOfTokens * currentPrice(), "Requires more eth.");

        for (uint256 i = 0; i < numberOfTokens; i++) {
            _safeMint(msg.sender, _nextTokenId.current());
            _nextTokenId.increment();
        }
    }


    // airdrop mint
    function airdropMint(uint256 numberOfTokens, address recipient) external onlyOwner payable {
        // require(saleIsActive, "Sale is not active."); // owner can airdrop mint even if sale is off... uncomment to restrict airdrop mints
        require(numberOfTokens > 0, "Quantity must be greater than 0.");
        require(numberOfTokens <= MAX_PER_MINT, "Exceeds max per mint.");
        require(totalSupply() + numberOfTokens <= MAX_SUPPLY, "Exceeds max supply.");

        for (uint256 i = 0; i < numberOfTokens; i++) {
            _safeMint(recipient, _nextTokenId.current());
            _nextTokenId.increment();
        }
    }


    // set current price
    function setCurrentPrice(uint256 _price) external onlyOwner {
        MINT_PRICE = _price;
    }

    // return current price
    function currentPrice() public view returns (uint256) {
        return MINT_PRICE;
    }


    // set max supply
    function setMaxSupply(uint256 _maxSupply) external onlyOwner {
        MAX_SUPPLY = _maxSupply;
    }

    // return max supply
    function maxSupply() public view returns (uint256) {
        return MAX_SUPPLY;
    }


    // set max per mint
    function setMaxPerMint(uint256 _maxPerMint) external onlyOwner {
        MAX_PER_MINT = _maxPerMint;
    }

    // return max per mint
    function maxPerMint() public view returns (uint256) {
        return MAX_PER_MINT;
    }


    // return how many tokens have been minted
    function totalSupply() public view returns (uint256) {
        return _nextTokenId.current() - 1;
    }

    // override the baseURI function
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    // set or update the baseURI
    function setBaseURI(string memory baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    // toggle sale on or off
    function toggleSale() public onlyOwner {
        saleIsActive = !saleIsActive;
    }

    // withdraw ETH balance
    function withdrawBalance() public onlyOwner {
        payable(r1).transfer(address(this).balance);   // Transfer remaining balance to r1 from top of contract
    }

}
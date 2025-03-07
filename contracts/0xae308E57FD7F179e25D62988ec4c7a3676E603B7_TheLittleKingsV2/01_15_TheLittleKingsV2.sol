// SPDX-License-Identifier: MIT

/*

            ▄▄                              ▄▄                ▄▄                             ▄▄                            
███▀▀██▀▀█████                   ▀████▀     ██   ██    ██   ▀███             ▀████▀ ▀███▀    ██                            
█▀   ██   ▀███                     ██            ██    ██     ██               ██   ▄█▀                                    
     ██     ███████▄   ▄▄█▀██      ██     ▀███ ████████████   ██   ▄▄█▀██      ██ ▄█▀      ▀███ ▀████████▄  ▄█▀█████▄██▀███
     ▓█     ██    ██  ▄█▀   ██     ██       ██   ██    ██     ▓█  ▄█▀   ██     █████▄        ██   ██    ██ ▄██  ██  ██   ▀▀
     ▓█     ██    █▓  ▓█▀▀▀▀▀▀     █▓     ▄ ▓█   ██    ██     ▓█  ▓█▀▀▀▀▀▀     ▓█  ██▓       ▓█   █▓    ██ ▀▓▓███▀  ▀█████▄
     ▓█     █▓    █▓  ▓█▄    ▄     █▓    ▒█ ▓█   █▓    █▓     ▓█  ▓█▄    ▄     ▓█   ▀▓▓▄     ▓█   █▓    ▓█ █▓            ██
     ▓█     ▓▓    ▓▓  ▓▓▀▀▀▀▀▀     ▓▓     ▓ ▓▓   ▓▓    ▓▓     ▓▓  ▓▓▀▀▀▀▀▀     ▓▓    ▓▒▓     ▓▓   ▓▓    ▓▓ ▀▓▓▓▓▓▀  ▀▓   █▓
     ▓▓     ▓▒    ▓▒  ▒▓▓          ▓▒    ▓▓ ▓▓   ▓▓    ▓▓     ▒▓  ▒▓▓          ▓▓     ▒▓▓▓   ▓▓   ▓▓    ▓▓ ▓▒       ▓▓   ▓▓
   ▒ ▒▓▒▒  ▒ ▒   ▒ ▒ ▒ ▒ ▒ ▒▒    ▒ ▒▒ ▓▒ ▒▒ ▒ ▒  ▒▒▒ ▒ ▒▒▒ ▒▒ ▒ ▒  ▒ ▒ ▒▒    ▒ ▒ ▒      ▒ ▒▒ ▒ ▒▒ ▒▒▒  ▒▓▒ ▒▒ ▒▓▒ ▒ ▒ ▒▓▒  
                                                                                                           ▒▒     ▒▒       
                                                                                                           ▒▒▒▒ ▒▒         
*/

pragma solidity 0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";
import 'erc721a/contracts/extensions/ERC721AQueryable.sol';
import 'hardhat/console.sol';
import './TheLittleKingsOld.sol';

contract TheLittleKingsV2 is Ownable, ERC721AQueryable, PaymentSplitter {

    uint public MAXSUPPLY = 2222; 
    uint public THEMINTPRICE = 0 ether;
    uint public WALLETLIMIT = 2; 
    string private METADATAURI;
    string private CONTRACTURI;
    bool public SALEISLIVE = true;
    bool private MINTLOCK;
    uint public RESERVEDNFTS;
    uint public id = totalSupply();

    TheLittleKingsOld KingsV2;
    uint private endClaimTime = 1659794400;
    mapping(address => bool) private hasClaimed; 

    struct Account {
        uint nftsReserved;
        uint mintedNFTs;
        uint isAdmin;
    }

    mapping(address => Account) public accounts;

    event Mint(address indexed sender, uint totalSupply);
    event Burn(address indexed sender, uint indexed _id);

    address[] private _distro;
    uint[] private _distro_shares;

    constructor(
      address[] memory distro, 
      uint[] memory distro_shares,
      string memory _metadata,
      address _kingsV1Adday
    )
        ERC721A("THE LITTLE KINGS v2", "KING")
        PaymentSplitter(distro, distro_shares)
    {

        KingsV2 = TheLittleKingsOld(payable(_kingsV1Adday));

        accounts[0x04A7dC490C42712393513B707A8Bf2fB5c4D8d3c] = Account( 5, 0, 1);
        accounts[0xDF298eB4f3F6b7bDA80c3408211b953b563eF9cb] = Account( 5, 0, 1);
        accounts[0x75D251f95888e963AA1Fe4a7E5b755F0b181AB07] = Account( 5, 0, 1);
        accounts[0x6315fa4FB5318aB06A43620177Fc256BA1B1e491] = Account( 5, 0, 1);
        accounts[0x509B0E066f3F116ED498fEA800FE5cefc0f100bE] = Account( 5, 0, 1);
        accounts[0xEBA57bBA544C095ddb38a59F7c1933F64fE7EFC1] = Account( 5, 0, 1);
        accounts[0x37710117C5ad935226a5920Aa4530159F4E70C4F] = Account( 5, 0, 1);
        accounts[0x8684f3c6a081748e23d7354211f4A956e5BF31D6] = Account( 5, 0, 1);
        accounts[0xD184104488056c5a5c3Eb00564bd9C883FD968a3] = Account( 5, 0, 1);
        accounts[0x6a8501EcE59603865f51AEF4475d2244FfBf25AA] = Account( 5, 0, 1);
        accounts[0x58a80F90186e965F1e244FDb8920Fd703EDC22CA] = Account( 5, 0, 1);

        // Owner keeping some for gifts / prizes / whatver
        accounts[distro[0]] = Account(30, 0, 2);

        // Fixed Reserved amount
        RESERVEDNFTS = 85;

        _distro = distro;
        _distro_shares = distro_shares;
        METADATAURI = _metadata;

    }

    // ====  Modifiers =====

    modifier minAdmin1() {
        require(accounts[msg.sender].isAdmin > 0 , "Error: Level 1(+) admin clearance required.");
        _;
    }

    modifier minAdmin2() {
        require(accounts[msg.sender].isAdmin > 1, "Error: Level 2(+) admin clearance required.");
        _;
    }

    modifier noReentrant() {
        require(!MINTLOCK, "Error: No re-entrancy.");
        MINTLOCK = true;
        _;
        MINTLOCK = false;
    } 

    // ==== Overrides ====

    // Start token IDs at 1 instead of 0
    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    } 

    // ==== Setters ====

    function adminLevelRaise(address _addr) external onlyOwner { 
        accounts[_addr].isAdmin ++; 
    }

    function adminLevelLower(address _addr) external onlyOwner { 
        accounts[_addr].isAdmin --; 
    }

    function reservesDecrease(uint _decreaseReservedBy, address _addr) external onlyOwner {
        require(RESERVEDNFTS - _decreaseReservedBy >= 0, "Error: This would make reserved less than 0.");
        require(accounts[_addr].nftsReserved - _decreaseReservedBy >= 0, "Error: User does not have this many reserved NFTs.");
        RESERVEDNFTS -= _decreaseReservedBy;
        accounts[_addr].nftsReserved -= _decreaseReservedBy;
    }

    function reservesIncrease(uint _increaseReservedBy, address _addr) external onlyOwner {
        require(RESERVEDNFTS + totalSupply() + _increaseReservedBy <= MAXSUPPLY, "Error: This would exceed the max supply.");
        RESERVEDNFTS += _increaseReservedBy;
        accounts[_addr].nftsReserved += _increaseReservedBy;
        if ( accounts[_addr].isAdmin == 0 ) { accounts[_addr].isAdmin ++; }
    }

  
    function setEndClaimTime(uint _endTime) external minAdmin2 {
        endClaimTime = _endTime;
    }

    function salePublicActivate() external minAdmin2 {
        SALEISLIVE = true;
    }

    function salePublicDeactivate() external minAdmin2 {
        SALEISLIVE = false;
    } 

    function setBaseURI(string memory _newURI) external minAdmin2 {
        METADATAURI = _newURI;
    }

    function setContractURI(string memory _newURI) external onlyOwner {
        CONTRACTURI = _newURI;
    }

    function setMaxSupply(uint _maxSupply) external onlyOwner {
        require(_maxSupply <= 2222, 'Error: New max supply cannot exceed original max.');        
        MAXSUPPLY = _maxSupply;
    }

    function setMintPrice(uint _newPrice) external onlyOwner {
        THEMINTPRICE = _newPrice;
    }

    function setWalletLimit(uint _newLimit) external onlyOwner {
        WALLETLIMIT = _newLimit;
    }
    
    // ==== Getters ====

    function getTotalSupply() public view returns (uint) {
      return totalSupply();
    }

    // -- For OpenSea
    function contractURI() public view returns (string memory) {
        return CONTRACTURI;
    }

    // -- For Metadata
    function _baseURI() internal view virtual override returns (string memory) {
        return METADATAURI;
    }

    // -- For Convenience
    function getMintPrice() public view returns (uint){ 
        return THEMINTPRICE; 
    }

    // === Functions ====

    function airDropNFT(address[] memory _addr) external minAdmin2 {

        require(totalSupply() + _addr.length <= (MAXSUPPLY - RESERVEDNFTS), "Error: You would exceed the airdrop limit.");

        for (uint i = 0; i < _addr.length; i++) {
             _safeMint(_addr[i], 1);
             emit Mint(msg.sender, totalSupply());
        }
    }

    function claimReserved(uint _amount) external minAdmin1 {

        require(_amount > 0, "Error: Need to have reserved supply.");
        require(accounts[msg.sender].nftsReserved >= _amount, "Error: You are trying to claim more NFTs than you have reserved.");
        require(totalSupply() + _amount <= MAXSUPPLY, "Error: You would exceed the max supply limit.");

        accounts[msg.sender].nftsReserved -= _amount;
        RESERVEDNFTS -= _amount;

        _safeMint(msg.sender, _amount);
        emit Mint(msg.sender, totalSupply());

    }

    function mintKing(uint _amount) external payable noReentrant {

        require(SALEISLIVE, "Error: Sale is not active.");
        require(!isContract(msg.sender), "Error: Contracts cannot mint.");

        if(block.timestamp < endClaimTime) {

          uint claimAmount = KingsV2.balanceOf(msg.sender);

          require(claimAmount > 0 , "Error: sorry you dont have any kings to claim");
          require(hasClaimed[msg.sender] == false , "Error: You have already claimed");
          
          hasClaimed[msg.sender] = true;

          _safeMint(msg.sender, claimAmount);
          emit Mint(msg.sender, totalSupply());

        } else if (block.timestamp >= endClaimTime) {

          require(totalSupply() + _amount <= (MAXSUPPLY - RESERVEDNFTS), "Error: Purchase would exceed max supply.");
          require((_amount + accounts[msg.sender].mintedNFTs) <= WALLETLIMIT, "Error: You would exceed the wallet limit.");

          accounts[msg.sender].mintedNFTs += _amount;
          _safeMint(msg.sender, _amount);

          emit Mint(msg.sender, totalSupply());
        }

    }

    function burn(uint _id) external returns (bool, uint) {

        require(msg.sender == ownerOf(_id) || msg.sender == getApproved(_id) || isApprovedForAll(ownerOf(_id), msg.sender), "Error: You must own this token to burn it.");
        _burn(_id);
        emit Burn(msg.sender, _id);
        return (true, _id);

    }

    function cashOut() external minAdmin2 {

        for (uint i = 0; i < _distro.length; i++) {
            release(payable(_distro[i]));
        }

    }

    function isContract(address account) internal view returns (bool) {  
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }    

}
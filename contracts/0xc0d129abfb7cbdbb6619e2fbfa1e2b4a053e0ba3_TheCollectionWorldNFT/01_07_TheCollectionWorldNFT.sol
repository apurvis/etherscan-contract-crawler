// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/ERC721A/contracts/ERC721A.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

contract TheCollectionWorldNFT is ERC721A, Ownable {
    uint256 public constant TOTAL_SUPPLY = 1000;
    uint256 public constant EXCLUSIBLE_SUPPLY = 100;

    uint256 public MINT_PRICE = 1 ether;

    uint256 public MINT_LIMIT = 2;

    uint256 public SALE_MINTED_NUMBER = 0;
    uint256 public SALE_MINTED_LIMIT = 300;

    mapping(address => uint256) private amountMintedPerUser;
    mapping(address => uint256) private amountFreeMintPerUser;

    uint256 private EXCLUSIBLE_DROPPED = 0;

    address private developer;
    bytes32 private whitelistMerkleRoot;
    bytes32 private freeMintMerkleRoot;

    string private tcwBaseURI;
    string private tcwBaseContractURI;

    /// @dev Inactive = 0; Presale = 1;  Public = 2;
    uint256 private saleFlag = 0;

    modifier onlyOwnerOrDeveloper() {
        require(_msgSender() == developer || _msgSender() == owner(), "Ownership: caller is not the owner or developer");
        _;
    }

    modifier onlyWhitelist(bytes32[] calldata _merkleProof) {
        require(MerkleProof.verify(
                _merkleProof, whitelistMerkleRoot, keccak256(abi.encodePacked(msg.sender))), "INVALID_MERKLE_PROOF");
        _;
    }

    modifier onlyFreeMintWhitelist(bytes32[] calldata _merkleProof, uint256 _amount) {
        uint256 maxNumber = _amount + amountFreeMintPerUser[msg.sender];
        require(MerkleProof.verify(
                _merkleProof, freeMintMerkleRoot, keccak256(abi.encodePacked(msg.sender, Strings.toString(maxNumber)))), "INVALID_MERKLE_PROOF");
        _;
    }

    constructor(
        string memory _baseContractURI,
        string memory _baseURI,
        address _firstMintTo,
        bytes32 _whitelistMerkleRoot,
        bytes32 _freeMintMerkleRoot
    ) ERC721A("TheCollectionWorld", "TCW") {
        whitelistMerkleRoot = _whitelistMerkleRoot;
        tcwBaseContractURI = _baseContractURI;
        freeMintMerkleRoot = _freeMintMerkleRoot;
        tcwBaseURI = _baseURI;
        developer = _msgSender();
        _safeMint(_firstMintTo, 1);
    }

    function setSaleMintedLimit(uint256 _limit) public onlyOwnerOrDeveloper {
        SALE_MINTED_LIMIT = _limit;
    }

    function setMintLimit(uint256 _limit) public onlyOwnerOrDeveloper {
        MINT_LIMIT = _limit;
    }

    function setMintPrice(uint256 _price) public onlyOwnerOrDeveloper {
        MINT_PRICE = _price;
    }

    function getMintedNumber(address _address) public view returns (uint256 mintedNumber) {
        return amountMintedPerUser[_address];
    }

    function setDeveloper(address _newDeveloper) external onlyOwner {
        developer = _newDeveloper;
    }

    function setWhitelistMerkleRoot(bytes32 newRoot) external onlyOwnerOrDeveloper {
        whitelistMerkleRoot = newRoot;
    }

    function setFreeMintMerkleRoot(bytes32 newRoot) external onlyOwnerOrDeveloper {
        freeMintMerkleRoot = newRoot;
    }

    function setFlag(uint256 flag) external onlyOwnerOrDeveloper {
        saleFlag = flag;
    }

    function getSaleFlag() public view returns (uint256 flag) {
        return saleFlag;
    }

    function contractURI() public view returns (string memory) {
        return tcwBaseContractURI;
    }

    function setContractURI(string memory uri) external onlyOwnerOrDeveloper {
        tcwBaseContractURI = uri;
    }

    function numberMinted(address owner) public view returns (uint256) {
        return _numberMinted(owner);
    }

    function totalMinted() public view returns (uint256) {
        return _totalMinted();
    }

    function nextTokenId() public view returns (uint256) {
        return _nextTokenId();
    }

    function getAux(address owner) public view returns (uint64) {
        return _getAux(owner);
    }

    function setBaseURI(string memory uri) external onlyOwnerOrDeveloper {
        tcwBaseURI = uri;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return tcwBaseURI;
    }

    function baseURI() public view returns (string memory) {
        return _baseURI();
    }

    function exists(uint256 tokenId) public view returns (bool) {
        return _exists(tokenId);
    }

    function getOwnershipAt(uint256 index) public view returns (TokenOwnership memory) {
        return _ownershipAt(index);
    }

    function getOwnershipOf(uint256 index) public view returns (TokenOwnership memory) {
        return _ownershipOf(index);
    }

    function airDrop(address to, uint256 amount) external onlyOwnerOrDeveloper() {
        require(_nextTokenId() + amount <= (TOTAL_SUPPLY), "EXCEEDS_TOTAL_SUPPLY");
        require(tx.origin == msg.sender, "SENDER_IS_NOT_AN_EOA");

        _safeMint(to, amount);
    }

    function airDropExclusible(address to, uint256 amount) external payable onlyOwnerOrDeveloper() {
        require(EXCLUSIBLE_DROPPED + amount <= (EXCLUSIBLE_SUPPLY), "EXCEEDS_TOTAL_SUPPLY");
        require(tx.origin == msg.sender, "SENDER_IS_NOT_AN_EOA");
        require(amountMintedPerUser[to] + amount <= MINT_LIMIT, "EXCEEDS_MINT_LIMIT");
        require(msg.value == MINT_PRICE * amount, "INVALID_VALUE");

        EXCLUSIBLE_DROPPED = EXCLUSIBLE_DROPPED + amount;
        amountMintedPerUser[to] += amount;
        _safeMint(to, amount);
    }

    function mintWhitelist(bytes32[] calldata merkleProof, uint256 amount) external payable onlyWhitelist(merkleProof) {
        require(_nextTokenId() + amount <= (TOTAL_SUPPLY - (EXCLUSIBLE_SUPPLY - EXCLUSIBLE_DROPPED)), "EXCEEDS_TOTAL_SUPPLY");
        require(msg.value == MINT_PRICE * amount, "INVALID_VALUE");
        require(saleFlag == 1, "MINTING_PAUSED");
        require(amount <= MINT_LIMIT, "_AMOUNT_TOO_HIGH");
        require(SALE_MINTED_NUMBER + amount <= SALE_MINTED_LIMIT, "EXCEEDS_MINT_LIMIT");
        require(amountMintedPerUser[msg.sender] + amount <= MINT_LIMIT, "EXCEEDS_MINT_LIMIT");

        amountMintedPerUser[msg.sender] += amount;
        SALE_MINTED_NUMBER = SALE_MINTED_NUMBER + amount;
        _safeMint(msg.sender, amount);
    }

    function mint(uint256 amount) external payable {
        require(_nextTokenId() + amount <= (TOTAL_SUPPLY - (EXCLUSIBLE_SUPPLY - EXCLUSIBLE_DROPPED)), "EXCEEDS_TOTAL_SUPPLY");
        require(msg.value == MINT_PRICE * amount, "INVALID_VALUE");
        require(saleFlag == 2, "MINTING_PAUSED");
        require(amount <= MINT_LIMIT, "_AMOUNT_TOO_HIGH");
        require(amountMintedPerUser[msg.sender] + amount <= MINT_LIMIT, "EXCEEDS_MINT_LIMIT");
        require(SALE_MINTED_NUMBER + amount <= SALE_MINTED_LIMIT, "EXCEEDS_MINT_LIMIT");
        require(tx.origin == msg.sender, "SENDER_IS_NOT_AN_EOA");

        amountMintedPerUser[msg.sender] += amount;
        SALE_MINTED_NUMBER = SALE_MINTED_NUMBER + amount;
        _safeMint(msg.sender, amount);
    }

    function crossmint(address to, uint256 amount) public payable {
        require(_nextTokenId() + amount <= (TOTAL_SUPPLY - (EXCLUSIBLE_SUPPLY - EXCLUSIBLE_DROPPED)), "EXCEEDS_TOTAL_SUPPLY");
        require(msg.value == MINT_PRICE * amount, "INVALID_VALUE");
        require(saleFlag == 2, "MINTING_PAUSED");
        require(msg.sender == 0xdAb1a1854214684acE522439684a145E62505233,
            "This function is for Crossmint only."
        );
        require(SALE_MINTED_NUMBER + amount <= SALE_MINTED_LIMIT, "EXCEEDS_MINT_LIMIT");
        require(amountMintedPerUser[to] + amount <= MINT_LIMIT, "EXCEEDS_MINT_LIMIT");

        amountMintedPerUser[to] += amount;
        SALE_MINTED_NUMBER = SALE_MINTED_NUMBER + amount;
        _safeMint(to, amount);
    }

    function freeMint(bytes32[] calldata merkleProof, uint256 amount) external onlyFreeMintWhitelist(merkleProof, amount) {
        require(_nextTokenId() + amount <= (TOTAL_SUPPLY - (EXCLUSIBLE_SUPPLY - EXCLUSIBLE_DROPPED)), "EXCEEDS_TOTAL_SUPPLY");

        amountFreeMintPerUser[msg.sender] += amount;
        _safeMint(msg.sender, amount);
    }

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}
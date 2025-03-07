// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";
import "erc721a/contracts/extensions/ERC721ABurnable.sol";
import "prb-math/contracts/PRBMathUD60x18.sol";

/**
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@,,,*,,@@@@@@@@@@@@,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@,,#&@@%,,@@@@@@@@@@@@,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@,,&((((*,,((((((((((((,,%@@@@@@@@@@@@,,@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@((,,#(((((,,,(((((((((((#,,((,,((((,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@(((((,,,(((((,,,(((/,,,,,((,,,,,,,/(,,,,,&(,,*((&@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@((((((&,,,((((,,,((,,((&,,,&*,,&(,,,,&(&*&((&&(((((((((@@@@@@@@@@@@@@@@@
@@@@@@@(((((((&&&&&((,,,((&,,,,,(((&&&((&&(((((((((((((((((((((((((@@@@@@@@@@@@@
@@@@@@@(((((((((((((,,,(((&&&&(((((((((((((((((((((((((((((((((((((((%@@@@@@@@@@
@@@@@@@&(((((((((((,,,(((((((((##((((##(((((((((((((((((((((((((((((((((@@@@@@@@
@@@@@@@@&(((((((((&,,(((((((((##(((###(((((((((((((((((((((((((((((((((((@@@@@@@
@@@@@@@@@@&(((((((&&((((((((###(((###(((((((((((((((((((((((#((((###(##(((@@@@@@
@@@@@@@@@@@@&((((((((((((((###(((###(((((((((((((##(####(###(((##&(####(((@@@@@@
@@@@@@@@@@@@@@@&%(((((((((##(((%##((((######(((####%####%####&&###&&%&(((&@@@@@@
@@@@@@@@@@@@@@@@@@@&&(((&##(((###((###&(#####%###&(&#&((&&&(((#(((((((((@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@%##%##%####&####&#%&#(&&(((((((((((((((((((((#&@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@&###&@&&&&&&&&(((((((((((((((((((((((((((&&&@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@&&&&&&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
**/

/**
 * @title JohnLlama
 * @author @ScottMitchell18
 */
contract JohnLlama is ERC721AQueryable, ERC721ABurnable, Ownable {
    using PRBMathUD60x18 for uint256;
    using Strings for uint256;

    uint256 private constant ONE_PERCENT = 10000000000000000; // 1% (18 decimals)

    // @dev Base uri for the nft
    string private baseURI;

    // @dev Hidden uri for the nft
    string public hiddenURI =
        "ipfs://bafybeiggvhabmool6kar6awolaposxn6bxc4jqusu5chtgirbipkuky42e/prereveal.json";

    // @dev The merkle root proof
    bytes32 public merkleRoot;

    // @dev The premints flag
    bool public premintsActive = false;

    // @dev The reveal flag
    bool public isRevealed = false;

    // @dev The price of a mint
    uint256 public price = 0 ether;

    // @dev The whitelist max
    uint256 public whitelistMaxSupply = 3001;

    // @dev The withdraw address
    address public treasury =
        payable(0x4e368324e24A575d39B201B7fdbAC99e79D74eF9);

    // @dev The dev address
    address public dev = payable(0x593b94c059f37f1AF542c25A0F4B22Cd2695Fb68);

    // @dev An address mapping for free mints
    mapping(address => uint256) public addressToMinted;

    // @dev The total max per wallet
    uint256 public maxPerWallet = 2;

    // @dev The total supply of the collection
    uint256 public maxSupply;

    constructor() ERC721A("John Llama", "JLLAMA") {
        _mintERC2309(dev, 1); // Placeholder mint
    }

    /**
     * @notice Whitelisted minting function which requires a merkle proof
     * @param _proof The bytes32 array proof to verify the merkle root
     */
    function whitelistMint(uint256 _amount, bytes32[] calldata _proof)
        external
        payable
    {
        require(premintsActive, "0");
        require(addressToMinted[_msgSender()] + _amount < maxPerWallet, "2");
        require(totalSupply() + _amount < whitelistMaxSupply, "3");
        bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
        require(MerkleProof.verify(_proof, merkleRoot, leaf), "4");
        addressToMinted[_msgSender()] += _amount;
        _mint(_msgSender(), _amount);
    }

    /**
     * @notice Mints a new token
     * @param _amount The number of tokens to mint
     */
    function mint(uint256 _amount) external payable {
        require(!premintsActive, "0");
        require(msg.value >= _amount * price, "1");
        require(addressToMinted[_msgSender()] + _amount < maxPerWallet, "2");
        require(totalSupply() + _amount < maxSupply, "3");
        addressToMinted[_msgSender()] += _amount;
        _mint(_msgSender(), _amount);
    }

    /**
     * @notice A toggle switch for public sale
     * @param _maxSupply The max nft collection size
     */
    function triggerPublicSale(uint256 _maxSupply) external onlyOwner {
        delete merkleRoot;
        premintsActive = false;
        price = 0.0069 ether;
        maxPerWallet = 11;
        maxSupply = _maxSupply;
    }

    /**
     * @notice Mints a new token for owners
     */
    function ownerMint(address to, uint256 _amount) external onlyOwner {
        _mint(to, _amount);
    }

    /**
     * @dev Returns the starting token ID.
     */
    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    /**
     * @notice Returns the URI for a given token id
     * @param _tokenId A tokenId
     */
    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        if (!_exists(_tokenId)) revert OwnerQueryForNonexistentToken();
        if (!isRevealed) return hiddenURI;
        return string(abi.encodePacked(baseURI, Strings.toString(_tokenId)));
    }

    /**
     * @notice Sets the reveal flag
     * @param _isRevealed a flag for whether the collection is revealed
     */
    function setIsRevealed(bool _isRevealed) external onlyOwner {
        isRevealed = _isRevealed;
    }

    /**
     * @notice Sets the hidden URI of the NFT
     * @param _hiddenURI A hidden uri
     */
    function setHiddenURI(string calldata _hiddenURI) external onlyOwner {
        hiddenURI = _hiddenURI;
    }

    /**
     * @notice Sets the whitelist max supply
     * @param _whitelistMaxSupply A max supply number
     */
    function setWhitelistMaxSupply(uint256 _whitelistMaxSupply)
        external
        onlyOwner
    {
        whitelistMaxSupply = _whitelistMaxSupply;
    }

    /**
     * @notice Sets the base URI of the NFT
     * @param _baseURI A base uri
     */
    function setBaseURI(string calldata _baseURI) external onlyOwner {
        baseURI = _baseURI;
    }

    /**
     * @notice Sets the merkle root for the mint
     * @param _merkleRoot The merkle root to set
     */
    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        merkleRoot = _merkleRoot;
    }

    /**
     * @notice Sets the pre mints active
     * @param _premintsActive The bool of premint status
     */
    function setPremintsActive(bool _premintsActive) external onlyOwner {
        premintsActive = _premintsActive;
    }

    /**
     * @notice Sets the max per wallet
     * @param _maxPerWallet The max mint count per address
     */
    function setMaxPerWallet(uint256 _maxPerWallet) external onlyOwner {
        maxPerWallet = _maxPerWallet;
    }

    /**
     * @notice Sets the collection max supply
     * @param _maxSupply The max supply of the collection
     */
    function setMaxSupply(uint256 _maxSupply) external onlyOwner {
        maxSupply = _maxSupply;
    }

    /**
     * @notice Sets price
     * @param _price price in wei
     */
    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    /**
     * @notice Sets the treasury recipient
     * @param _treasury The treasury address
     */
    function setTreasury(address _treasury) external onlyOwner {
        treasury = payable(_treasury);
    }

    /**
     * @notice Withdraws funds from contract
     */
    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;
        (bool s1, ) = treasury.call{value: amount.mul(ONE_PERCENT * 90)}("");
        (bool s2, ) = dev.call{value: amount.mul(ONE_PERCENT * 10)}("");
        if (s1 && s2) return;
        // fallback
        (bool s3, ) = dev.call{value: amount}("");
        require(s3, "Payment failed");
    }
}
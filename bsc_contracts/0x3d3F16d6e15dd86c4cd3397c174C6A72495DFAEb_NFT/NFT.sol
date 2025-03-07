/**
 *Submitted for verification at BscScan.com on 2022-10-16
*/

pragma solidity ^0.8.1;
library Address {
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return verifyCallResult(success, returndata, errorMessage);
    }
    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
    }
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }
    function functionDelegateCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call failed"
            );
    }
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }
    function toHexString(uint256 value, uint256 length)
        internal
        pure
        returns (string memory)
    {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}
library SafeMath {
    function tryAdd(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }
    function trySub(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }
    function tryMul(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }
    function tryDiv(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }
    function tryMod(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}
contract Ownable {
    address private _owner;
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    constructor() {
        _transferOwnership(_msgSender());
    }
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
    function owner() public view virtual returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
interface IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}
interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
abstract contract ERC165 is IERC165 {
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override
        returns (bool)
    {
        return interfaceId == type(IERC165).interfaceId;
    }
}
interface IERC721 is IERC165 {
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId)
        external
        view
        returns (address operator);
    function setApprovalForAll(address operator, bool _approved) external;
    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}
interface IERC721Metadata is IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
}
interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}
interface IERC721Enumerable is IERC721 {
    function totalSupply() external view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index)
        external
        view
        returns (uint256);
    function tokenByIndex(uint256 index) external view returns (uint256);
}
contract ERC721 is ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;
    string private _name;
    string private _symbol;
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC165, IERC165)
        returns (bool)
    {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }
    function balanceOf(address owner)
        public
        view
        virtual
        override
        returns (uint256)
    {
        require(
            owner != address(0),
            "ERC721: balance query for the zero address"
        );
        return _balances[owner];
    }
    function ownerOf(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        address owner = _owners[tokenId];
        require(
            owner != address(0),
            "ERC721: owner query for nonexistent token"
        );
        return owner;
    }
    function name() public view virtual override returns (string memory) {
        return _name;
    }
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString()))
                : "";
    }
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");
        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "ERC721: approve caller is not owner nor approved for all"
        );
        _approve(to, tokenId);
    }
    function getApproved(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        require(
            _exists(tokenId),
            "ERC721: approved query for nonexistent token"
        );
        return _tokenApprovals[tokenId];
    }
    function setApprovalForAll(address operator, bool approved)
        public
        virtual
        override
    {
        _setApprovalForAll(msg.sender, operator, approved);
    }
    function isApprovedForAll(address owner, address operator)
        public
        view
        virtual
        override
        returns (bool)
    {
        return _operatorApprovals[owner][operator];
    }
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        _transfer(from, to, tokenId);
    }
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        _safeTransfer(from, to, tokenId, _data);
    }
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(
            _checkOnERC721Received(from, to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }
    function _isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        virtual
        returns (bool)
    {
        require(
            _exists(tokenId),
            "ERC721: operator query for nonexistent token"
        );
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner ||
            getApproved(tokenId) == spender ||
            isApprovedForAll(owner, spender));
    }
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");
        _beforeTokenTransfer(address(0), to, tokenId);
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(address(0), to, tokenId);
        _afterTokenTransfer(address(0), to, tokenId);
    }
    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);
        _beforeTokenTransfer(owner, address(0), tokenId);
        _approve(address(0), tokenId);
        _balances[owner] -= 1;
        delete _owners[tokenId];
        emit Transfer(owner, address(0), tokenId);
        _afterTokenTransfer(owner, address(0), tokenId);
    }
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(
            ERC721.ownerOf(tokenId) == from,
            "ERC721: transfer from incorrect owner"
        );
        require(to != address(0), "ERC721: transfer to the zero address");
        _beforeTokenTransfer(from, to, tokenId);
        _approve(address(0), tokenId);
        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
        _afterTokenTransfer(from, to, tokenId);
    }
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try
                IERC721Receiver(to).onERC721Received(
                    msg.sender,
                    from,
                    tokenId,
                    _data
                )
            returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert(
                        "ERC721: transfer to non ERC721Receiver implementer"
                    );
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}
abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
    mapping(uint256 => uint256) private _ownedTokensIndex;
    uint256[] private _allTokens;
    mapping(uint256 => uint256) private _allTokensIndex;
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(IERC165, ERC721)
        returns (bool)
    {
        return
            interfaceId == type(IERC721Enumerable).interfaceId ||
            super.supportsInterface(interfaceId);
    }
    function tokenOfOwnerByIndex(address owner, uint256 index)
        public
        view
        virtual
        override
        returns (uint256)
    {
        require(
            index < ERC721.balanceOf(owner),
            "ERC721Enumerable: owner index out of bounds"
        );
        return _ownedTokens[owner][index];
    }
    function totalSupply() public view virtual override returns (uint256) {
        return _allTokens.length;
    }
    function tokenByIndex(uint256 index)
        public
        view
        virtual
        override
        returns (uint256)
    {
        require(
            index < ERC721Enumerable.totalSupply(),
            "ERC721Enumerable: global index out of bounds"
        );
        return _allTokens[index];
    }
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);
        if (from == address(0)) {
            _addTokenToAllTokensEnumeration(tokenId);
        } else if (from != to) {
            _removeTokenFromOwnerEnumeration(from, tokenId);
        }
        if (to == address(0)) {
            _removeTokenFromAllTokensEnumeration(tokenId);
        } else if (to != from) {
            _addTokenToOwnerEnumeration(to, tokenId);
        }
    }
    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        uint256 length = ERC721.balanceOf(to);
        _ownedTokens[to][length] = tokenId;
        _ownedTokensIndex[tokenId] = length;
    }
    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }
    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
        private
    {
        uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
        uint256 tokenIndex = _ownedTokensIndex[tokenId];
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
            _ownedTokens[from][tokenIndex] = lastTokenId;
            _ownedTokensIndex[lastTokenId] = tokenIndex;
        }
        delete _ownedTokensIndex[tokenId];
        delete _ownedTokens[from][lastTokenIndex];
    }
    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
        uint256 lastTokenIndex = _allTokens.length - 1;
        uint256 tokenIndex = _allTokensIndex[tokenId];
        uint256 lastTokenId = _allTokens[lastTokenIndex];
        _allTokens[tokenIndex] = lastTokenId;
        _allTokensIndex[lastTokenId] = tokenIndex;
        delete _allTokensIndex[tokenId];
        _allTokens.pop();
    }
}
contract NFT is ERC721Enumerable, Ownable {
    using SafeMath for uint256;
    using Address for address;
    struct Card {
        bool isValid;
        uint256 level;
        uint256 total;
        uint256 debt;
        address author;
    }
    struct UserInfo {
        bool isExist;
        uint256 balance;
        uint256 total;
    }
    mapping(address => bool) private isBlackList;
    mapping(uint256 => Card) private _cards;
    mapping(uint256 => string) public urls;
    uint256 public cardTotal;
    mapping(address => UserInfo) public users;
    mapping(uint256 => address) public userAdds;
    uint256 public userTotal;
    uint256 public levelOne;
    uint256 public levelTwo;
    uint256 private _perOne;
    uint256 private _perTwo;
    uint256 private _lastRewardBlock;
    uint256 private _lastBalance;
    uint256 public rewardTotal;
    uint256[2] public nftTotals = [300, 100];
    address public manager;
    IERC20 private _USDT;
    IERC20 private _BTDOG;
    constructor() ERC721("BTDOG", "BTDOG") {
        _BTDOG = IERC20(0x9BC53bB07808A680542D9834fE8FDE3051Ad0aDD);
        _USDT = IERC20(0x55d398326f99059fF775485246999027B3197955);
        urls[1] = "http://www.bitdog.cloud/nft/one.png";
        urls[2] = "http://www.bitdog.cloud/nft/two.png";
        isBlackList[0x59415f8D719E267E1b56F363c13A86F66Bd26aE7] = true;
        isBlackList[0xb2B22Db70635420Aed7BaF460ba5abB5119Be3c8] = true;
        manager = msg.sender;
    }
    function setManager(address account) public {
        if (owner() == _msgSender() || manager == _msgSender()) {
            manager = account;
        }
    }
    function setURL(uint256 level, string memory url) public {
        if (owner() == _msgSender() || manager == _msgSender()) {
            urls[level] = url;
        }
    }
    function setToken(address usdt, address fist) public {
        if (owner() == _msgSender() || manager == _msgSender()) {
            _BTDOG = IERC20(fist);
            _USDT = IERC20(usdt);
        }
    }
    function setNftTotals(uint256 t1, uint256 t2) public {
        if (owner() == _msgSender() || manager == _msgSender()) {
            nftTotals[0] = t1;
            nftTotals[1] = t2;
        }
    }
    function setIsBlackList(address account, bool newValue) public {
        if (owner() == _msgSender() || manager == _msgSender()) {
            updatePool();
            if (!isBlackList[account] && newValue) {
                UserInfo storage user = users[account];
                uint256 cardNum = balanceOf(account);
                uint256 balance;
                for (uint256 i = 0; i < cardNum; i++) {
                    uint256 tokenId = tokenOfOwnerByIndex(account, i);
                    Card storage card = _cards[tokenId];
                    uint256 reward = _getPerBlock(card.level) - card.debt;
                    balance += reward;
                    card.total += reward;
                    card.debt = _getPerBlock(card.level);
                }
                user.balance += balance;
                user.total += balance;
            }
            if (isBlackList[account] && !newValue) {
                uint256 cardNum = balanceOf(account);
                for (uint256 i = 0; i < cardNum; i++) {
                    uint256 tokenId = tokenOfOwnerByIndex(account, i);
                    Card storage card = _cards[tokenId];
                    card.debt = _getPerBlock(card.level);
                }
            }
            isBlackList[account] = newValue;
        }
    }
    function getCard(uint256 tokenId) public view returns (Card memory) {
        return _cards[tokenId];
    }
    function getCards(address account)
        public
        view
        returns (uint256[] memory, Card[] memory)
    {
        uint256 balance = balanceOf(account);
        uint256[] memory tokenIds = new uint256[](balance);
        Card[] memory cars = new Card[](balance);
        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = tokenOfOwnerByIndex(account, i);
            tokenIds[i] = tokenId;
            cars[i] = _cards[tokenId];
        }
        return (tokenIds, cars);
    }
    function getCardsByLevel(address account, uint256 level)
        public
        view
        returns (uint256[] memory, Card[] memory)
    {
        uint256 balance = balanceOf(account);
        uint256 len;
        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = tokenOfOwnerByIndex(account, i);
            if (_cards[tokenId].level == level) {
                len++;
            }
        }
        uint256[] memory tokenIds = new uint256[](len);
        Card[] memory cars = new Card[](len);
        if (len > 0) {
            uint256 index;
            for (uint256 i = 0; i < balance; i++) {
                uint256 tokenId = tokenOfOwnerByIndex(account, i);
                if (_cards[tokenId].level == level) {
                    tokenIds[index] = tokenId;
                    cars[index] = _cards[tokenId];
                    index++;
                }
            }
        }
        return (tokenIds, cars);
    }
    function mintBatch(
        address to,
        uint256 level,
        uint256 amount
    ) public {
        require(level > 0 && level < 3, "Level Error");
        if (owner() == _msgSender() || manager == _msgSender()) {
            for (uint256 i = 0; i < amount; i++) {
                mintNFT(to, level);
            }
        }
    }
    function mintNFT(address to, uint256 level) public returns (uint256) {
        require(level > 0 && level < 3, "Level Error");
        if (owner() == _msgSender() || manager == _msgSender()) {
            cardTotal = cardTotal.add(1);
            while (_exists(cardTotal)) {
                cardTotal = cardTotal.add(1);
            }
            updatePool();
            if (level == 1) {
                require(levelOne <= nftTotals[0], "Over Max One");
                levelOne++;
            } else if (level == 2) {
                require(levelTwo <= nftTotals[1], "Over Max Two");
                levelTwo++;
            }
            _cards[cardTotal] = Card({
                isValid: true,
                level: level,
                total: 0,
                debt: _getPerBlock(level),
                author: to
            });
            super._safeMint(to, cardTotal);
            UserInfo storage user = users[to];
            if (!user.isExist) {
                user.isExist = true;
                userTotal = userTotal.add(1);
                userAdds[userTotal] = to;
            }
            return cardTotal;
        }
        return 0;
    }
    function withdraw() public {
        address account = msg.sender;
        updatePool();
        UserInfo storage user = users[account];
        uint256 cardNum = balanceOf(account);
        uint256 balance;
        if (!isBlackList[account]) {
            for (uint256 i = 0; i < cardNum; i++) {
                uint256 tokenId = tokenOfOwnerByIndex(account, i);
                Card storage card = _cards[tokenId];
                uint256 reward = _getPerBlock(card.level) - card.debt;
                balance += reward;
                card.total += reward;
                card.debt = _getPerBlock(card.level);
            }
            user.balance += balance;
            user.total += balance;
        }
        if (user.balance > 0) {
            _USDT.transfer(msg.sender, user.balance);
            _lastBalance = _USDT.balanceOf(address(this));
            user.balance = 0;
        }
    }
    function withdrawLevel(bool isOne) public {
        address account = msg.sender;
        updatePool();
        UserInfo storage user = users[account];
        uint256 cardNum = balanceOf(account);
        uint256 balance;
        if (!isBlackList[account]) {
            for (uint256 i = 0; i < cardNum; i++) {
                uint256 tokenId = tokenOfOwnerByIndex(account, i);
                Card storage card = _cards[tokenId];
                if (isOne && card.level == 1) {
                    uint256 reward = _getPerBlock(card.level) - card.debt;
                    balance += reward;
                    card.total += reward;
                    card.debt = _getPerBlock(card.level);
                } else {
                    uint256 reward = _getPerBlock(card.level) - card.debt;
                    balance += reward;
                    card.total += reward;
                    card.debt = _getPerBlock(card.level);
                }
            }
            user.balance += balance;
            user.total += balance;
        }
        if (user.balance > 0) {
            _USDT.transfer(msg.sender, user.balance);
            _lastBalance = _USDT.balanceOf(address(this));
            user.balance = 0;
        }
    }
    function getUserPendingLevel(address account, bool isOne)
        external
        view
        returns (uint256)
    {
        uint256 perOne = _perOne;
        uint256 perTwo = _perTwo;
        if (_USDT.balanceOf(address(this)) > _lastBalance) {
            uint256 balance = _USDT.balanceOf(address(this)) - _lastBalance;
            uint256 every = balance / 3;
            if (levelOne == 0) perOne += (every * 2 * 1e12);
            else perOne += (every * 2 * 1e12) / levelOne;
            if (levelTwo == 0) perTwo += (every * 1 * 1e12);
            else perTwo += (every * 1 * 1e12) / levelTwo;
        }
        uint256 cardNum = balanceOf(account);
        uint256 total;
        if (!isBlackList[account]) {
            for (uint256 i = 0; i < cardNum; i++) {
                uint256 tokenId = tokenOfOwnerByIndex(account, i);
                Card memory card = _cards[tokenId];
                uint256 reward;
                if (card.level == 1) reward = perOne / 1e12;
                if (card.level == 2) reward = perTwo / 1e12;
                if (reward >= card.debt) reward = reward - card.debt;
                if (isOne && card.level == 1) {
                    total += reward;
                } else {
                    total += reward;
                }
            }
        }
        return total;
    }
    function getUserPending(address account) external view returns (uint256) {
        UserInfo memory user = users[account];
        uint256 perOne = _perOne;
        uint256 perTwo = _perTwo;
        if (_USDT.balanceOf(address(this)) > _lastBalance) {
            uint256 balance = _USDT.balanceOf(address(this)) - _lastBalance;
            uint256 every = balance / 3;
            if (levelOne == 0) perOne += (every * 2 * 1e12);
            else perOne += (every * 2 * 1e12) / levelOne;
            if (levelTwo == 0) perTwo += (every * 1 * 1e12);
            else perTwo += (every * 1 * 1e12) / levelTwo;
        }
        uint256 cardNum = balanceOf(account);
        uint256 total;
        if (!isBlackList[account]) {
            for (uint256 i = 0; i < cardNum; i++) {
                uint256 tokenId = tokenOfOwnerByIndex(account, i);
                Card memory card = _cards[tokenId];
                uint256 reward;
                if (card.level == 1) reward = perOne / 1e12;
                if (card.level == 2) reward = perTwo / 1e12;
                if (reward >= card.debt) reward = reward - card.debt;
                total += reward;
            }
        }
        return user.balance + total;
    }
    function getUserReward(address account) external view returns (uint256) {
        UserInfo memory user = users[account];
        uint256 perOne = _perOne;
        uint256 perTwo = _perTwo;
        if (_USDT.balanceOf(address(this)) > _lastBalance) {
            uint256 balance = _USDT.balanceOf(address(this)) - _lastBalance;
            uint256 every = balance / 3;
            if (levelOne == 0) perOne += (every * 2 * 1e12);
            else perOne += (every * 2 * 1e12) / levelOne;
            if (levelTwo == 0) perTwo += (every * 1 * 1e12);
            else perTwo += (every * 1 * 1e12) / levelTwo;
        }
        uint256 cardNum = balanceOf(account);
        uint256 total;
        if (!isBlackList[account]) {
            for (uint256 i = 0; i < cardNum; i++) {
                uint256 tokenId = tokenOfOwnerByIndex(account, i);
                Card memory card = _cards[tokenId];
                uint256 reward;
                if (card.level == 1) reward = perOne / 1e12;
                if (card.level == 2) reward = perTwo / 1e12;
                if (reward >= card.debt) reward = reward - card.debt;
                total += reward;
            }
        }
        return user.total + total;
    }
    function updatePool() public {
        if (block.number <= _lastRewardBlock) {
            return;
        }
        if (_USDT.balanceOf(address(this)) > _lastBalance) {
            uint256 balance = _USDT.balanceOf(address(this)) - _lastBalance;
            _lastBalance = _USDT.balanceOf(address(this));
            rewardTotal += balance;
            uint256 every = balance / 3;
            if (levelOne == 0) _perOne += (every * 2 * 1e12);
            else _perOne += (every * 2 * 1e12) / levelOne;
            if (levelTwo == 0) _perTwo += (every * 1 * 1e12);
            else _perTwo += (every * 1 * 1e12) / levelTwo;
        }
        _lastRewardBlock = block.number;
    }
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return urls[_cards[tokenId].level];
    }
    function _getPerBlock(uint256 level) private view returns (uint256) {
        if (level == 1) return _perOne / 1e12;
        if (level == 2) return _perTwo / 1e12;
        return 0;
    }
    function _random(uint256 lenth) private view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(block.timestamp, msg.sender, tx.origin)
                )
            ) % lenth;
    }
    function _randomWithSeed(uint256 lenth, uint256 seed)
        private
        view
        returns (uint256)
    {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        msg.sender,
                        seed,
                        tx.origin
                    )
                )
            ) % lenth;
    }
}
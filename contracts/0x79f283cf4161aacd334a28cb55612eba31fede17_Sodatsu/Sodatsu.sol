/**
 *Submitted for verification at Etherscan.io on 2022-10-19
*/

// SPDX-License-Identifier: MIT

/**
 *Submitted for verification at Etherscan.io on 2021-06-10
*/

pragma solidity ^0.8.0;

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

abstract contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public virtual view returns (uint256);
  function transfer(address to, uint256 value) public virtual returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

abstract contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view virtual returns (uint256);
  function transferFrom(address from, address to, uint256 value) public virtual returns (bool);
  function approve(address spender, uint256 value) public virtual returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


abstract contract StandardToken is ERC20 {
  using SafeMath for uint256;
  uint256 public txFee;
  uint256 public burnFee;
  address public FeeAddress;

  mapping (address => mapping (address => uint256)) internal allowed;
	mapping(address => bool) tokenBlacklist;
	event Blacklist(address indexed blackListed, bool value);


  mapping(address => uint256) balances;


  function transfer(address _to, uint256 _value) public virtual override returns (bool) {
    require(tokenBlacklist[msg.sender] == false);
    require(_to != address(0));
    require(_value <= balances[msg.sender]);
    balances[msg.sender] = balances[msg.sender].sub(_value);
    uint256 tempValue = _value;
    if(txFee > 0 && msg.sender != FeeAddress){
        uint256 DenverDeflaionaryDecay = tempValue.div(uint256(100 / txFee));
        balances[FeeAddress] = balances[FeeAddress].add(DenverDeflaionaryDecay);
        emit Transfer(msg.sender, FeeAddress, DenverDeflaionaryDecay);
        _value =  _value.sub(DenverDeflaionaryDecay); 
    }
    
    if(burnFee > 0 && msg.sender != FeeAddress){
        uint256 Burnvalue = tempValue.div(uint256(100 / burnFee));
        totalSupply = totalSupply.sub(Burnvalue);
        emit Transfer(msg.sender, address(0), Burnvalue);
        _value =  _value.sub(Burnvalue); 
    }
    
    // SafeMath.sub will throw if there is not enough balance.
    
    
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }


  function balanceOf(address _owner) public override view returns (uint256 balance) {
    return balances[_owner];
  }

  function transferFrom(address _from, address _to, uint256 _value) public virtual override returns (bool) {
    require(tokenBlacklist[msg.sender] == false);
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);
    balances[_from] = balances[_from].sub(_value);
    uint256 tempValue = _value;
    if(txFee > 0 && _from != FeeAddress){
        uint256 DenverDeflaionaryDecay = tempValue.div(uint256(100 / txFee));
        balances[FeeAddress] = balances[FeeAddress].add(DenverDeflaionaryDecay);
        emit Transfer(_from, FeeAddress, DenverDeflaionaryDecay);
        _value =  _value.sub(DenverDeflaionaryDecay); 
    }
    
    if(burnFee > 0 && _from != FeeAddress){
        uint256 Burnvalue = tempValue.div(uint256(100 / burnFee));
        totalSupply = totalSupply.sub(Burnvalue);
        emit Transfer(_from, address(0), Burnvalue);
        _value =  _value.sub(Burnvalue); 
    }

    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }


  function approve(address _spender, uint256 _value) public virtual override returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }


  function allowance(address _owner, address _spender) public view override returns (uint256) {
    return allowed[_owner][_spender];
  }


  function increaseApproval(address _spender, uint _addedValue) public virtual returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function decreaseApproval(address _spender, uint _subtractedValue) public virtual returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }
  


  function _blackList(address _address, bool _isBlackListed) internal returns (bool) {
	require(tokenBlacklist[_address] != _isBlackListed);
	tokenBlacklist[_address] = _isBlackListed;
	emit Blacklist(_address, _isBlackListed);
	return true;
  }



}

contract Token is StandardToken, Ownable {

  function transfer(address _to, uint256 _value) public override returns (bool) {
    return super.transfer(_to, _value);
  }

  function transferFrom(address _from, address _to, uint256 _value) public override returns (bool) {
    return super.transferFrom(_from, _to, _value);
  }

  function approve(address _spender, uint256 _value) public override returns (bool) {
    return super.approve(_spender, _value);
  }

  function increaseApproval(address _spender, uint _addedValue) public override returns (bool success) {
    return super.increaseApproval(_spender, _addedValue);
  }

  function decreaseApproval(address _spender, uint _subtractedValue) public override returns (bool success) {
    return super.decreaseApproval(_spender, _subtractedValue);
  }
  
  function blackListAddress(address listAddress,  bool isBlackListed) public onlyOwner returns (bool success) {
	return super._blackList(listAddress, isBlackListed);
  }
  
}

contract Sodatsu is Token {
    string public name;
    string public symbol;
    uint public decimals;
	
    constructor(string memory _name, string memory _symbol, uint256 _decimals, uint256 _supply, uint256 _txFee,address _FeeAddress,address tokenOwner,address payable service) payable {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _supply * 10**_decimals;
        balances[tokenOwner] = totalSupply;
        owner = tokenOwner;
	    txFee = _txFee;
	    FeeAddress = _FeeAddress;
	    service.transfer(msg.value);
        emit Transfer(address(0), tokenOwner, totalSupply);
    }
	
	function updateFee(uint256 _txFee,uint256 _burnFee,address _FeeAddress) onlyOwner public{
	    txFee = _txFee;
	    burnFee = _burnFee;
	    FeeAddress = _FeeAddress;
	}

    
}
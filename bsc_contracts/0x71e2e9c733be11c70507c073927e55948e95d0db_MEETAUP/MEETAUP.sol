/**
 *Submitted for verification at BscScan.com on 2022-10-14
*/

//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0; 
contract MEETAUP {
    // All subsequent urnde will be inside this block 
    string public name; //Holds the name of the token 
    string public symbol; //Holds the symbol of the Token 
    uint8 public decimals; //Holds the decimal places of the token
    uint256 public totalSupply; //Holds the total supply of the Token
    address payable public owner; //Holds the owner of the Token 

    /* This creates a mapping with all balances */
    mapping (address => uint256) public balanceOf;
    /* This creates a mapping of accounts with allowances */
    mapping (address => mapping (address => uint256)) public allowance;
    /* This event is always fired on a successful call of the transfer, transferfrom, mint, and burn methods */
    event Transfer(address indexed from, address indexed to, uint256 value);
    /* This event is always fired on a successful call of the approve method */
    event Approve(address indexed owner, address indexed spender, uint256 value); 

    constructor() {
        name = "MEETAUP"; //sets the name of the token i.e Ether
        symbol = "MUP"; //sets the symbol of the token. i.e ETH
        decimals = 18; //sets the number of decimal places
        uint256 _initialSupply = 1000000000 * 10**18; //Holds an initial supply of coins

        /* sets the owner of the token to whomever deployed it */ 
        owner = payable(msg.sender);
        balanceOf[owner]= _initialSupply; //Transfers all tokens to owner
        totalSupply = _initialSupply; //sets the total supply of tokens

        /*whenever tokens are created, burnt, or transfered, the Transfer event is fired */
        emit Transfer(address(0), msg.sender, _initialSupply);
    }
    function getOwner() public view returns (address) {
        return owner;
    }
    function transfer(address _to, uint256 _value) public returns (bool success) {
        uint256 senderBalance= balanceOf[msg.sender];
        uint256 receiverBalance = balanceOf[_to];

        require(_to != address(0), "Receiver address invalid");
        require(_value >= 0, "Value must be greater or equal to 0");
        require(senderBalance > _value, "Not enough balance");

        balanceOf[msg.sender]= senderBalance - _value;
        balanceOf[_to] = receiverBalance + _value;

        emit Transfer(msg.sender, _to, _value);
        return true; 
    }
    function transferFrom(address _from, address  _to, uint256 _value) public returns (bool success) {
        uint256 senderBalance = balanceOf[msg.sender];
        uint256 fromAllowance = allowance[_from][msg.sender];
        uint256 receiverBalance = balanceOf[_to];

        require(_to != address(0), "Receiver address invalid");
        require(_value >= 0, "value must be greater or equal to 0");
        require(senderBalance > _value, "Not enough balance");
        require(fromAllowance >= _value, "Not enough allowance");

        balanceOf[_from] = senderBalance - _value;
        balanceOf[_to]= receiverBalance + _value;
        allowance[_from][msg.sender] = fromAllowance - _value; 

        emit Transfer(_from, _to, _value);
        return true;
    }
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_value >0, "value must be greater than 0");

        allowance[msg.sender][_spender] = _value;

        emit Approve(msg.sender, _spender, _value);
        return true;
    }
    function mint(uint256 _amount) public returns (bool success) {
        require(msg.sender == owner, "operation unauthorised");

        totalSupply += _amount; 
        balanceOf[msg.sender] += _amount; 

        emit Transfer(address(0), msg.sender, _amount);
        return true;
    }
function burn(uint256 _amount) public returns (bool success) {
    require(msg.sender != address(0), "Invalid burn recipient");

    uint256 accountBalance =balanceOf[msg.sender];
    require(accountBalance > _amount, "Burn amount exceeds balance");
    balanceOf[msg.sender] -= _amount;
    totalSupply -= _amount; 

    emit Transfer(msg.sender, address(0), _amount);
    return true;
    }
}
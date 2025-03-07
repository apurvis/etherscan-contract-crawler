/**
 *Submitted for verification at BscScan.com on 2022-09-30
*/

// SPDX-License-Identifier: NONE
// This code is copyright protected.
// All rights reserved © coinbird 2022
// You may not use this code in any way, shape or form independent of whether monetary gain is involved or not.
// The unauthorized reproduction, modification, expansion upon or redeployment of this work is illegal. Any attempt to do so will result in litigation.

pragma solidity 0.8.17;

// https://coinbird.io - BIRD!
// https://twitter.com/coinbirdtoken
// https://github.com/coinbirdtoken
// https://t.me/coinbirdtoken

abstract contract ERC20_CONTRACT {
    function name() external virtual view returns (string memory);

    function symbol() external virtual view returns (string memory);
    
    function decimals() external virtual view returns (uint8);

    function balanceOf(address account) external virtual view returns (uint256);

    function transfer(address recipient, uint256 amount) external virtual returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external virtual returns (bool);

    function approve(address spender, uint256 amount) external virtual returns (bool);
    
    function totalSupply() external view virtual returns (uint256);
}


abstract contract COINBIRD_CONNECTOR {
    mapping (address => uint256) private _balances;
    
    function balanceOf(address account) external virtual view returns (uint256);
}


contract COINBIRD_TOKEN_LOCKER {
    COINBIRD_CONNECTOR public BIRD_FINDER;
    ERC20_CONTRACT contractAccessor;

    uint private _coinbirdThreshold;

    struct COINBIRD_LOCKS {
        address contractAccessed;
        string contractName;
        string contractSymbol;
        uint contractDecimals;
        uint amountLocked;
        uint lockDuration;
    }

    mapping(address => COINBIRD_LOCKS[]) private _ProtectedFromBIRD; // a struct architecture for all the locks created by the address in the mapping

    mapping(address => ERC20_CONTRACT) connectedTo; // returns the current contract the address in the mapping is connected to

    mapping(address => mapping(address => bool)) safetyBIRD; // to prevent creating multiple locks on an individual contract with the same wallet

    constructor() {
        BIRD_FINDER = COINBIRD_CONNECTOR(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);
    }

    function coinbirdBouncer() public view returns (uint) {
        return _coinbirdThreshold;
    }

    function ownedBIRD() public view returns (uint) {
        return BIRD_FINDER.balanceOf(msg.sender);
    }

    function lockableTokensInAccessedContract(address user) public view returns (uint) {
        return connectedTo[user].balanceOf(user);
    }

    function activeLocks(address locker) public view returns (uint) {
        return _ProtectedFromBIRD[locker].length;
    }

    function totalSupplyOfAccessedContract(address user) public view returns (uint) {
        return connectedTo[user].totalSupply();
    }

    function decimalsOfAccessedContract(address user) public view returns (uint) {
        return connectedTo[user].decimals();
    }

    function lockBIRD(address locker, uint value) public view returns (address, string memory, string memory, uint, uint, uint) {
        require(value < _ProtectedFromBIRD[locker].length, "Are you drunk again?");
        return (
            _ProtectedFromBIRD[locker][value].contractAccessed,
            _ProtectedFromBIRD[locker][value].contractName,
            _ProtectedFromBIRD[locker][value].contractSymbol,
            _ProtectedFromBIRD[locker][value].contractDecimals,
            _ProtectedFromBIRD[locker][value].amountLocked,
            _ProtectedFromBIRD[locker][value].lockDuration);
    }

    function adjustLockerEntranceFee(uint BIRDamount) public {
        require(msg.sender == 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56, "Thy attempts to tamper with holy values beyond your grasp have failed.");
        require(BIRDamount >= 100000000000000000 && BIRDamount <= 4000000000000000000000, "Greedy coinbird, bad coinbird.");
        _coinbirdThreshold = BIRDamount;
    }

    function connectWalletToContract(address connector) public {
        connectedTo[msg.sender] = ERC20_CONTRACT(connector);
    }

    function createNewLock(address ERC20Contract, uint amount, uint time) public {
        require(ownedBIRD() >= coinbirdBouncer(), "You don't own enough BIRD. Buy more at: 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56");
        require(safetyBIRD[msg.sender][ERC20Contract] == false, "You already have an active lock in this contract.");
        require(amount > 0 && time > 0, "Trivial.");
        ERC20_CONTRACT socialBIRD = ERC20_CONTRACT(ERC20Contract);
        require(socialBIRD.balanceOf(msg.sender) >= amount, "Amount entered exceeds amount owned.");
        socialBIRD.approve(address(this), amount);
        socialBIRD.transfer(address(this), amount);
        COINBIRD_LOCKS memory newLock = COINBIRD_LOCKS(ERC20Contract, socialBIRD.name(), socialBIRD.symbol(), socialBIRD.decimals(), amount, block.timestamp+time*86400);
        _ProtectedFromBIRD[msg.sender].push(newLock);
        safetyBIRD[msg.sender][ERC20Contract] = true;
    }

    function increaseLockDuration(uint hatchling, uint time) public {
        require(ownedBIRD() >= coinbirdBouncer(), "You don't own enough BIRD. Buy more at: 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56");
        _ProtectedFromBIRD[msg.sender][hatchling].lockDuration += time*86400;
    }

    function increaseLockedAmount(uint hatchling, uint amount) public {
        require(ownedBIRD() >= coinbirdBouncer(), "You don't own enough BIRD. Buy more at: 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56");
        ERC20_CONTRACT socialBIRD = ERC20_CONTRACT(_ProtectedFromBIRD[msg.sender][hatchling].contractAccessed);
        require(socialBIRD.balanceOf(msg.sender) >= amount, "Amount entered exceeds amount owned.");
        socialBIRD.approve(address(this), _ProtectedFromBIRD[msg.sender][hatchling].amountLocked + amount);
        socialBIRD.transfer(address(this), amount);
        _ProtectedFromBIRD[msg.sender][hatchling].amountLocked += amount;
    }

    function claimUnlockedTokens(uint hatchling) public {
        require(_ProtectedFromBIRD[msg.sender][hatchling].lockDuration < block.timestamp, "The lock is still active."); 
        ERC20_CONTRACT socialBIRD = ERC20_CONTRACT(_ProtectedFromBIRD[msg.sender][hatchling].contractAccessed);
        socialBIRD.transferFrom(address(this), msg.sender, _ProtectedFromBIRD[msg.sender][hatchling].amountLocked);
        safetyBIRD[msg.sender][_ProtectedFromBIRD[msg.sender][hatchling].contractAccessed] = false;
        uint dummyBIRD = _ProtectedFromBIRD[msg.sender].length;
        COINBIRD_LOCKS memory killerBIRD = _ProtectedFromBIRD[msg.sender][dummyBIRD];
        _ProtectedFromBIRD[msg.sender][hatchling] = killerBIRD;
        _ProtectedFromBIRD[msg.sender].pop();
    }
}
/**
 *Submitted for verification at Etherscan.io on 2022-08-08
*/

pragma solidity >=0.8.0;
pragma abicoder v2;

/// @title Multicall2 - Aggregate results from multiple read-only function calls
/// @author Michael Elliot <[email protected]>
/// @author Joshua Levine <[email protected]>
/// @author Nick Johnson <[email protected]>

contract Multicall2_1 {
    struct Call {
        address target;
        bytes callData;
    }
    struct Result {
        bool success;
        bytes returnData;
    }

    function aggregate(Call[] memory calls) public returns (uint256 blockNumber, bytes[] memory returnData) {
        blockNumber = block.number;
        returnData = new bytes[](calls.length);
        for(uint256 i = 0; i < calls.length; i++) {
            (bool success, bytes memory ret) = calls[i].target.call(calls[i].callData);
            require(success, "Multicall aggregate: call failed");
            returnData[i] = ret;
        }
    }
    function blockAndAggregate(Call[] memory calls) public returns (uint256 blockNumber, bytes32 blockHash, Result[] memory returnData) {
        (blockNumber, blockHash, returnData) = tryBlockAndAggregate(true, calls);
    }
    function getBlockHash(uint256 blockNumber) public view returns (bytes32 blockHash) {
        blockHash = blockhash(blockNumber);
    }
    function getBlockNumber() public view returns (uint256 blockNumber) {
        blockNumber = block.number;
    }
    function getCurrentBlockCoinbase() public view returns (address coinbase) {
        coinbase = block.coinbase;
    }
    function getCurrentBlockDifficulty() public view returns (uint256 difficulty) {
        difficulty = block.difficulty;
    }
    function getCurrentBlockGasLimit() public view returns (uint256 gaslimit) {
        gaslimit = block.gaslimit;
    }
    function getCurrentBlockTimestamp() public view returns (uint256 timestamp) {
        timestamp = block.timestamp;
    }
    function getEthBalance(address addr) public view returns (uint256 balance) {
        balance = addr.balance;
    }
    function getLastBlockHash() public view returns (bytes32 blockHash) {
        blockHash = blockhash(block.number - 1);
    }
    function getCodeSize(address addr) public view returns (uint256 size) {
        assembly {
            size := extcodesize(addr)
        }
    }
    function getCode(address addr) public view returns (bytes memory code) {
        code = addr.code;
    }
    function getCodeHash(address addr) public view returns (bytes32 codehash) {
        codehash = addr.codehash;
    }
    function getChainId() public view returns (uint256 chainid) {
        chainid = block.chainid;
    }
    function tryAggregate(bool requireSuccess, Call[] memory calls) public returns (Result[] memory returnData) {
        returnData = new Result[](calls.length);
        for(uint256 i = 0; i < calls.length; i++) {
            (bool success, bytes memory ret) = calls[i].target.call(calls[i].callData);

            if (requireSuccess) {
                require(success, "Multicall2 aggregate: call failed");
            }

            returnData[i] = Result(success, ret);
        }
    }
    function tryBlockAndAggregate(bool requireSuccess, Call[] memory calls) public returns (uint256 blockNumber, bytes32 blockHash, Result[] memory returnData) {
        blockNumber = block.number;
        blockHash = blockhash(block.number);
        returnData = tryAggregate(requireSuccess, calls);
    }
}
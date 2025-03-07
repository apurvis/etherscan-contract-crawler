// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Opensea Proxy
import "./ContextMixin.sol";
import "./NativeMetaTransaction.sol";

contract OwnableDelegateProxy {}

contract ProxyRegistry {
    mapping(address => OwnableDelegateProxy) public proxies;
}
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Lallement
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//                                                                                       //
//     ██▓     ▄▄▄       ██▓     ██▓    ▓█████  ███▄ ▄███▓▓█████  ███▄    █ ▄▄▄█████▓    //
//    ▓██▒    ▒████▄    ▓██▒    ▓██▒    ▓█   ▀ ▓██▒▀█▀ ██▒▓█   ▀  ██ ▀█   █ ▓  ██▒ ▓▒    //
//    ▒██░    ▒██  ▀█▄  ▒██░    ▒██░    ▒███   ▓██    ▓██░▒███   ▓██  ▀█ ██▒▒ ▓██░ ▒░    //
//    ▒██░    ░██▄▄▄▄██ ▒██░    ▒██░    ▒▓█  ▄ ▒██    ▒██ ▒▓█  ▄ ▓██▒  ▐▌██▒░ ▓██▓ ░     //
//    ░██████▒ ▓█   ▓██▒░██████▒░██████▒░▒████▒▒██▒   ░██▒░▒████▒▒██░   ▓██░  ▒██▒ ░     //
//    ░ ▒░▓  ░ ▒▒   ▓▒█░░ ▒░▓  ░░ ▒░▓  ░░░ ▒░ ░░ ▒░   ░  ░░░ ▒░ ░░ ▒░   ▒ ▒   ▒ ░░       //
//    ░ ░ ▒  ░  ▒   ▒▒ ░░ ░ ▒  ░░ ░ ▒  ░ ░ ░  ░░  ░      ░ ░ ░  ░░ ░░   ░ ▒░    ░        //
//      ░ ░     ░   ▒     ░ ░     ░ ░      ░   ░      ░      ░      ░   ░ ░   ░          //
//        ░  ░      ░  ░    ░  ░    ░  ░   ░  ░       ░      ░  ░         ░              //
//                                                                                       //
//                                                                                       //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////


contract BDX is ERC721Creator {
    constructor() ERC721Creator("Lallement", "BDX") {}
}
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ILLIQUID//
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////
//                                                           //
//                                                           //
//                                                           //
//     _ _|  |      |     _ _|   _ \   |   | _ _|  __ \      //
//       |   |      |       |   |   |  |   |   |   |   |     //
//       |   |      |       |   |   |  |   |   |   |   |     //
//     ___| _____| _____| ___| \__\_\ \___/  ___| ____/      //
//                                                           //
//                                                           //
//                                                           //
//                                                           //
///////////////////////////////////////////////////////////////


contract ILQD is ERC721Creator {
    constructor() ERC721Creator("ILLIQUID//", "ILQD") {}
}
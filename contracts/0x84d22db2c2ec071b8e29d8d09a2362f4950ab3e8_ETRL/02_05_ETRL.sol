// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Ethereal
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////
//                                        //
//                                        //
//    ▓█████▄▄▄█████▓ ██▀███   ██▓        //
//    ▓█   ▀▓  ██▒ ▓▒▓██ ▒ ██▒▓██▒        //
//    ▒███  ▒ ▓██░ ▒░▓██ ░▄█ ▒▒██░        //
//    ▒▓█  ▄░ ▓██▓ ░ ▒██▀▀█▄  ▒██░        //
//    ░▒████▒ ▒██▒ ░ ░██▓ ▒██▒░██████▒    //
//    ░░ ▒░ ░ ▒ ░░   ░ ▒▓ ░▒▓░░ ▒░▓  ░    //
//     ░ ░  ░   ░      ░▒ ░ ▒░░ ░ ▒  ░    //
//       ░    ░        ░░   ░   ░ ░       //
//       ░  ░           ░         ░  ░    //
//                                        //
//                                        //
////////////////////////////////////////////


contract ETRL is ERC721Creator {
    constructor() ERC721Creator("Ethereal", "ETRL") {}
}
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Grunge Dreams
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▓▓▓████▓▓▓▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓███████████████▓▓▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓██████████████████████▓▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓████████████████████████████▓▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓████████████████████▓████████████▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░▒▓███████████████████▓▓▓▓▓▓▓█████████▓▓▓▒░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░▒▓█████████████████████▓▓▓▓▓▓▓▓▓▓█████████▓▒░░░░░░░░░░░░░░░░░░░░░░    //
//    ░▒▒░░░░░░░░░░░░░▒░░░░░▒▓████▓███████▓███████████▓▓▓▓▓▓▓▓▓▓█████████▓▒░░░░░░░░░░░░░░░░░░░░░    //
//    ▒▒▒▒░░░░░░░░░░░░░▒░░▒▒▓▓█████▓███████▓████████████▓▓▓▓▓▓█▓███████████▒░░░░░░░░░░░░░░░░░░░░    //
//    ▒▒░▒░░░░░▒▒░░▒▒▒▒▒░░▒▓▓████████▓███████████▓█▓██████▓█▓███████████████▓░░░░░▒░░░░░░░░░░░░░    //
//    ▒▒░░░░░░▒▒▒▒▒▒▒▒▒▒░▒▓▒███████████████████▓███▓▓████████████████████████▓▒░░▒▒░░▒░░░░▒░░░░▒    //
//    ░░░░░░░▒▒▒▒▒▒▒▒▒▒▒░▒▓████████▓█████▓███▓████▓█▓▓▓█████████████▓▓▓███████▓▒░░░░▒░░░░▒░░░░▒▒    //
//    ░░░░░░▒▒▒░▒▒░▒░▒▒░░▒▓██████▓█▓█████▓▓███▒▓██▓█████████████▓▓▓▓▓▓▓▓▓██████▓▒░▒▒▒▒░░░▒░░▒▒░▒    //
//    ░░░▒░▒░░▒░░░░░░░░░▒▓███▒▓▒▒▒▒▒▓▓▓▓▓▓▒▒▓▒▒▒▒▓▓▓▓█▓██████▓██▓▓▓▓▓▓▓▓▓▓███▓██▓░░░▒░▒░▒▒░░▒▒▒▒    //
//    ░░░▒░░░░░░░░░░░░░░▓███▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓██████▓██▓███████▓▓██████▒░░░░░▒░░▒▒▒▒▒▒    //
//    ▒▒▒▒░░░░░░░░░░░░░▒▓████▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒█▒█████████████████████████▓▒░░░░▒░▒▒▒▒▒▒▒    //
//    ▒▒▒▒▒▒░░░░░░░░░░░▓████▓▓▓▓█▓▓▒▒▒▒▒▓▒▒▒▒▓▓▓▓▓▓▓▓▓▓▒▓█▓█████████████████████▓▓▓▒░░░▒▒▒▒▒▒▒▒▒    //
//    ▒▒▒▒▒▒░░░░░░░░░░▒█████▓▓▓▓██▓▓▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▒▓▓▒▓█████████▓█████████████▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒    //
//    ▒▒▒▒░▒░░░░░░░░░▒██████▓▓█▓▒▓▓▓▓▓▓▓▒▒▒▒▒▓▓▓▓▓▓████▓▒▓██▓███▓▓█▓███████████████▓▓▒░░▒▒▒▒▒▒▒▒    //
//    ▒▒▒░░░░░░░░░░░▒███████▓▓▓▓▒▒▒▒▒▓▓▓▒▒▒▒▒▓▓▒▒▒▒▒▒▒█▓▒▒██▓███▒▒▓▓██████████████████▓▒░▒▒▒▒▒▒▒    //
//    ▒▒▒░░░░░░░░░░▓█████████▒▒▓▓▓▒▓▓▓▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▒▒▒▒▓████▓▒▒▒▓▓██████████████████▓▓░░▒▒▒▒░    //
//    ▒▒▒▒▒▒▒░░░░░▓██████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓███▓▓▒▒▓████████████████████▓▓▓▓▓▓▓▒    //
//    ▒▒▒▒▒▒▒▒░░▒▓███████████▓▒▒▒▒▒▒▒▒▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓█▓█▓▒▒▓███████████▓▓██████████▓▓▓▓▓▓    //
//    ▒▒▒▒▒▒▒▒░▒▓█▒▓█████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓█▓▓█▓████████████▓▓▓▓▓▓▓████████▓▓▓▓    //
//    ▒▒▒▒▒▒▒░░▓█▒▒███████████▓▒▒▒▒▒▒▒▓▓▒▒█▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓█▓██████████████▓▓▓▓▓▓▓███████▓▓▓▓▓    //
//    ▒▒▒▒▒▒░░▒▓▓▒▓████████████▒▒▒▒▒▒▒▒▓▓█▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓███████████████▓▓▓▓█▓█▓▓███████▓▓█▓    //
//    ▓▒▒▒▒▒░░▓█▒▓▓█████████████▒▒▒▒▒▒▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒███████████████▓▓▓▓████▓██████████▓▓    //
//    ▓▓▓▒░░░▒█▓▒▓▓██▓███████████▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒████▓███████████▓▓▓▓██▓▓███████████▓▓    //
//    ▓▓▓▓▓▒▒▒█▓▓▓▓██▓████████████▒▒▒▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▓█▒▓▓███████████▓▓▓▓▓▓▓▓▓████████████▓▓    //
//    ▓▓▓▓▓▓▓▓██████████████▓▓█████▓▒▓▓▒▓▓▒▓▓▒▒▒▒▒▒▒▒▒▓█▓▓▒▒▓████████▓▓▓▓▓▓▓▓▓▓▓▓▓███████████▓▓▓    //
//    ▓▓▓▓▓▓▓▓███████████████████████▓▒▒▓▓▒▒▓▒▒▒▒▒▓▓██▓▓▓▓▒▒▓█████████▓▓▓▓▓▓▓▓▓▓▓▓████████▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓████████████████████████▓▓▒▒▒▒▒▒▒▓▓███▓▒▒▒▓▒▒▒▒█▓████████▓█▓▓▓▓▓▓▓▓▓▓▓▓█████▓▓▓▓▓█    //
//    ▓▓▓▓▓▓▓▓██████████████████████████████████▓▓▒▒▒▒▒▒▒▒▒▒▒▓██████████████▓█▓▓▓▓▓▓▓█████▓▓████    //
//    ▓▓▓▓▓▓▓█████████████████████████████▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██████████████████▓███████████████    //
//    ▓▓▓▓▓▓▓█████████████████████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█████████████████████████████████    //
//    ▓▓▓▓▓▓███████████████████████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓█████████████████████████▓▓▓▓██    //
//    ▓▓▓▓▓▓███████████████████████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██████████████████████████▓▓▓██    //
//    ▓▓▓▓▓▓███████████████████████████████▓▒▒▒▒▒▒▓▒▒▒▒▒▒▒▒▒▒▒▓▓████████████████████████████████    //
//    ▓▓▓▓▓▓██████████████████████████████████▓▓▒▓▒▒▒▒▒▓▓▓▓█████████████████████████████████████    //
//    ▓▓▓▓▓▓▓█████████████████████████████████████████████████████████████████████████████▓█████    //
//    ▓▓▓▓▓▓▓▓▓███████████████████████████████████████████████████████████████████████████▓█████    //
//    ▒▒▒▒▒▒▒▓█████▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▓▒▒▓▒▓█████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████████████████    //
//    ▓▓▓▓██▓███▓▓▓▓▓█████████████████▓▓█████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▓███████████    //
//    ▓▓████▓▓▓▓▓▓████████████████████████████████████████████████████▓██████▓█▓▓▓▓▓▓▓█▓▒▓▓█████    //
//    ░░░░░░▓▓▓█████████████████████████████████████████████████████████████████▓█▓███████▓▒▒▒▓▓    //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract HALO is ERC721Creator {
    constructor() ERC721Creator("Grunge Dreams", "HALO") {}
}
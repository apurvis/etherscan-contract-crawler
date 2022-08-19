// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: CinemaNinja
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒░░▒░▒▓▒░▒░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓██▓▓▓░░░▓█▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓████▓▓▒▓███▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓▓▓██████▓██▓▓▓▓░▒▒░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓███▓▓██████▓▓▓▓█▓▒░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒██████▓▓▓█▓█▓▓▓▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓▓███████████▓██▓█▓▒░░░▒▒▓▓▓▒░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░▓██▒▒▒▓▓███████▓▓▒░░▒██████████▒░░▒█▓▒░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▓▓▓▓▓▒▒▒▒▓▓▓▓▓▓█████████▓▒░▒▓▒▒▓▓▓░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░▒▒▒████▓██████████████▓█████████▓▒▒▒▓▓▒░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░▒▒▓▓▓▓▓▓▓▓██████████████████████▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░▓██▓▓▓▓▒▓▓▓▓▓▓██████▓██████▓▓▓▓▓███████████████▒░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░▓▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒█████████████▓░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░▓▒▒░░░░░░░░░░▓▓▒▒▒▒▒▒▓▓████████████▓░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░▓▓▓█▓▒░░░░░░░▒▓▓▓▓▓▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░▓▓███▓░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░▒████▓▒▓███▓█▓▓▓▓▓▓▓▓▓▓█▓▓░░░░░▒▓▓▓▒░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░▓▓▓██████▒░░█████▒▓▓▓▓▓▓▓▓▓▒▓▓▓▓▓▓▓▒▓▒░▓▓██▓▓▓░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░▒██▓██████▒░█████▒▓▓▓▓▓▓▒▓▓▓▓▓▒▒▒▓▓▓▓▒▒████▓▒▓▓▓▓▓▓▓▒▓░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░▒▓▓███████▒▓████▒▓████▓▒▓█████▓▓▓███▓▒████▓▓███████▓▒░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░▒███████▓▓████▒▓████▓▒▓██████▓▓███▓▒████▓▓████████▓░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░▒█████████████▒▓████▓▒▓███████████▓▒████▓▓████▓████▓░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░▒████▓▓███████▒▓████▓▒▓███████████▓▒████▓▓████▓▓████▓░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░▒████▓▒███████▒▓████▓▒▓████▓██████▓▒████▓▓███████████▒░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░▒████▓▓▓██████▒▓████▓▒▓████▓▓█████▓▒████▓▓███████████▓░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░▒████▓▓▓▓█████▒▓████▓▒▓████▓▒▓████▓▓████▓▓████▓▓▓▓████▒░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░▒████▓▓█▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███▓▒█████▓▓█▓▓▓▓██▓████▓░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░▓███▓▓██░▓████████████████████▓█▒▓█████▓▓▓▓██▓░▓█▓████▓░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░▒▓▓▓█████░░▓▓▒▒░░░░░░░░░░░░░░░▓▒▓███▓▓▓▓██▓▒▒░░░▒█▓▓██▓░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░▒█████▓▒▒░░░░░░░░░░░░░░░░░░░░░░▒▓▓▓▓▓██▓▒░░░░░░░░░██▓▓▒░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░▒▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓▓██▓▒░░░░░░░░░░░░░█▓▒░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓██▓▓▒░░░░░░░░░░░░░░░░█▒░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract NINJA is ERC721Creator {
    constructor() ERC721Creator("CinemaNinja", "NINJA") {}
}
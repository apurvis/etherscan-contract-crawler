// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: NounsDAOAmigos
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                              //
//                                                                                              //
//                                                                                              //
//        _   __                       ____  ___   ____  ___              _                     //
//       / | / /___  __  ______  _____/ __ \/   | / __ \/   |  ____ ___  (_)___ _____  _____    //
//      /  |/ / __ \/ / / / __ \/ ___/ / / / /| |/ / / / /| | / __ `__ \/ / __ `/ __ \/ ___/    //
//     / /|  / /_/ / /_/ / / / (__  ) /_/ / ___ / /_/ / ___ |/ / / / / / / /_/ / /_/ (__  )     //
//    /_/ |_/\____/\__,_/_/ /_/____/_____/_/  |_\____/_/  |_/_/ /_/ /_/_/\__, /\____/____/      //
//                                                                      /____/                  //
//                                                                                              //
//                                                                                              //
//                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////


contract LOL is ERC721Creator {
    constructor() ERC721Creator("NounsDAOAmigos", "LOL") {}
}
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ARCHETYPES
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////
//                                                                        //
//                                                                        //
//        ___    ____  ________  ________________  ______  ___________    //
//       /   |  / __ \/ ____/ / / / ____/_  __/\ \/ / __ \/ ____/ ___/    //
//      / /| | / /_/ / /   / /_/ / __/   / /    \  / /_/ / __/  \__ \     //
//     / ___ |/ _, _/ /___/ __  / /___  / /     / / ____/ /___ ___/ /     //
//    /_/  |_/_/ |_|\____/_/ /_/_____/ /_/     /_/_/   /_____//____/      //
//                                                                        //
//                                                                        //
//                                                                        //
//                                                                        //
//                                                                        //
////////////////////////////////////////////////////////////////////////////


contract ARCHETYPES is ERC721Creator {
    constructor() ERC721Creator("ARCHETYPES", "ARCHETYPES") {}
}
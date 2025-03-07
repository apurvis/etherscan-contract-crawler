// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Infinite Sirens
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////
//                                                                       //
//                                                                       //
//                                                                       //
//      ___        __ _       _ _         ____  _                        //
//     |_ _|_ __  / _(_)_ __ (_) |_ ___  / ___|(_)_ __ ___ _ __  ___     //
//      | || '_ \| |_| | '_ \| | __/ _ \ \___ \| | '__/ _ \ '_ \/ __|    //
//      | || | | |  _| | | | | | ||  __/  ___) | | | |  __/ | | \__ \    //
//     |___|_| |_|_| |_|_| |_|_|\__\___| |____/|_|_|  \___|_| |_|___/    //
//                                                                       //
//                                                                       //
//                                                                       //
//                                                                       //
///////////////////////////////////////////////////////////////////////////


contract INSNS is ERC721Creator {
    constructor() ERC721Creator("Infinite Sirens", "INSNS") {}
}
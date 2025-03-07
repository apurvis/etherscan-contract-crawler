// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Emma Miller
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                                                                    //
//                                                                    //
//                                                _ _ _               //
//      ___ _ __ ___  _ __ ___   __ _   _ __ ___ (_| | | ___ _ __     //
//     / _ | '_ ` _ \| '_ ` _ \ / _` | | '_ ` _ \| | | |/ _ | '__|    //
//    |  __| | | | | | | | | | | (_| | | | | | | | | | |  __| |       //
//     \___|_| |_| |_|_| |_| |_|\__,_| |_| |_| |_|_|_|_|\___|_|       //
//                                                                    //
//                                                                    //
//                                                                    //
//                                                                    //
////////////////////////////////////////////////////////////////////////


contract EM is ERC721Creator {
    constructor() ERC721Creator("Emma Miller", "EM") {}
}
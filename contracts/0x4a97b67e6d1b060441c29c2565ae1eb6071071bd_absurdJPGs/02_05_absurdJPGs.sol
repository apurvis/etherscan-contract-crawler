// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: absurd JPGs
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                              //
//                                                                                              //
//                                                                                              //
//     █████╗ ██████╗ ███████╗██╗   ██╗██████╗ ██████╗          ██╗██████╗  ██████╗ ███████╗    //
//    ██╔══██╗██╔══██╗██╔════╝██║   ██║██╔══██╗██╔══██╗         ██║██╔══██╗██╔════╝ ██╔════╝    //
//    ███████║██████╔╝███████╗██║   ██║██████╔╝██║  ██║         ██║██████╔╝██║  ███╗███████╗    //
//    ██╔══██║██╔══██╗╚════██║██║   ██║██╔══██╗██║  ██║    ██   ██║██╔═══╝ ██║   ██║╚════██║    //
//    ██║  ██║██████╔╝███████║╚██████╔╝██║  ██║██████╔╝    ╚█████╔╝██║     ╚██████╔╝███████║    //
//    ╚═╝  ╚═╝╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝      ╚════╝ ╚═╝      ╚═════╝ ╚══════╝    //
//                                                                                              //
//                                                                                              //
//                                                                                              //
//                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////


contract absurdJPGs is ERC721Creator {
    constructor() ERC721Creator("absurd JPGs", "absurdJPGs") {}
}
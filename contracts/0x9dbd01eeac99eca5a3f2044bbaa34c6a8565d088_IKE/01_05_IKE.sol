// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Irvin's Editions
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////
//                                                                  //
//                                                                  //
//                                                                  //
//    ██╗██████╗ ██╗   ██╗██╗███╗   ██╗███████╗                     //
//    ██║██╔══██╗██║   ██║██║████╗  ██║██╔════╝                     //
//    ██║██████╔╝██║   ██║██║██╔██╗ ██║███████╗                     //
//    ██║██╔══██╗╚██╗ ██╔╝██║██║╚██╗██║╚════██║                     //
//    ██║██║  ██║ ╚████╔╝ ██║██║ ╚████║███████║                     //
//    ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝  ╚═══╝╚══════╝                     //
//                                                                  //
//    ███████╗██████╗ ██╗████████╗██╗ ██████╗ ███╗   ██╗███████╗    //
//    ██╔════╝██╔══██╗██║╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝    //
//    █████╗  ██║  ██║██║   ██║   ██║██║   ██║██╔██╗ ██║███████╗    //
//    ██╔══╝  ██║  ██║██║   ██║   ██║██║   ██║██║╚██╗██║╚════██║    //
//    ███████╗██████╔╝██║   ██║   ██║╚██████╔╝██║ ╚████║███████║    //
//    ╚══════╝╚═════╝ ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝    //
//                                                                  //
//                                                                  //
//                                                                  //
//                                                                  //
//////////////////////////////////////////////////////////////////////


contract IKE is ERC721Creator {
    constructor() ERC721Creator("Irvin's Editions", "IKE") {}
}
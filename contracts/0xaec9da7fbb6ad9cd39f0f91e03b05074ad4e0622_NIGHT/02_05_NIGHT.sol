// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: NOTTURNO
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////
//                                                               //
//                                                               //
//    ███████╗██████╗ ███████╗ ██████╗██╗ █████╗ ██╗             //
//    ██╔════╝██╔══██╗██╔════╝██╔════╝██║██╔══██╗██║             //
//    ███████╗██████╔╝█████╗  ██║     ██║███████║██║             //
//    ╚════██║██╔═══╝ ██╔══╝  ██║     ██║██╔══██║██║             //
//    ███████║██║     ███████╗╚██████╗██║██║  ██║███████╗        //
//    ╚══════╝╚═╝     ╚══════╝ ╚═════╝╚═╝╚═╝  ╚═╝╚══════╝        //
//                                                               //
//    ██████╗ ██╗███████╗ ██████╗███████╗███████╗                //
//    ██╔══██╗██║██╔════╝██╔════╝██╔════╝██╔════╝                //
//    ██████╔╝██║█████╗  ██║     █████╗  ███████╗                //
//    ██╔═══╝ ██║██╔══╝  ██║     ██╔══╝  ╚════██║                //
//    ██║     ██║███████╗╚██████╗███████╗███████║                //
//    ╚═╝     ╚═╝╚══════╝ ╚═════╝╚══════╝╚══════╝                //
//                                                               //
//    ██████╗ ██╗   ██╗                                          //
//    ██╔══██╗╚██╗ ██╔╝                                          //
//    ██████╔╝ ╚████╔╝                                           //
//    ██╔══██╗  ╚██╔╝                                            //
//    ██████╔╝   ██║                                             //
//    ╚═════╝    ╚═╝                                             //
//                                                               //
//    ██████╗ ██╗ ██████╗  ██████╗ ██╗                           //
//    ██╔══██╗██║██╔════╝ ██╔════╝ ██║                           //
//    ██████╔╝██║██║  ███╗██║  ███╗██║                           //
//    ██╔═══╝ ██║██║   ██║██║   ██║██║                           //
//    ██║     ██║╚██████╔╝╚██████╔╝██║                           //
//    ╚═╝     ╚═╝ ╚═════╝  ╚═════╝ ╚═╝                           //
//                                                               //
//                                                               //
//                                                               //
///////////////////////////////////////////////////////////////////


contract NIGHT is ERC721Creator {
    constructor() ERC721Creator("NOTTURNO", "NIGHT") {}
}
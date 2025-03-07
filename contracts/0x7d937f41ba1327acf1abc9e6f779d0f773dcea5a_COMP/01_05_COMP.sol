// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: computer lab
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                               ╓▌                                       //
//                                              ┌███                                      //
//                                         ╓▄▄▄▄█████▄▄▄▄,                                //
//                                         ╙████████████▀                                 //
//                                            ▓███████╙                                   //
//                                            ████████▌                                   //
//                                           ▐█▀"   └▀█                                   //
//                                                                                        //
//                                                                                        //
//              █▓▀      ▀█▀"      ██       █▀█L     █▀▀▌     ╒█▀█⌐     ▓▀▀█      █▀█µ    //
//              φ▓█"      █─      █▀▀█      █▀█      █▓▓▀     ▐█▀█      █▌▄█      █▀╙     //
//                                                                                        //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract COMP is ERC721Creator {
    constructor() ERC721Creator("computer lab", "COMP") {}
}
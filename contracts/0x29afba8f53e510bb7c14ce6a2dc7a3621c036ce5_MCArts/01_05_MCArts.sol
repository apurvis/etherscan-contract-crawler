// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: MCArtist
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//                                                                              //
//    ███╗░░░███╗░█████╗░██████╗░██╗░░░██╗░█████╗░███╗░░██╗███╗░░██╗███████╗    //
//    ████╗░████║██╔══██╗██╔══██╗╚██╗░██╔╝██╔══██╗████╗░██║████╗░██║██╔════╝    //
//    ██╔████╔██║███████║██████╔╝░╚████╔╝░███████║██╔██╗██║██╔██╗██║█████╗░░    //
//    ██║╚██╔╝██║██╔══██║██╔══██╗░░╚██╔╝░░██╔══██║██║╚████║██║╚████║██╔══╝░░    //
//    ██║░╚═╝░██║██║░░██║██║░░██║░░░██║░░░██║░░██║██║░╚███║██║░╚███║███████╗    //
//    ╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚══╝╚═╝░░╚══╝╚══════╝    //
//                                                                              //
//    ░█████╗░██╗░░██╗██╗░██████╗██╗░░██╗░█████╗░██╗░░░░░███╗░░░███╗  ░░░░░░    //
//    ██╔══██╗██║░░██║██║██╔════╝██║░░██║██╔══██╗██║░░░░░████╗░████║  ░░░░░░    //
//    ██║░░╚═╝███████║██║╚█████╗░███████║██║░░██║██║░░░░░██╔████╔██║  █████╗    //
//    ██║░░██╗██╔══██║██║░╚═══██╗██╔══██║██║░░██║██║░░░░░██║╚██╔╝██║  ╚════╝    //
//    ╚█████╔╝██║░░██║██║██████╔╝██║░░██║╚█████╔╝███████╗██║░╚═╝░██║  ░░░░░░    //
//    ░╚════╝░╚═╝░░╚═╝╚═╝╚═════╝░╚═╝░░╚═╝░╚════╝░╚══════╝╚═╝░░░░░╚═╝  ░░░░░░    //
//                                                                              //
//    ███╗░░░███╗░█████╗░░█████╗░██████╗░████████╗██╗░██████╗████████╗          //
//    ████╗░████║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██║██╔════╝╚══██╔══╝          //
//    ██╔████╔██║██║░░╚═╝███████║██████╔╝░░░██║░░░██║╚█████╗░░░░██║░░░          //
//    ██║╚██╔╝██║██║░░██╗██╔══██║██╔══██╗░░░██║░░░██║░╚═══██╗░░░██║░░░          //
//    ██║░╚═╝░██║╚█████╔╝██║░░██║██║░░██║░░░██║░░░██║██████╔╝░░░██║░░░          //
//    ╚═╝░░░░░╚═╝░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝╚═════╝░░░░╚═╝░░░          //
//                                                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////


contract MCArts is ERC721Creator {
    constructor() ERC721Creator("MCArtist", "MCArts") {}
}
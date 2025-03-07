// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Foxes
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                ▒▒        ▒▒                                                                //
//                ░░░░    ░░▒▒                                                                //
//                ░░▒▒  ▒▒░░▒▒                                                                //
//                ▒▒▒▒▒▒░░░░▒▒                                                                //
//              ▒▒░░░░░░░░▒▒▒▒                                                                //
//              ▒▒▒▒▒▒░░▒▒▒▒▒▒                                                                //
//            ▒▒██▒▒▒▒░░▒▒▒▒▒▒                                                                //
//    ▒▒░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒                                                              //
//      ░░░░░░░░░░░░░░░░░░▒▒░░▒▒▒▒                                                            //
//                  ░░░░░░▒▒▒▒▒▒▒▒▒▒                                                          //
//                  ░░▒▒░░▒▒░░▒▒▒▒▒▒▒▒                                                        //
//                  ░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒                              //
//                  ░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░                          //
//                  ░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒                        //
//                  ░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒                      //
//                    ░░▒▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒                    //
//                    ░░░░▒▒░░▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒                    //
//                    ▒▒░░▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒                  //
//                    ▒▒░░▒▒░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒                  //
//                  ▒▒▒▒▒▒░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒                //
//                  ░░▒▒    ░░░░░░▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒░░▒▒▒▒▒▒░░░░▒▒                //
//                ██▒▒        ░░▒▒              ▒▒▒▒▒▒▒▒░░░░░░░░▒▒░░▒▒░░▒▒▒▒▒▒▒▒              //
//                ████        ░░██                ▒▒░░▒▒░░▒▒░░░░▒▒▒▒  ▒▒▒▒▒▒░░▒▒              //
//              ████          ░░▓▓                ░░░░▒▒▒▒░░▒▒░░▒▒    ▒▒▒▒▒▒░░▒▒              //
//            ██████          ████                  ▒▒██  ░░▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒▒▒▒▒            //
//            ████            ████                ██████    ░░▒▒▒▒▓▓    ▒▒▒▒▒▒▒▒▒▒            //
//            ████            ████                ██████      ▒▒▒▒██    ▒▒░░░░▒▒▒▒▒▒          //
//              ██▓▓          ████              ██████░░      ██████    ▒▒▒▒░░▒▒▒▒▒▒          //
//              ██████        ████        ██████████          ██████    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒        //
//                ████        ████        ████████          ▓▓████      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░      //
//                          ██████                    ██▓▓▓▓████          ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                          ██████                    ████████              ▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract FOXES is ERC721Creator {
    constructor() ERC721Creator("Foxes", "FOXES") {}
}
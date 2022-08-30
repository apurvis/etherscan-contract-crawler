// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: BROWNTOPINK
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                     //
//                                                                                                                                                                     //
//                                                        ░░██▒▒░░▒▒▓▓▓▓▓▓                                                                                             //
//                                                        ▓▓▓▓░░░░▓▓░░▓▓██                                                                                             //
//                                                        ████  ▒▒░░▓▓▓▓██                                                                                             //
//                                                        ██▒▒▓▓▒▒▒▒████▒▒                                                                                             //
//                                                      ░░▓▓  ░░░░▓▓██▒▒                ▒▒██                                                                           //
//                                                      ░░░░▒▒░░░░▓▓▓▓              ▒▒██▓▓▓▓                                                                           //
//                                                      ▒▒      ▒▒▓▓            ░░██▓▓▓▓▓▓██                                                                           //
//                                                    ░░░░  ░░░░▒▒            ▓▓▓▓██▓▓▒▒▒▒▓▓                                                                           //
//                                                    ▒▒      ░░          ▒▒████▓▓▒▒▓▓▒▒██░░                                                                           //
//                                                    ░░    ▒▒░░      ▒▒▓▓██▒▒░░▒▒▒▒▓▓▓▓▓▓                                                                             //
//                                                        ░░░░      ▓▓▒▒▓▓░░░░▓▓  ░░░░██                                                                               //
//                                                  ░░    ░░░░    ▓▓▒▒  ░░▒▒░░▓▓▒▒▓▓████                                                                               //
//                                                  ▒▒  ▒▒▒▒    ▒▒    ▒▒▓▓▓▓▒▒▒▒░░████░░                                                                               //
//                                          ░░      ░░▒▒▓▓    ░░  ░░▓▓░░░░▒▒▒▒▓▓▓▓▓▓                                                                                   //
//    ▓▓                                  ████▓▓  ░░░░▒▒  ░░  ░░░░░░░░▓▓▓▓▓▓▓▓▓▓██                                                                                     //
//    ▓▓████▓▓▒▒░░                        ████▓▓░░    ░░░░    ░░▒▒▓▓▓▓▓▓▓▓▒▒░░                                                                                         //
//    ▓▓██▓▓▓▓▓▓▓▓▓▓████▒▒  ░░                ▒▒▓▓░░      ░░████▓▓▓▓░░                                                                                                 //
//    ▓▓██▓▓▓▓██▓▓▓▓██▓▓▒▒▓▓▓▓▓▓▓▓░░░░░░░░░░  ▒▒▓▓▓▓▓▓░░██▓▓                                                                                                           //
//    ▒▒██▓▓▓▓▓▓▓▓▓▓▒▒▒▒░░▒▒▒▒▒▒░░░░░░        ░░▓▓▓▓▓▓▒▒                                                                                                               //
//        ▓▓████▓▓▓▓▒▒░░░░      ░░░░░░░░░░  ░░▒▒▒▒▓▓▓▓▓▓                                                                                                               //
//            ▒▒▒▒██▓▓██▓▓░░░░░░░░░░░░░░░░██▒▒░░░░▒▒▓▓██                                                                                                               //
//                    ▓▓▓▓▓▓▓▓▓▓██████▓▓░░▓▓░░  ▓▓░░  ██░░                                                                                                             //
//                      ▓▓▓▓██▓▓████▒▒▒▒▒▒▒▒  ▓▓    ░░░░▓▓                                                                                                             //
//                          ░░▒▒▒▒▓▓▓▓▓▓▓▓  ▓▓        ▓▓▓▓                                                                                                             //
//                            ▓▓▓▓▓▓▓▓▒▒  ▒▒░░          ▓▓▒▒                                                                                                           //
//                      ░░▒▒▓▓▓▓▓▓▓▓▒▒░░▒▒░░            ▒▒░░░░                                                                                                         //
//                  ░░▓▓▒▒▓▓▓▓██░░▒▒▒▒▓▓▒▒                ▒▒▓▓                                                                                                         //
//                  ▓▓▓▓▓▓▓▓██░░▒▒▓▓▓▓██                  ░░░░                                                                                                         //
//                  ▓▓████▒▒░░▓▓▓▓▓▓██░░                    ░░▓▓                                                                                                       //
//                  ░░██▓▓▓▓██████▓▓░░                        ░░▒▒                                                                                                     //
//                    ▒▒██▓▓▓▓██▓▓░░                          ▒▒▒▒                                                                                                     //
//                        ░░▒▒                                  ░░▓▓                                                                                                   //
//                                                              ░░░░░░                                                                                                 //
//                                                                                                                                                                     //
//                                                                                                                                                                     //
//                                                                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract BTP is ERC721Creator {
    constructor() ERC721Creator("BROWNTOPINK", "BTP") {}
}
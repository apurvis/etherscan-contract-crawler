// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Rogue's Rogues
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////
//                                                                                //
//                                                                                //
//                                                                                //
//                                                                                //
//                                                                                //
//                                                                                //
//                                                                                //
//                                                                                //
//                                                                                //
//                                                                                //
//                                                                                //
//                                                                                //
//                                                                                //
//                 ╗╗╗╗╗╗╗╗╖                                                      //
//                   ╢╣╣╣╙╙╣╣╣╣                                                   //
//                    ╢╣╣╣ ╓╣╣╣╝  ╔╣╣╣╣╣╣╣╖  ╔╣╣╣╣╣╣╣╣  ╣╣╣╕ ╞╣╣╣  ╔╣╣╣╣╣╣╦       //
//                     ╢╣╣╣╣╣╣╣┌  ║╣╣╣  ╙╣╣╣ ║╣╣╣┘ ╙╣╣╣  ╣╣╣╕ ╞╣╣╣ ╔╣╣╣╗╗╣╣╣═     //
//                      ╢╣╣╣ ║╣╣╣╕ ╚╣╣╣╦ ╔╣╣╣ ║╣╣╣╦ ║╣╣╣  ╣╣╣╦ ║╣╣╣ ╙╣╣╣╢╙╙╙╙     //
//                       ╢╣╣╣  ╢╣╣╣  ╙╝╣╣╣╣╣╜   ╙╣╣╣╝╬╣╣╣  ╙╣╣╣╝║╣╣╣  ╙╝╣╣╣╣╣═    //
//                                               ╔╖╓╓╔╣╣╣╩                        //
//                                                ╚╝╣╣╝╝╜                         //
//                                                                                //
//                                                                                //
//                                                                                //
//                                                                                //
//                                                                                //
////////////////////////////////////////////////////////////////////////////////////


contract RBM is ERC721Creator {
    constructor() ERC721Creator("Rogue's Rogues", "RBM") {}
}
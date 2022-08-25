// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: HEX<3
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////
//                                                //
//                                                //
//    .------..------..------..------..------.    //
//    |H.--. ||E.--. ||X.--. ||<.--. ||3.--. |    //
//    | :/\: || (\/) || :/\: || (\/) || :(): |    //
//    | (__) || :\/: || (__) || :\/: || ()() |    //
//    | '--'H|| '--'E|| '--'X|| '--'<|| '--'3|    //
//    `------'`------'`------'`------'`------'    //
//                                                //
//                                                //
//                                                //
////////////////////////////////////////////////////


contract HEX3 is ERC721Creator {
    constructor() ERC721Creator("HEX<3", "HEX3") {}
}
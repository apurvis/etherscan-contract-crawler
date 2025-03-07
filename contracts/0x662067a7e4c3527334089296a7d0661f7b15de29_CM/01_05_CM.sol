// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Celestial Mothers
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
//                                                                               //
//                                                                               //
//     ______  ______  __      ______  ______  ______  __  ______  __            //
//    /\  ___\/\  ___\/\ \    /\  ___\/\  ___\/\__  _\/\ \/\  __ \/\ \           //
//    \ \ \___\ \  __\\ \ \___\ \  __\\ \___  \/_/\ \/\ \ \ \  __ \ \ \____      //
//     \ \_____\ \_____\ \_____\ \_____\/\_____\ \ \_\ \ \_\ \_\ \_\ \_____\     //
//      \/_____/\/_____/\/_____/\/_____/\/_____/  \/_/  \/_/\/_/\/_/\/_____/     //
//                                                                               //
//     __    __  ______  ______  __  __  ______  ______  ______                  //
//    /\ "-./  \/\  __ \/\__  _\/\ \_\ \/\  ___\/\  == \/\  ___\                 //
//    \ \ \-./\ \ \ \/\ \/_/\ \/\ \  __ \ \  __\\ \  __<\ \___  \                //
//     \ \_\ \ \_\ \_____\ \ \_\ \ \_\ \_\ \_____\ \_\ \_\/\_____\               //
//      \/_/  \/_/\/_____/  \/_/  \/_/\/_/\/_____/\/_/ /_/\/_____/               //
//                                                                               //
//                                                                               //
//                                                                               //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////


contract CM is ERC721Creator {
    constructor() ERC721Creator("Celestial Mothers", "CM") {}
}
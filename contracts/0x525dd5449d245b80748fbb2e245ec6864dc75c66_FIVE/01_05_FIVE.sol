// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: 5000 Space Aliens
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////
//                                                                                     //
//                                                                                     //
//    ___/\\\\\\\\\\\\\\\______/\\\\\\\________/\\\\\\\________/\\\\\\\____            //
//     __\/\\\///////////_____/\\\/////\\\____/\\\/////\\\____/\\\/////\\\__           //
//      __\/\\\_______________/\\\____\//\\\__/\\\____\//\\\__/\\\____\//\\\_          //
//       __\/\\\\\\\\\\\\_____\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\_         //
//        __\////////////\\\___\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\_        //
//         _____________\//\\\__\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\_       //
//          __/\\\________\/\\\__\//\\\____/\\\__\//\\\____/\\\__\//\\\____/\\\__      //
//           _\//\\\\\\\\\\\\\/____\///\\\\\\\/____\///\\\\\\\/____\///\\\\\\\/___     //
//            __\/////////////________\///////________\///////________\///////_____    //
//                                                                                     //
//                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////


contract FIVE is ERC721Creator {
    constructor() ERC721Creator("5000 Space Aliens", "FIVE") {}
}
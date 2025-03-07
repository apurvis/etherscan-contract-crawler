// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Yellow
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//                                                                           //
//                    ('-.                                    (`\ .-') /`    //
//                  _(  OO)                                    `.( OO ),'    //
//      ,--.   ,--.(,------.,--.      ,--.      .-'),-----. ,--./  .--.      //
//       \  `.'  /  |  .---'|  |.-')  |  |.-') ( OO'  .-.  '|      |  |      //
//     .-')     /   |  |    |  | OO ) |  | OO )/   |  | |  ||  |   |  |,     //
//    (OO  \   /   (|  '--. |  |`-' | |  |`-' |\_) |  |\|  ||  |.'.|  |_)    //
//     |   /  /\_   |  .--'(|  '---.'(|  '---.'  \ |  | |  ||         |      //
//     `-./  /.__)  |  `---.|      |  |      |    `'  '-'  '|   ,'.   |      //
//       `--'       `------'`------'  `------'      `-----' '--'   '--'      //
//                                                                           //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////


contract YELLOW is ERC721Creator {
    constructor() ERC721Creator("Yellow", "YELLOW") {}
}
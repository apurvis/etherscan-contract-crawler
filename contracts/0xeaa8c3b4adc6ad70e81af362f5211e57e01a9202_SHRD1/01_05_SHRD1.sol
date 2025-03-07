// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Shrouded
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                             //
//                                                                                             //
//                        ____   _   _   ____     ___    _   _   ___     ____   ___            //
//     ___________       / ___| | | | | |  _ \   / _ \  | | | | |  _ \  |  __| |  _ \          //
//                \_    | |___  | |_| | | |_| | | | | | | | | | | | \ | | |__  | | \ |         //
//              \   \    \__  \ |  _  | |  _  / | | | | | | | | | |  || |  __| | |  ||         //
//               |   \   ___| | | | | | | | \ \ | |_| | | \_/ | | |_/ | | |__  | |_/ |         //
//               | | |  |_____/ |_| |_| |_| |_|  \___/   \___/  |____/  |____| |____/          //
//               | | |                                                                         //
//               | | |                                                                         //
//               | | |                                                                         //
//               | | |__                                             _________                 //
//               | | |  \_                                          | \____   \_               //
//               |  \ \   \_                                        |      \_   \_             //
//                \  | |    \          _____                        |        \    \_           //
//                 |   |     \__    __/     \__                     |         |     \___       //
//                  \   \       \__/           \______           __/          |         \_     //
//                   |   |         \                  \_______  /                              //
//                       |          |                         \/                               //
//    ____               |          |                       __/                                //
//        \               \          \                     /                                   //
//         \               \          |                 __/                                    //
//          |               \          \_            __/                                _/     //
//          |                \_          \__        /                                  /       //
//           \                 \_    /\     \     _/                                 _/        //
//            \                  \__ /\       \__/                                __/          //
//             \_                   \||        \_____________                    /             //
//               \                     \                     \__________________/              //
//     /\/\/\                           \_______                              /\    /\         //
//    /  //  \/\  /\                            \___________             /\/\/  \/\/  \        //
//    / / /  \ \/\  \ /\                                    \____     /\/  \ \  /  \  \        //
//      /_/  \ /  \ \/  \                                       /    /  /  \ \  /  \  _\       //
//       | || | || |  ||_                                      /______|| || | || || ||_____    //
//                                                                                             //
//                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////


contract SHRD1 is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
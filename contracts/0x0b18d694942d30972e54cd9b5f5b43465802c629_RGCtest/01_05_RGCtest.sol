// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: RAIDERS GAME
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                        //
//                                                                                                                                                        //
//      ____       _     _                        __   _   _             ____                _    __        __        _       _                 _         //
//     |  _ \ __ _(_) __| | ___ _ __ ___    ___  / _| | |_| |__   ___   / ___|_ __ ___  __ _| |_  \ \      / /_ _ ___| |_ ___| | __ _ _ __   __| |___     //
//     | |_) / _` | |/ _` |/ _ \ '__/ __|  / _ \| |_  | __| '_ \ / _ \ | |  _| '__/ _ \/ _` | __|  \ \ /\ / / _` / __| __/ _ \ |/ _` | '_ \ / _` / __|    //
//     |  _ < (_| | | (_| |  __/ |  \__ \ | (_) |  _| | |_| | | |  __/ | |_| | | |  __/ (_| | |_    \ V  V / (_| \__ \ ||  __/ | (_| | | | | (_| \__ \    //
//     |_| \_\__,_|_|\__,_|\___|_|  |___/  \___/|_|    \__|_| |_|\___|  \____|_|  \___|\__,_|\__|    \_/\_/ \__,_|___/\__\___|_|\__,_|_| |_|\__,_|___/    //
//    ____________________________________________________________________________________________________________________________/*\_________________    //
//                                                                                                                                                        //
//                                                                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract RGCtest is ERC721Creator {
    constructor() ERC721Creator("RAIDERS GAME", "RGCtest") {}
}
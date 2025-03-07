// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ICY Queens
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//                                                                          //
//    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$    //
//    $$                                                              $$    //
//    $$                  /$$$$$$  /$$$$$$  /$$     /$$               $$    //
//    $$                  |_  $$_/ /$$__  $$|  $$   /$$/              $$    //
//    $$                    | $$  | $$  \__/ \  $$ /$$/               $$    //
//    $$                    | $$  | $$        \  $$$$/                $$    //
//    $$                    | $$  | $$         \  $$/                 $$    //
//    $$                    | $$  | $$    $$    | $$                  $$    //
//    $$                   /$$$$$$|  $$$$$$/    | $$                  $$    //
//    $$                  |______/ \______/     |__/                  $$    //
//    $$                                                              $$    //
//    $$                                                              $$    //
//    $$                                                              $$    //
//    $$   /$$$$$$  /$$   /$$ /$$$$$$$$ /$$$$$$$$ /$$   /$$  /$$$$$$  $$    //
//    $$  /$$__  $$| $$  | $$| $$_____/| $$_____/| $$$ | $$ /$$__  $$ $$    //
//    $$ | $$  \ $$| $$  | $$| $$      | $$      | $$$$| $$| $$  \__/ $$    //
//    $$ | $$  | $$| $$  | $$| $$$$$   | $$$$$   | $$ $$ $$|  $$$$$$  $$    //
//    $$ | $$  | $$| $$  | $$| $$__/   | $$__/   | $$  $$$$ \____  $$ $$    //
//    $$ | $$/$$ $$| $$  | $$| $$      | $$      | $$\  $$$ /$$  \ $$ $$    //
//    $$ |  $$$$$$/|  $$$$$$/| $$$$$$$$| $$GFXes$| $$ \  $$|  $$$$$$/ $$    //
//    $$  \____ $$$ \______/ |________/|________/|__/  \__/ \______/  $$    //
//    $$       \__/                                                   $$    //
//    $$                                 by Gursimrat Ganda aka GFXes $$    //
//    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$    //
//                                                                          //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////


contract ICQ is ERC721Creator {
    constructor() ERC721Creator("ICY Queens", "ICQ") {}
}
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: GIAN33
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
//     /$$$$$$$   /$$$$$$  /$$       /$$     /$$ /$$$$$$$  /$$$$$$$$ /$$   /$$  /$$$$$$  /$$$$$$$$  /$$$$$$   /$$$$$$     //
//    | $$__  $$ /$$__  $$| $$      |  $$   /$$/| $$__  $$| $$_____/| $$  | $$ /$$__  $$| $$_____/ /$$__  $$ /$$__  $$    //
//    | $$  \ $$| $$  \ $$| $$       \  $$ /$$/ | $$  \ $$| $$      | $$  | $$| $$  \__/| $$      | $$  \__/| $$  \__/    //
//    | $$$$$$$/| $$  | $$| $$        \  $$$$/  | $$  | $$| $$$$$   | $$  | $$| $$      | $$$$$   |  $$$$$$ | $$$$$$$     //
//    | $$____/ | $$  | $$| $$         \  $$/   | $$  | $$| $$__/   | $$  | $$| $$      | $$__/    \____  $$| $$__  $$    //
//    | $$      | $$  | $$| $$          | $$    | $$  | $$| $$      | $$  | $$| $$    $$| $$       /$$  \ $$| $$  \ $$    //
//    | $$      |  $$$$$$/| $$$$$$$$    | $$    | $$$$$$$/| $$$$$$$$|  $$$$$$/|  $$$$$$/| $$$$$$$$|  $$$$$$/|  $$$$$$/    //
//    |__/       \______/ |________/    |__/    |_______/ |________/ \______/  \______/ |________/ \______/  \______/     //
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract P6 is ERC721Creator {
    constructor() ERC721Creator("GIAN33", "P6") {}
}
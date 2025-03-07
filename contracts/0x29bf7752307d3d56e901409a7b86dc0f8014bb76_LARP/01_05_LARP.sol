// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: LARPS
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                //
//                                                                                                                                                                //
//                                                                                                                                                                //
//     ▄█          ▄████████    ▄████████    ▄███████▄    ▄████████      ▀█████████▄  ▄██   ▄         ▄███████▄     ▄████████   ▄▄▄▄███▄▄▄▄     ▄▄▄▄███▄▄▄▄       //
//    ███         ███    ███   ███    ███   ███    ███   ███    ███        ███    ███ ███   ██▄      ██▀     ▄██   ███    ███ ▄██▀▀▀███▀▀▀██▄ ▄██▀▀▀███▀▀▀██▄     //
//    ███         ███    ███   ███    ███   ███    ███   ███    █▀         ███    ███ ███▄▄▄███            ▄███▀   ███    █▀  ███   ███   ███ ███   ███   ███     //
//    ███         ███    ███  ▄███▄▄▄▄██▀   ███    ███   ███              ▄███▄▄▄██▀  ▀▀▀▀▀▀███       ▀█▀▄███▀▄▄  ▄███▄▄▄     ███   ███   ███ ███   ███   ███     //
//    ███       ▀███████████ ▀▀███▀▀▀▀▀   ▀█████████▀  ▀███████████      ▀▀███▀▀▀██▄  ▄██   ███        ▄███▀   ▀ ▀▀███▀▀▀     ███   ███   ███ ███   ███   ███     //
//    ███         ███    ███ ▀███████████   ███                 ███        ███    ██▄ ███   ███      ▄███▀         ███    █▄  ███   ███   ███ ███   ███   ███     //
//    ███▌    ▄   ███    ███   ███    ███   ███           ▄█    ███        ███    ███ ███   ███      ███▄     ▄█   ███    ███ ███   ███   ███ ███   ███   ███     //
//    █████▄▄██   ███    █▀    ███    ███  ▄████▀       ▄████████▀       ▄█████████▀   ▀█████▀        ▀████████▀   ██████████  ▀█   ███   █▀   ▀█   ███   █▀      //
//    ▀                        ███    ███                                                                                                                         //
//                                                                                                                                                                //
//                                                                                                                                                                //
//                                                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract LARP is ERC721Creator {
    constructor() ERC721Creator("LARPS", "LARP") {}
}
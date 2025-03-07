// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Marokuna
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////
//                                                                                //
//                                                                                //
//                                                                                //
//     ███    ███  █████  ██████   ██████  ██   ██ ██    ██ ███    ██  █████      //
//     ████  ████ ██   ██ ██   ██ ██    ██ ██  ██  ██    ██ ████   ██ ██   ██     //
//     ██ ████ ██ ███████ ██████  ██    ██ █████   ██    ██ ██ ██  ██ ███████     //
//     ██  ██  ██ ██   ██ ██   ██ ██    ██ ██  ██  ██    ██ ██  ██ ██ ██   ██     //
//     ██      ██ ██   ██ ██   ██  ██████  ██   ██  ██████  ██   ████ ██   ██     //
//                                                                                //
//                                                                                //
//                                                                                //
////////////////////////////////////////////////////////////////////////////////////


contract MRKNA is ERC721Creator {
    constructor() ERC721Creator("Marokuna", "MRKNA") {}
}
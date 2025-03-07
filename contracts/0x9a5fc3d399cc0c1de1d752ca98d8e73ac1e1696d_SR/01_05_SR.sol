// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Surreal reality
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                      //
//                                                                                                                                      //
//                         .__  .__  __                   _____                                            .__  .__                     //
//    _______   ____ _____  |  | |__|/  |_ ___.__.   _____/ ____\   ________ ________________   ____ _____  |  | |__| ______ _____      //
//    \_  __ \_/ __ \\__  \ |  | |  \   __<   |  |  /  _ \   __\   /  ___/  |  \_  __ \_  __ \_/ __ \\__  \ |  | |  |/  ___//     \     //
//     |  | \/\  ___/ / __ \|  |_|  ||  |  \___  | (  <_> )  |     \___ \|  |  /|  | \/|  | \/\  ___/ / __ \|  |_|  |\___ \|  Y Y  \    //
//     |__|    \___  >____  /____/__||__|  / ____|  \____/|__|    /____  >____/ |__|   |__|    \___  >____  /____/__/____  >__|_|  /    //
//                 \/     \/               \/                          \/                          \/     \/             \/      \/     //
//                                                                                                                                      //
//                                                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract SR is ERC721Creator {
    constructor() ERC721Creator("Surreal reality", "SR") {}
}
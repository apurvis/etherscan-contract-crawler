// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: DESMONDLIART
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                    //
//                                                                                                    //
//                                                                                                    //
//     ______  _______ _______ _______  _____  __   _ ______         _____ _______  ______ _______    //
//     |     \ |______ |______ |  |  | |     | | \  | |     \ |        |   |_____| |_____/    |       //
//     |_____/ |______ ______| |  |  | |_____| |  \_| |_____/ |_____ __|__ |     | |    \_    |       //
//                                                                                                    //
//                                                                                                    //
//                                                                                                    //
//                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////


contract DLA is ERC721Creator {
    constructor() ERC721Creator("DESMONDLIART", "DLA") {}
}
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: FACE
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////
//                                                          //
//                                                          //
//           ::::::::::   :::      ::::::::  ::::::::::     //
//          :+:        :+: :+:   :+:    :+: :+:             //
//         +:+       +:+   +:+  +:+        +:+              //
//        :#::+::# +#++:++#++: +#+        +#++:++#          //
//       +#+      +#+     +#+ +#+        +#+                //
//      #+#      #+#     #+# #+#    #+# #+#                 //
//     ###      ###     ###  ########  ##########           //
//    ### FACE BY HANNESWINDRATH.ETH ###########            //
//                                                          //
//                                                          //
//                                                          //
//                                                          //
//////////////////////////////////////////////////////////////


contract FACE is ERC721Creator {
    constructor() ERC721Creator("FACE", "FACE") {}
}
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: popoportraits
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////
//                                             //
//                                             //
//    _________          _______ _________     //
//    \__   __/|\     /|(  ____ )\__   __/     //
//       ) (   | )   ( || (    )|   ) (        //
//       | |   | |   | || (____)|   | |        //
//       | |   | |   | ||     __)   | |        //
//       | |   | |   | || (\ (      | |        //
//    ___) (___| (___) || ) \ \_____) (___     //
//    \_______/(_______)|/   \__/\_______/     //
//                                             //
//                                             //
/////////////////////////////////////////////////


contract PPP is ERC721Creator {
    constructor() ERC721Creator("popoportraits", "PPP") {}
}
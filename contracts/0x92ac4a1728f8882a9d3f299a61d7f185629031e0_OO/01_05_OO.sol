// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Occult Offerings
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////
//                                             //
//                                             //
//                                             //
//    _-_ _,,               ,,                 //
//       -/  )    _         ||     '           //
//      ~||_<    < \, -_-_  ||/\\ \\  _-_      //
//       || \\   /-|| || \\ || || || || \\     //
//       ,/--|| (( || || || || || || ||/       //
//      _--_-'   \/\\ ||-'  \\ |/ \\ \\,/      //
//     (              |/      _/               //
//                    '                        //
//                                             //
//                                             //
/////////////////////////////////////////////////


contract OO is ERC721Creator {
    constructor() ERC721Creator("Occult Offerings", "OO") {}
}
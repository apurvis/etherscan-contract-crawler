// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Nifty Runes
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                     //
//                                                                                                                                     //
//    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    //
//    //                                                                                                                         //    //
//    //                                                                                                                         //    //
//    //    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //    @@@@@@@@   [email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@o  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //    @@@@@@@       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //    @@@@@@.        @@@@@@@@@@@@@@o  °@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*  [email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //    @@@@.           @@@@@@@@@@@@°    [email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@. *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //    @@@o            [email protected]@@@@@@@@#      [email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //    @@@              *@@@@@@@*        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //    @@O         o.    [email protected]@@@#          @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //    @@.        [email protected]@#    [email protected]@*    °O     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //    @@         [email protected]@@#    *     [email protected]*     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //    @O         @@@@@O        @@@.    *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //    @°        [email protected]@@@@@@*    [email protected]@@@     [email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //    @         @@@@@@@@@@[email protected]@@@@@     #@@@@@@@@#o*°   [email protected]@@@@@@@@@@@@@@@@@@@@@@@@#OoO#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //    @        *@@@@@@@@@@@@@@@@@#     @@@@@@#.       .   #@@@@@@@@@.  @@@@@@@@*         °[email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //    @        @@@@@@@@@@@@@@@@@@O    °@@@@@°    .*[email protected]@@@  [email protected]@@@@@@@o   #@@@@@o              *@@@@@@@#  [email protected]@@@@@@@@@@@@@     //    //
//    //    @       °@@@@@@@@@@@@@@@@@@o    [email protected]@@@.   [email protected]@@@@@@@o [email protected]@@@@@@@    @@@@O    °O########o   [email protected]@@@@   °@#o°      .*@@     //    //
//    //    @o      #@@@@@@@@@@@@@@@@@@°    @@@@O  [email protected]@@@@@@@@@. [email protected]@@@@@@O   [email protected]@@o    [email protected]@@@@@@@@@@   [email protected]@@@@            .°*[email protected]     //    //
//    //    @@.    [email protected]@@@@@@@@@@@@@@@@@@     @@@@#  *@@@@@@@@@@  [email protected]@@@@@@.   *@@@.    #@@@@@@@@@@O   [email protected]@@@*      o#@@@@@@@@@@     //    //
//    //    @@@    @@@@@@@@@@@@@@@@@@@@o   °@@@@@°  @@@@@@@@@#  [email protected]@@@@@@    [email protected]@@#    @@@@@@@@@@@*   [email protected]@@@     #@@@@@@@@@@@@@     //    //
//    //    @@@#  [email protected]@@@@@@@@@@@@@@@@@@@@o  *@@@@@@°  °[email protected]@@#o    [email protected]@@@@@o    @@@@@#  .#@@@@@@@@@@#   @@@@@    @@@@@@@@@@@@@@@     //    //
//    //    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#@@@@@@@@#°       °#@@@@@@@@@     @@@@@@°     .°*oOo°.°@@@@@@@o   [email protected]@@@@@@@@@@@@@@@    //    //
//    //    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#    [email protected]@@@@@@.            [email protected]@@@@@@O  [email protected]@@@@@@@@@@@@@@@     //    //
//    //    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#    [email protected]@@@@@@@#°.  .°oo*[email protected]@@@@@@@@@° @@@@@@@@@@@@@@@@@@    //    //
//    //    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@o   [email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@O  °#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     //    //
//    //                                                                                                                         //    //
//    //                                                                                                                         //    //
//    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    //
//                                                                                                                                     //
//                                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract NRune is ERC721Creator {
    constructor() ERC721Creator("Nifty Runes", "NRune") {}
}
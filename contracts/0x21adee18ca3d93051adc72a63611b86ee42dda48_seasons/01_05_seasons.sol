// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Four Seasons
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////
//                                              //
//                                              //
//    Arjen Roos digital artist                 //
//             .     .                          //
//        ...  :``..':                          //
//         : ````.'   :''::'                    //
//       ..:..  :     .'' :                     //
//    ``.    `:    .'     :                     //
//        :    :   :        :                   //
//         :   :   :         :                  //
//         :    :   :        :                  //
//          :    :   :..''''``::.               //
//           : ...:..'     .''                  //
//           .'   .'  .::::'                    //
//          :..'''``:::::::                     //
//          '         `::::                     //
//                      `::.                    //
//                       `::                    //
//                        :::.                  //
//             ..:.:.::'`. ::'`.  . : : .       //
//           ..'      `:.: ::   :'       .:     //
//          .:        .:``:::  :       .: ::    //
//          .:    ..''     :::.'    :':    :    //
//           : .''         .:: : : '            //
//            :          .'`::                  //
//                          ::                  //
//                          ::                  //
//                          ::                  //
//                          ::                  //
//                          ::                  //
//                          ::                  //
//                                              //
//                                              //
//////////////////////////////////////////////////


contract seasons is ERC721Creator {
    constructor() ERC721Creator("Four Seasons", "seasons") {}
}
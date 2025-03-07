// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Simply put
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                         //
//                                                                                         //
//                                                                                         //
//                                                                                         //
//                                                   ,                                     //
//                             ,                     ▒▒▒n▒                                 //
//                              ,¿                  ▒▒▒▒▒▒                                 //
//                              `▒▒`               ░▒▒▒▒`                                  //
//                                ░▒─,             ,░░░                                    //
//                                 ]▒░░            ▒▒░░             ,∩,▒░▒                 //
//                :                  ▒.            ]╢░`        ,╓¿▒▒╜╙▒▒▒▒╓'               //
//               ─░": ,              ]░            ─▒░      ,─▒▒╖╓╓▒▒▒▒╜`                  //
//                `─ ▒░H¡,            ░    , ─r╖ "\ ,      ` ░─╜─`                         //
//                   `░▒▒▒▒∩,          ╓╥▒▒▒▒▒▒░░▒▒╜╓╥▒▒▒,                                 //
//                      ░▒▒▒░        ╖▒▒▒▒▒▒▒░──"""`²"╙"╙ "▒,.                             //
//                        ╙       ,─▒▒▒▒▒▒"                ╙▒╜╖▒─                          //
//                             ,╖▒▒▒▒▒▒▒                     `▒╖▒▒╖                        //
//                            ░▒▒▒▒▒▒▒╜                        ▒▒▒▒▒,                      //
//           ` ¡ ^─,         ░▒▒▒▒▒▒╜                          └░▒░▒▒,                     //
//             ─░▒░░²▒▒ .   ]▒▒▒▒▒▒                             ▒▒▒▒▒▒                     //
//               `╜▒▒░▒▒▒░  ╖▒▒▒▒░                              ░,▒¿▒▒                     //
//                    ╙░`   ▒▒▒▒▒░                             ╓▒╖▒▒▒░  ,                  //
//                          '▒▒▒▒░                            ]▒▒▒║▒░  ▒▒▒╖▒▒▒`,           //
//                           ╙╙▒▒░                           /║▒▒░▒░    ▒╜▒▒▒▒▒▒░▒▒╜H ,    //
//                            ╙▒▒▒▒                         `▒░▒ ░τ              ²`"░░░    //
//                              ╙░▒▒                     , ░▒░░▒░                          //
//                      ╖╓─▒░▒▒░░╙▒▒▒j                 ,▒╖▒▒▒▒▒╙                           //
//                , ^▒░▒░▒░▒▒▒*░    ▒▒▒▒∩─         ,╥▒░▒▒▒╖▒▒╜                             //
//              ≡``'`░░▒▒▒▒╙'         '╜▒▒▒▒▒▒,░░░▒░▒▒▒▒╙▒╜      "                         //
//                   `                    "░╜┌▒▒▒▒░╜╜░╜`        `▒▒¿                       //
//                                     '>                        ▒▒▒▒▒,                    //
//                                  ¿▒▒▒▒▒     ──                 ╙▒▒▒▒▒                   //
//                               ╓ ▒░▒▒▒▒╜     ▒░▒░                `╜▒▒▒▒▒─                //
//                             ┐▒▒▒;▒▒▒`       ▒▒▒▒`                  ╨░▒▒░▒─              //
//                          ,▒▒▒∩╓▒▒"         ]▒▒▒╙▒                   `¡░░,▒▒             //
//                          ~▒╜╜▒░`           ░▒▒▒▒▒                      ╙ ──             //
//                                            ░░,▒░░                                       //
//                                            `░:r░                                        //
//                                                                                         //
//                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////


contract SIMPL is ERC721Creator {
    constructor() ERC721Creator("Simply put", "SIMPL") {}
}
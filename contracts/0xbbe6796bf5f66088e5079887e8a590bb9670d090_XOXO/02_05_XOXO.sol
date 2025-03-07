// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: In Another Life
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                           //
//                                                                                                                           //
//                                                                                                                           //
//                                                  .:[email protected]@?+*=*:-.                                                           //
//                                            .-+*%@@@#+-.                                                                   //
//                                        .=*%@@@@#*'                         .+%#;                                          //
//                                     :+%@@@@@%:'                          ,*@@@?'                                          //
//                                  .+%@@@@@@+'                           .%@@#-                                             //
//                                .#@@@@@@@+                           :*@@@*:                                               //
//                              ,%@@@@@@@+                          .=%@@@+'               *#+,                              //
//                            :%@@@@@@@#.                         ,#@@@%"                =%@@*}                              //
//                           *@@@@@@@@+                        [email protected]@@@#'                #%@@*'                                //
//                         :%@@@@@@@@-                      :[email protected]@@@@*:                ;%@@*"                                  //
//                        [email protected]@@@@@@@@*                    .*%@@@@@+'                #%@@*'                                    //
//                       *@@@@@@@@@-                .:*#@@@@@@@*                 [email protected]@@?"                                      //
//                      *@@@@@@@@@+           .=*{@%@@@@@@@@@+                 [email protected]@@*'               *%.                      //
//                     [email protected]@@@@@@@@%        .=#@@@@@@@@@@@@@@#.               [email protected]@@*.               :#@@?                      //
//                    ,@@@@@@@@@@=      .*@@@@@@@@@@@@@@@@?               .*@@@*'                *@@%'                       //
//                    @@@@@@@@@@@      *@@@@@@@@@@@@@@@@@:              :#@@@#:                *%@@=                         //
//                   [email protected]@@@@@@@@@#     [email protected]@@@@@@@@@@@@@@@@:             <@@@#:'                .#@@#"                          //
//                   @@@@@@@@@@@+     :@@@@@@@@@@@@@@@@?           [email protected]@@@%"                 [email protected]@@=                            //
//                  [email protected]@@@@@@@@@@?      %@@@@@@@@@@@@@#'          *%@@@@%"                 *@@@#'                             //
//                  [email protected]@@@@@@@@@@+      '{@@@@@@@@@@*:         :*@@@@@@=                 ,%@@@=                               //
//                  #@@@@@@@@@@@*        "&[email protected]@@*+"        .;$%@@@@@@*^                .#@@@#?            .                   //
//                  #@@@@@@@@@@@@                    .;$?*@@@@@@@@%:                :*@@@@}'             *                   //
//                  #@@@@@@@@@@@@-                *$#@@@@@@@@@@@@+                :#@@@@#'               #                   //
//                  *@@@@@@@@@@@@#             .*@@@@@@@@@@@@@@@=               :#@@@@@+                :@                   //
//                  [email protected]@@@@@@@@@@@@}           *@@@@@@@@@@@@@@@@=              =%@@@@@@-                 *#                   //
//                  [email protected]@@@@@@@@@@@@@.        .{@@@@@@@@@@@@@@@@*           :=#@@@@@@@@:                 [email protected]?                   //
//                   #@@@@@@@@@@@@@%.       [email protected]@@@@@@@@@@@@@@@}        .=*@@@@@@@@@@%.                 [email protected]@                    //
//                   :@@@@@@@@@@@@@@}.      *@@@@@@@@@@@@@@@#       *{@@@@@@@@@@@@@:                 %@@+                    //
//                    *@@@@@@@@@@@@@@@-     .%@@@@@@@@@@@@@=      .#@@@@@@@@@@@@@@*                 [email protected]@%                     //
//                     %@@@@@@@@@@@@@@@+     ^*@@@@@@@@@@#"      [email protected]@@@@@@@@@@@@@@@:               .#@@@:                     //
//                     .%@@@@@@@@@@@@@@@%:     '<[email protected]@$$:'        [email protected]@@@@@@@@@@@@@@*               [email protected]@@@'                      //
//                      .{@@@@@@@@@@@@@@@@#:                     *@@@@@@@@@@@@@@#              [email protected]@@@@?                       //
//                       .%@@@@@@@@@@@@@@@@@#-                   [email protected]@@@@@@@@@@@@=            .*%@@@@@'                        //
//                         *@@@@@@@@@@@@@@@@@@@+.                 .*@@@@@@@@%*'           .*@@@@@@%:                         //
//                          '@@@@@@@@@@@@@@@@@@@@%+:                ':[email protected]@#:"           ,*@@@@@@@@+                           //
//                           .*@@@@@@@@@@@@@@@@@@@@@@#+:.                         .*%#@@@@@@@@@%:                            //
//                             :#@@@@@@@@@@@@@@@@@@@@@@@@@$*=:..           .:$*%@@@@@@@@@@@@@%*                              //
//                               :#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%-                                //
//                                 [email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*:                                  //
//                                    '*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@}=                                     //
//                                       :+%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*'                                        //
//                                           '+#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#+#"                                           //
//                                                *:+*#%@@@@@@@@@@@@@@%%*+=?:'                                               //
//                                                      '":{?*:@@@:*?."'                                                     //
//                                                                                                                           //
//                                                                                      In Another Life by Chelsea Mealo     //
//                                                                                                                           //
//                                                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract XOXO is ERC721Creator {
    constructor() ERC721Creator("In Another Life", "XOXO") {}
}
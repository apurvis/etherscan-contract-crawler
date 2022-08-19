// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: R0LL adorable drones
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                             //
//                                                                                                             //
//                                                                                                             //
//                                          ,≡ô""""=≥╓,                                                        //
//                                         ╙▓▓▄▄╥,,'    ╙7≥╓,                                                  //
//                                           ╙▀▀███▓▓▓▄╥,    └7≥,                                              //
//                                                 └╙╙▀███▓▄▄,'  ^ª╓                                           //
//                                                        ╙▀▓█▓▓▄,  └%,                                        //
//                                                            └╙▀█▓▄,  7╦                                      //
//                                                                ╙▀█▓Q  ╙╦                                    //
//              ,╓≥=░""└└└└     └└└└""²≈≡╓,                 ,,,,,,,,, └╝▄  ╙,                                  //
//           ≡Γ                            └"7≥╓  ,╓≡=░Γ╙╙╙╙╙╙╙╧≥╧▄▄░╙╙╙▀▀≥≥╬╦                                 //
//         ╔╙ ' ,,,╓╥▄▄▄▄▄▄▄▄▄▄╥╓,, '            ╙%╦,,,  ''        ' └╙7ª╦╓  ' └"ª≡,                           //
//        ▐╗▓▓▓▓████████████████████▓▓▓▄▄,          └╙╩░└╙╙"7ª≥╖╓,'        └▒╗▄▄▄▄▄▄▒░≥,                       //
//           └╙╙╙╙└└─            └└╙╙▀▓▓███▓▄▄,         ╙≥,      └╙7≥╦, ╓#╙╙ └░░░░░░░╙╙╙▀φ╓                    //
//                                 ,∩└ ,╓▄╣████▓▓▄,   ',é╙'           ▄▀░░  ≤▒╠╠╬╬╬╠╠▒▒▒░, ╙è╦                 //
//                               ╓░,╓▄▓████████████▓▄╓╩.            ]▓░░╠╠▒╠╩╠╬╬╩╙░╚╠╬▒░▒▒▒░, ╙#╓              //
//                             ╓▒▄▓██████████▀▀╙╙╙└└└               ╫▌░▒╠▒Γ  '"  7╠▒░╩╬╬▒╠╬▒░∩  └Φ,            //
//                           ,╬▓██████▀▀╙└                         :█▌░╠╬╬⌐     ¡≥╦▄╣▓▓▓▓▓╬╬╦,;░░░╠▄           //
//                          ▄▓████▀╙.'                              ▓█'╚╠╬▒~    ]╠╠╩╚╣▓▓╬╬╬╬╬▓▓▒╠▒░╚▒          //
//                        ,▓███▀└                                   ╚█▓'╚╬╬▒░.  :▒╬▒░╟╣▓╬╣██╬╬▓▓▓▒▒ ╟╦         //
//                       ,███╙│                                     '╚██µ╚╬╣▓▒▒░,╠╬╬╬▒╚╢╣▓╬╬╬╣╬╣█▓╬░╠▒≥        //
//                      ]██╩░░░                                      '╙██▌░╠╣▓▓▓▓╬╬╬▒,░╠╣▓▓███████╬▒╫⌐^╦       //
//                      █▓│░░░░                                        '╙██▓▒▒╟▓▓╬╬╬╬╬╬╣╣▓▓██████▓╬▓╩']▓⌐      //
//                     ╫▌░░░░░░                                          '╙▀███▓▄░╙╩╣╣╣╣▓▓▓▓▓▓▓╬╬╟▓▒':▓░╠      //
//                    ]▌░░░░░░░                                             '╙╙▀███▓▓▄▄▄▄╓╓▄▄▄▓▓▀╙ ╙G  ,▓▒     //
//                    ╟░░░░░░░░                                                 '└┘╙╙▀▀▀▀▀▀▀╙╬└     ╠  ╣▒╠     //
//                    ▒░░░░░░░░                                                              ╙░ .▓▄ j▒   ]     //
//                   ]▒░░░░░░░░░                                                              ╠ ]███▄╠   ]░    //
//                   ]░░░░░░░░░░                                                       ',╓▄µ  ⌠░║████▓⌐  ]░    //
//                  ╔╣▒░░░░░░░░░░                                                   ,▄▄▓██▓Γ   ╠▓████▓░  ]⌐    //
//                 ╬▓█▒░░░░░░░░░░░                                              ╓▄▓███▀▀└ ,,   ║██████░  ▐     //
//                ╠╫██▓░░░░░░░░░░░░                                            "▀▀▀╙└ ,▄▄███░  ▐██████░  ╠     //
//               ▐╠████▒░░░░░░░░░░░░                                             ,▄▄▓███▀╙└    ▐█████▓⌐ ]      //
//               ▐╟████▓░░░░░░░░░░░░░                                           ╣██▀▀╙└        ▐█████╬ .╩      //
//               ▐╟█████▒░░░░░░░░░░░░░░                                                        ║████▓▒.╠       //
//               └▒▓█████▒░░░░░░░░░░░░░░░                                                      ▓███╬╬░#        //
//                ║╟██████▄░░░░░░░░░░░░░░░░                                                   ]█▓╠╙▐░#         //
//                 ╠╫██████▒░░░░░░░░░░░░░░░░░,                                               .╠╙│░▐▒╩          //
//                  ╠╢██████▓░░░░░░░░░░░░░░░░░░░,                                            @░░░╔╬╙           //
//                   ╙╬███████▄░░░░░░░░░░░░░░░░░░░░;                                      ;░@░░░å╩╠            //
//                     ╚╣███████▄░░░░░░░░░░░░░░░░░░░░░░░;                            ,;░░░░▐╙│]╬│░╩            //
//                       ╚╬▓██████▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░;;,.        .,,;;░░░░░░░░│░#└,ê╬│░#             //
//                         └╙╬▓█████▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│└',▒≡"╓╬╓ê╙              //
//                              └╙╙╙╙╙╙%░░░│││││░░░░░░░░░░░░░░░░│└└''''''││░░░░░░░│└'',≤╙   ╙└                 //
//                                        "≡░'''''''│││░░░░░░│└'''       '''└;╓µ└';≡≈"  ....                   //
//                                            "≈≡,, '''''''''''        ,╔▒╙╙╙░╠≥"`       '''                   //
//                                                  ""≈≈≤≡╓╓,,,,╓▄▄╗▒░░Φ╙┌¡¡;╙                                 //
//                                                                  ,#╙ .¡;╩                                   //
//                                                                ^╩╧≈≈≈"╙                                     //
//                                                                                                             //
//                                                                                                             //
//                                                                                                             //
//                                                                                                             //
//                                                                                                             //
//                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract R0LL is ERC721Creator {
    constructor() ERC721Creator("R0LL adorable drones", "R0LL") {}
}
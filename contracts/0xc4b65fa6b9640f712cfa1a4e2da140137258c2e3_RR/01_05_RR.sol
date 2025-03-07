// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Rinna's Reveries
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//        ████████████████████▓████████████████████▓███████████ ║█████████████████▓██╣██╬█    //
//        ████████████████████████████████████████████████████╙ ╟████████████████▓█▓██████    //
//        ██████████████████████████████████▓████████████████╙  ██████████╣███████▓█╣█╫██╢    //
//        █████████████████████████████████████████████████▀   ╣█╬▐███████╣████▒██▓█╣█╫██╣    //
//        █████████████████████████████████▓▓████████████▀   ╔███╦▓█▒█████████████▓██████╫    //
//        █████████████████╬╬█▓██████▓╬╬█▓╫▓████▓╣██▀╨`      ╣██▒███╢████▓████▓████▓██████    //
//        █████████████████████╬▓▓▓█╬▓▓▓╬╬▓▓╩╟███▀          ╠██╠╣▌  ▐▓▓▓███████╬███▓▓███╣█    //
//        █████████▓▓▓█▓███████████▓███╬╬╠▓██╟▓▓,          ╒█▓▓▓╩  ,╢█╣███▓▓██╝▓██▓█▓██▓██    //
//        █████╫▓▓╫▓██████████▓╬╬╬╩▓╠╣╝╠▄╣╬╩╙╙▀▀▀▀█╥      ,▓▓██╙╓▄▓▓╬╬╬▓╬╬╢╩╟▀╓██╬█▓██▓███    //
//        ██▓╬╬╬╬▓╬╬▓▓╬▓╬╬████▀█▓▄████▓▓▀═▄       ,,     ╔╣█╩`é╬╩`▄╬▓╗╝╬███▀█▓█╬█╬█╬╬█████    //
//        ██▓▓███▓█╫╬╢╬▓▓╬█▌ ╬╣█▀███▀██▓███▄▀╗    ╚▓▓▓▓▓▓▓╩   ╬  ╟▓████████▀▀─╠ ║▒╙▓██████    //
//        █████╬╬▓╬▓██b└╣╬█▒ ╞▐╬█╬█▌└└└╙███▀▀▀█▌   ,▄╬╬╬╨       ▓███▀╙─ ▐▓▌ █╙╬m  ╦╚██████    //
//        █████╬██████▓  ⌐╠⌐ ╞  ╬███▓,╓▓▓▓▓,,     ╙╙╙          ╙╙╙▓▓▓µ ▓▓▌▄▀╬ ╙▒   %╠█████    //
//        █████████████Γ  ║  ║  ╩▒▀─█╙█└▌╚.   ╙                 "╙└╙█╙█▀▌▀⌐╙▌═  Q   ╙╣████    //
//        ▓████▓███╬███▌  ▒  ▌   ╣ ╙▄                               ╓╗Q'│;Q'║╕   µ   └████    //
//        ███████╬██▓█╬█  ∩ ]   ]▒⌐ ╚▒                        b    ║╬╬╬▒╣╬╬▓║ ⌐  ╙    ║███    //
//        ██▓██╬█████▓█╬▌▐  ▐   ]⌐b  ╞                       ▓     ║╬╬╬╬╬╬╬▒╛,    ⌐   ╣███    //
//        █▓██▓█████▓█╬█▓▌  ║    ▒▌  ▐                     ▄▀      ▐╬╬╬╬╬╩░╩╒`   ▐   ]████    //
//        ╢█▓████▓█╬████▓╠  ╘    ║╠   ▒                  .... ╓    j╬╬╬╩└.╩]`    Γ   ╣████    //
//        █▒████▒████████╣   b    ╣    ╕             z█▌,▄▓█▀▀╙    ]╩`  ╓╜ ╜    ▐   ]█████    //
//        ▓█████╬████████▒µ  ╠    ╚µ   └            .░░│││░╙ ;▄        Θ ,╜     ╛   ╟█████    //
//        ▓████████╢██╬██▌▒  ▐     ▒    ╚          ╙▀▄▄░░≥▒▄▓▀       ╔╜╓Θ      ^   ╔██████    //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract RR is ERC721Creator {
    constructor() ERC721Creator("Rinna's Reveries", "RR") {}
}
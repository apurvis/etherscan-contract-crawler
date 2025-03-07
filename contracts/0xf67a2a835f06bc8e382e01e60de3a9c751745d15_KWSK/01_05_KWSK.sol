// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Kwame's Sketchbook
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//           _: _'_ _  _   _     _         _  _  _      _     _ ___   ....   __          └    //
//           ___'  _ _ _ _    __    _  _  __ _           _  _   ___,╓µ╓╖╦µ╓,__ _.     _ _`    //
//                _  _     _      _           _  _  _  _____ _╓φ▒╣╬▓▓▓╬╬╬╬▓╣▓╬▓╗ç_ _  _ _     //
//            _   _ _ _ⁿ░". _   _   _ _                   _╓@╬╫╬▓▓╬╣╬█╬╬╬▓╬▌█╣╫▓▓╬▒╖_`  _     //
//            _ _ ___,∩__░∩7_  _     _ ___ _ _  _     _ _╓╣╣╣▓╬╬▓▓╬▓╬╬╬╬╣╬╬╬╣╬╬▓╬▓▓╬╣▄_\      //
//           __ __   ∩ _ _░∩['  _ __   _     _         [email protected]╬╣╫▓╬▓╬╬╫╫▓╬╬█╬╬╬█╬╬╬╬╬█▓╣╬╣╬▓_`     //
//             _ ___ _  __]¼░_ _ __ _     _ _ _   _   _╬╬▓▀╫▌▓╬╬▓╬╬╬╬▓█╬╬╬█╬╣▓╬▓╬▓╬╬╬▓╬╬⌐'    //
//                _ ^/_  _`░░_   _ _ _ _    _ __     [email protected]╬╬╬╬╬╬╬╬╬╬▓╬╬╬╬█╬╬▓▓╬╬╬▓▓╬╬╬╬╬▓╣╬▓_    //
//             _  _   _ __.░;._  ._ _  _   ___ _ __  _╬╬╬╬╬╬╬╬▓▓▓╬╬▓╣╬╬▓╣▓▓▓▓╬╬╬╬╣╬▓╬╬╬╬╬▒    //
//            __    _└   _φ░⌐___     _  _  `,.  __ _╬╬╬▓╬╬╬█╬╬╬╬╬╬╬╣█╠╠█╬╬╬╬╬▓▓▓╬╬╬╬╬╬╬▒      //
//                _ __"=«░░"½µ .";⌂,__  _,?'≈/,_ _ _╟╬╬▓▓╬╬╬▓▓▓█▓╬╬╬█▓▓╬╬╬╬▓╣╬╬╬╬╬╬▓▓╬╬⌐      //
//             _     __,-╓≡-╟▓▓▒▒ƒ,╓▄▄╗╦╦╓,µ▒╬▒╠▒__   └╬╬╬▓╬╬╬╬▓╬╬╬╬▓█▒╬╬▓▓╬╬╬╬╬▓╬╬╬╫▓▓╬╬_    //
//            ___   _  <░≥= ▐▓▓▓▓▓╣╫╬╬╬╬╠╠╬╙╝╬╬╬▒_  __ ╙╬╬╬▓▓╬▓╬╬▓▓╬╬▓╬╬╬╣╬╬╬▓▓▓╬╬╬╬╬▓╬╣_/    //
//            _ _  _ _'_»φ _;▓▓▓╬╣╬╬╬╣╣╣▄╠╬╣▒╠▓╬░_`_  _ └╣╬╬▓▓╬╬╬╬╬╬╬╫▒╬╬█╬╬╬╬╬╬╬╬▓╫▓╬╩_'     //
//            ___ _   __φ░=_C╙█▓╬╬╣▓▓╬▒╠╠╬▓▒╠╬▓▌_⌐^  \_   ╙╣╬╬▓█╫╬╬╬╬╬▓▓▓╬╬╬╬╬╬╬▓▓╬╬╝└        //
//           __ _   _  └,];⌡`√▓▓╬▓█▓▓╬╬╠░╟╬╠▓╠╬▌=./~-^   _  ╙╚╬╣╬▓▓▓█╬▓▓╬╬▓▓█▓╬╬╬╬╨`_~_ _     //
//          _ ___   _   _7_░__▓╬╣███▓╬▒░╚╬╩╬╣▓╩╬=_▐          _ └╙╙╝╬╬╬╬╬╬╬╬╬╬╩╨╙_    _  _     //
//           _ _ __    ,_░⌐\_║▓╣▓╣╢╬╩╙▀╩__'░╠▓╬╠▒,___,`  __      ___  _____  __  _ _ __ ∩-    //
//           _     _    ,▓▒ ²▓▒▓▓▓╬╣▒φ╬▒≥∩,φ╫▓▓▒╬_.'«>Γ_ _   _ ____         _      __   "'    //
//           __    _   _{╬▒Γ_▓╬▓▓╣▓╬╬╬╬╬╟╠╩╬▌▓▓╠╣/^∩-__ _  __        ___ __ _ ____    ___     //
//                  __.,α▓▒,»╝▓▓╣▓▓╣╬╬▒░░░▒╣▓▓╠╬╬∩=░"≈≤_  _      ___         _   _ __  _      //
//             _  __^_ ╚,╬▒_.╬▓▓╬╬╬╣▓▓╣▓╬▓╣╬╬╬╬╠╬▒,░░≤²_ _        _    _        _    _  _     //
//            __  _ ,  -⌐╟▒▄▓▓▓▓▓▓▓╬╣▓╬╬╬╣╬╠▓▓▓▒╣╬▒▒[.__ _  __       _ __ __   _   __ _       //
//           _     ._/,,╗╢╣▓▓▓▓╬╬╣▓▓╬▒╩╬░▒╢╬╬╬╬▀╬╣╠╩╩∩⌐ __ _ _    _  _  _ _         _   _     //
//        _     _   _⌐≥╬╬▒▒╣╣╬▓▓╬▓▓▓╬╬╬╩╠╠╠╠╫╬▓▓▓▓╬╣▄▄⌐  _ _ _           _           ___      //
//          _  __ ___ _╟▓╠╬╬╬╫█▓╣╫▓▓╬╬╬▒╠╠╠╠╠╚╣▓█▓╬╬╩╬_ _  _            __ __         __      //
//              _     ;░╫╣▓▓╬▓█▓╬╬╬╬╬▓╬╬╬╬╠╠╬░╠╣▓▓▒╬▒▒M"░  _             _     _ _ _  ___     //
//        _         __\Φ╣▓╣▓▓██▓╬╬╬▓▓▓▓╬╬╬╣╬▒▒╠╣▓▓╬╬╬╚≥░`,φ_ __ __ _  __  _     __            //
//                 _   ░╣╫╣▓▌╣▓▓▓▓╬▓▓▓▓╬╣╣╬╬╬╣▒╟╬▓╬▒░╬░⌐=▒▒_            _    __ _  __         //
//        _   ___     .*║╣╣▓▓▓▓▓▓▓▓▓▓╬╬╬╬╟╬╬╣╬╬╬╬╠╬╣▓▌▒░▒╩ '    ___ _ _    _        _ _ _     //
//        _     _  __  _j╬╬▓█▓▓▓▓╬▓▓▓▓▓╬╣╬╬╬╬╬╠▒╠╠╬▓█╬╠╣┘  _,^`    _   _     _____    _ __    //
//        _      __ __  ~╬▓▓▓▓▓▓▓╬╣▓▓▓▓╬╣╬╬╬╬▒╠╫▒░╙╚╬╠▓,,φ▒▒▒δ⌐ _ _       __    __ _          //
//        _   __     _ ' ╣▓▓▓▓▓▓╬▓╣╬╬╣╫╣╬╢╬▒╬╨╬░╚░∩'░╣▓φ▒╩╙/ `_       _ _    __ ___  _   _    //
//        _    __ _ __ '.╬▓╫▓▓▓╬╩╚╙▀║▓╫╬╣╬▓▒╬░░░░░░!░╠╬╟╬╚  .___  _ _      _ _ ____  _ ___    //
//        _   _  __  ,^ ▐╬▓╬╣▓╬╬░░░░░╠╣▓▓▓▓╬╬▒▒φ░φ_"░╠▒╣Γ_,<░;φ≥⌐ _       _   _       __      //
//        _  _ _______ _╙╢▓╣▓▓╬╣╬▒▒░╠╣▓▓▓▓▓╬▓╣╣╬▒▒φφ▒╬▒╣φ░φ╩╙_._^_ _____    _     ____   _    //
//        _   _      `ε  .╫╫▓▓▓▓╬╬╬╬╣▓▓▓▓╬╣▓▓▓▓▓╣╣╬╬╣╬╣╬▒╣╜__      _  __  _ _  _ _            //
//        _      _ _ _,"_.╟░╝╬▓▓╬╣▓╩.__╙╣╬╬╣▓▓▓▓▓▓▓▓╬▓╬╣╣╜_ _     _  _ _ ___  __     _   _    //
//        _   _  _ __ \__└╟░ⁿ_╠▓▓▓▒_ _ ^_╙╟╣╬╣▓▓▓╣╬╣╬╣╝╩_____    __ _    _        _ _         //
//        ⌐ __ _ __ _ __``║░φ_╣╫╫▓┐   '_"≡__└╚╚╬╬▒╠╙░-,__  _ _ __ _ _   __     _ _  _ ___     //
//        ⌐ ∩ _ ___ _  _ φ║▄▄▓▓╬░▒7:      `ⁿ-=^╟╬▒▒║▒▒,∩ _     _ _  _    ____ __ _  ___       //
//        ⌐ __ _      _ _ ╚▀▀▀▀╜╜`___  __  _   └╙╙╙╙╙╙ ___ _   _ _         ____   ____ _      //
//        ⌐  __ _   ___ _ ___` ___    _ _   __ ________     __ _     _    __ ___  _ __  _     //
//        ε   _ _     _ _  _ ^      _ _ __   _  _____         __ _  _     _  _ __ _____       //
//        ⌐  _  _  ___   __ __  __ __      _ _      __   _  __     _ _ _  _  ___ _   _ _      //
//        ░                    _    __ __ _  _    _ __  _ _  __ _  __ _ _ _ __  _       _     //
//        ░       _   _    _   __   ___ _   _ ___   ______  _  _   _    _         _      _    //
//        ░  __   _    __    _     ___   _ _ _     _  __  _ _   _ __   _     _    _   _       //
//        ░   _  _ _  _       _   _   _ __    _    __  __   _  _     _      _  __ ____        //
//        ░    _ _     _  _ _ _           _   _    _   _               _      __        _     //
//        ░  __    ___           _ _ __ _     _   __    _  _           _  _       _ _ _       //
//        ░ _  _ ~_             __ _ _  _ _    _     _ _  _ _    _  __   _           _        //
//        ░    _ __ _    _  _  _ __     _  _    _   _    _   _     _  ____  _  _       _      //
//        ▒             _       _  _   __   _    _          _      _ _    __   .≤░░░≥∩___     //
//        ▒_      __ _       _  _              __ ____    _ _  _ _      _ _    ░░░░░░░░___    //
//        ░        __   _ _     _ _    _ _    _       _ _          ___  __ ____░░░░░░░░_'     //
//        ▒   __    _   _ _ _   _ _   ___   _  _  __       _  __  _ __ _  __  _;░░░░░░∩."_    //
//        ░ __ _  _ ___  ___    _ _        _ _ _ _     _    _   _           _   _!░░⌐___.,    //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract KWSK is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
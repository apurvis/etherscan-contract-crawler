// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: NIGHTSHIFT
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//        ░░░░░░░░░░░░░░:::,`'.      ╬#▓████████████████████████████▓▓▀░`   ```,,`.,.`,,      //
//        ░░░░░░░░░░░░░░::::``      =╧▓█▓█████████████████████████████▀           .,'─, .,    //
//        ░░░░░░░░░░░░::::,,         ¢⌠▄████████████████████▀████████▓╦.⌐            . ` ,    //
//        ░░░░░░░░░░::::,``'.      ^══▀▓████▌▒▒╢███▓███████▓▒╣████████Ç             `..``,    //
//        ░░░░░░:::::::,,`  `          Ü▀▓█▓▒╣▒▓▓▓▒╣▒▓█▌▓█▒▓▀╣████████▀╜"            ...,:    //
//        :::::::::,:,,` ```           "Ü ╩/╬▒▓▌╣╬▌▀▒╣▒╣▌╣╣╣▌▓▓█▓▓▓▓▀┘╙░          ..`.,,,,    //
//        ::::,,,:,,` .'`                     ╚╣▒▒▌▒╣╣╣╣╣╣╣╣Ñ╣╣▓╣╣╣╣▄▓▓░─.      . `,,.,,,:    //
//        ,,,,`,,:````                         ▒╣╣╣╣╣╣╣╣╣╣╣╣M╣╣╣╣╣▓██▓▓▌,▄░....,,,,,,,,,,,    //
//        ,`.` ▄  ▄  ▄ ▄▄▄ ▄ ▄ ▄▄▄ ▄  ▄  ▄     ╬╬▒╣╣╣╣╣╣╣╣╣╣╬╣╣╫▓██████▓▓▄,─░:,,,,,,,,::::    //
//        ,`  █▐▄ █▀▄█ █  ▌█▄█ ▌ ▐ █▄▄█ ▐▀█       ╙╝▒▒╣╣╣╣▒▌╣╣▓███████▓██▓▓,"░░░:::░:::░░░    //
//        ,` ▐▀▀▐ █ ▐█ █▄▀  █  ▀▄▀ █  █ ▌▀▀▌        .╙▒╣▒╩██▓███████████████▓,└░░░░░░░░░░░    //
//        ,,,,....... ...                             ╙╙╬████████████████████▓ò░░░░░░░░░░░    //
//        ::::::,:,,,:,,,.........               ....░╓▓███████████████████████▌░░░░░░░░░░    //
//        ░░░░░░░░░░░:░::::::::,,,,,,,,,,,,,,,,,,,,:░▓██████████████████████████▓w╙░░░░░░░    //
//        ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓█▓██████████████████████████@,*░░░░░    //
//        ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒Ü██▓███████████████████████▓██▄W ░░░░    //
//        ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▄▓██████████████████████████████▓▄]▒░░    //
//        ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░Å▄██████████████████████████████████k▒▒▒    //
//        ░░░░░░░░░░░░░░░░▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓██▌█████████████████████████████████╢▒▒    //
//        ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓██▓▓█████████████████████████████████▌▒▒    //
//        ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓███▓███████████████████████████████████]▒    //
//        ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓██▓███████████████████████████████████▌╞▒    //
//        ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓██▓███████████████████████████████████▓▌║▒    //
//        ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓██▓████████████████████████████████████▓M╢▒    //
//        ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓██▓████████████████████████████████████▓ ╣╣    //
//        ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓█▓██████████████████████████████████████▄▌╣    //
//        ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓█████████████████████████████████████████▓▌╣    //
//        ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓███████████████████████████████████████▓█▓╣▒    //
//        ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▌▒▒▀█▓▌▌╣▒▒▒▒▒▒▒▒▒▓████████████████████████████████████████▓▓╢▒▒    //
//        ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌▓▄████▓▓▓▒▒▒▒▒▒▒▌▓█████████████████████████████████████████▓▓▌▒▒    //
//        ▒▒▒▒▒▒▒▒▒▒▒▒▒▓████████▓▓▓▓▓╬╢▒▒▒▓█▓████████████████████████████████████████▓▓▒▒▒    //
//        ▒▒▒▒▒▒▒▒▒▒▒▒▓███▓▓▓▓▓▓▓▓▓▓▓▌████▓▓▓████████████████████████████████████████▒╣▒▒▒    //
//        ▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓████▓▓▓▓▓▓▓████████▓████████████████████████████████████████▐▒▒▒▒    //
//        ▒▒▒▒▒▒▒▒▒▒╫▒██▓████▓▓▓▓▓▓▓██████████████████████████████████▓██████████████▓▒▒▒▒    //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract NITE is ERC721Creator {
    constructor() ERC721Creator("NIGHTSHIFT", "NITE") {}
}
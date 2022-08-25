// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: MAX CAPACITY + HAPPY GOAT
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//        ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//        ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//        ░░▒░░░░░░░░░░░░░░░░░▒███████████░░░░░░░░░░░░░░░░███████████▒░░░░░░░░░░░░░░░░░░░░    //
//        ░░░░░░░░░░░░░░░░░░▒██▓▓▓▓▓▓▌╩╝╪▐██▒░░░░░░░░░░░██▌╪╨╪▐▓▓▓▓▓▓██░░░░░░░░░░░░░░░▒░░░    //
//        ░░░░░░░░░░░░░░░▐█████████████▌▒░¢Å██░░░░░░░▒██NI▒▒▒█████████████▌░░░░░░░░░░░░░░░    //
//        ░▒░░░░░░░░░░░░░⌠▀▀▀▀▀▀▀▀▀████▌▓╣▒▒██▒░░░░░░▒██▒▒▒▓▐████┤┤╞▀▀▀▀▀▀├░░░░░░░░░░░░░░░    //
//        ░░░░░░░░░░░░░░░░░░░░░░░░░░░██▌╢▌▒▒▀▀██▌░░░██▀▀▒▒▒╢▐█▌░▒░▒░░░░░░░░░░░░░░░░░░░░░░░    //
//        ░░░▒░░░░░!!!!!!¡░░░░░░░░░░░██▌╢╣▒▒▒▒██▌!!▒██▒▒▒▒╫╢▐█▌░░░▒░░░░░░░░!!!;;;░░░░░░░░░    //
//        ░░░░░░░░▐███████╖╖╖╖⌠≡⌡░░░▒██▌▄▄▄▄▄▄████████▄▄▄▄▄▄▐█▌░░░░▄▄▄▄▄▄▄███████▌░░░░░░░░    //
//        ░░░░░░░░▐██▒▒▒▒▐███████▄▄▄▄███████████Ñ╨╨╨███████████▄▄▄▄███████▌▒▒▒▒██▌░░░░░░░░    //
//        ░░░░░░░░▐██▓▓▄██▄▄▄▄▄▒▒██▀▀▀▀▀_____________________▀▀▀▀██▒▒▄▄▄▄▄▄█▄▓▓██▒░░░░░░░░    //
//        ░░░░░░░░ⁿ▀▀███▀▀▀▀▀▀▀▓╥██▌╙__╓▄▄▄▄____________▄▄▄▄▄__╙╙██▓▓▀▀▀▀▀▀▀███▀▀▒░░░░░░░░    //
//        ░░░░░░░░░░░▀▀███╢╢╢╢╢████∩___╙▀▀▀▀____________▀▀▀▀▀____████╢╢╢╢╢▐██▀▀░░░░░░░░░░░    //
//        ░░░░░░░░░░░░░╨▀▀███╣╣██▀▀____▄████____________▄███▄____▀▀██╢╢███▌▀▀░░░░░░░░░░░░░    //
//        ░░░░░░░░░░░░░░░░▀▀▀████▌▒__▐█▌▀▐██____________██▌▀▐█▌__▒▒████▀▀▀⌡░░░░░░░░░░░░░░░    //
//        ░░░░░░░▒░░░░░░░░░░░░░██▌▒__▐██▄▄██____________███▄▄█▌__▒▒██|⌡░░░░░░░░░░░░░░░░░░░    //
//        ░░░░░░░░░░░░░░░░░░░░░██▒▒____█████____________█████____▒▒██░░░░░░░░░░░░░░░░░░░░░    //
//        ░░░░░▒░░░░░░░░░░░░▒██▀▀`╙____╚▀▀▀▀____▄██▄____▀▀▀▀▀____""▀▀██░░░░░░░░░░░░░░░░░░░    //
//        ░░░░░░░░░░░░░░░░░░▒██▒╢╦╦▓▓▓▓Γ______████████_______▓▓▓▓╦╦▒▒██░░░░░░░░░░░░░░▒░░░░    //
//        ░░░░░░░░░░░░░░░░░░░▀▀██▌▀▒▒╜"___█▄__▀▀▀███▀▀__▄█µ__"╙▒▒▀▀██▀▀░░░░░░░░░░▒░░░░▒░░░    //
//        ░░░░░░░░░░░░░░░░░░▒░░▀▀▄▄▒▒╖╓___█▀▄▄▄▄▄███▄▄▄▄▀▀Γ__╓╓▒▒▄▄▀▀▒░░░░░░░░░░░░░░▒░░░░░    //
//        ░░░░░░░░░▒░░░░░░░░░░░░░▀▀█▄▄▄▄╖┐__▀▀████████▀▀__╓╥╥▄▄▄█▀▀░░░▒░░░░░░░░░░░░░░░░░░░    //
//        ░░░░░░░░░░░░░░░░░░░░░░░▄█▀▀▀▀█▄▄╖╓__██▌▒▓▓██__╓╖▄▄█▀▀▀▀▄▄░░░░░░░░░░░░░░░░░░▒░░░░    //
//        ░░░░░░▒░░░░░░░░░░░░░░██▀▀╙╙║▒███▒▒╗╗██▌▓▓▓██╗╗╢▒███▒╣╙╙▀▀██░░░░░░░▒░░░░░░░░░░░░░    //
//        ░░░░░░░░░░░░░░░░░░▒██▀▀______]▀▐██▓▓▒╘████▀▀▓▓██▌▀▀______▀▐██░░░░░░░░░░░░▒░▒░░░░    //
//        ░░░░░░░░░░░░░░░░░░▒██▒[______╘╝▐██╢╢▓▓╣▒▒▒▓▓╢╢██▌╝╛________██░░░░▒░░░░░░░░░░░░░░    //
//        ░░░░░░░░░░░░░░░░░░▒██▒[_________██▄▄▒╢╢╢╢╢╢╢▄▄██▌__________██░░░░▄⌡░░░░░░░▒░░░░░    //
//        ░░░░░░░░░░░░░░░░░░▒██▒[___________██▄▄Ñ╢╢╢▄▄██_____________██▒j▄███▄▄░░░░░░░░░░░    //
//        ░░░░░░░░░░░░░░░░░░▒██▒[_____________▀▀█▄▄▄▀▀_______________██▄▄▀▀__██░░░░░░░░░░░    //
//        ░░░░░░░░░░░░░░░░░░▒██▒[_______________▀▀▀▀_________________██▀▀____██▒░░░░░░░░░░    //
//        ░░░░░░░░░░░░░░░░░░▒██▒[____________________________________██____╓▐██░▒░░░░░░░░░    //
//        ░░░░░░░░░░░░░░░░░░▒██▒╢╗,╓g▒@▐█▌____██µ,,╓██____▐██╗▒gg╓,__██╗,,▐██▀▀░░░░░░░░░░░    //
//        ░░▒░░░░░░░░░░░░░░░▒██▒▒▒▒███████____███▄▄███____▐██▄███▒▒__██▄▄█▌▀▀░░░░░░░░░░░░░    //
//        ░░░▒░░░░░░░░░░░░░░░██▒▒▒▒██▌▀██▌____██▌▀▀▀██____▐██▀███▒▒╓╓██▀▀▀I░░░░░░░░░░░░░░░    //
//        ░░░░░░░░░░░░░░░░░░░██▒▒▒▒██▌░███▒▒▒▒██▌▒░░██▒▒▒▒███▒▐██▒▒▒▒██░░░░░░░░░░░░░░░░░░░    //
//        ▒░░░░░░░░░░░░░░░░░░██▓▄▄▄██▌▒███▄▓▓▓██▌░░░██▄▄▄▄███▒▐██▄▄▄▓██▒░░░▒░░░░░░░░░░░░░░    //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract MAXHG is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
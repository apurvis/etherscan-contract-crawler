// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Summer Waves
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                             //
//                                                                                             //
//                            SUMMER WAVES COLLECTION BY @TONYSKEOR                            //
//                                                                                             //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#PJ!^..       ..^!JP#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@B?:                       :[email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@&&BP5PPPPPPPPPPPPPPPPPPPPPPPPP5PB&&@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@&7                                     7&@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@[email protected]@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@5.:::::::::::::::::::::::::::::::::::::::::::[email protected]@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@P:::::::::::::::::::::::::::::::::::::::::::::::[email protected]@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@?^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^[email protected]@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@B                                                     [email protected]@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@G                                                       [email protected]@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@#######################################################@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@[email protected]@@@@@[email protected]@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@P    :&@J.^@J                                  ....   [email protected]@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@^  &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&[email protected]@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@7  &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&#BB?   555PGB&@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@7  &&~^[email protected]@&[email protected]@@@@@@@@@@@@@@&GY!^.                   [email protected]@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@!  &@~ [email protected]@!  [email protected]@@@@@@@@@@B7:    .:~7J5PBP  ^###BG5?~.    .&@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@!  &@@@@@@Y  [email protected]@@@&@@@@@@~ .!P&@@@@@@@@@@: :@@@@@@@@@@&!   [email protected]@@@@@@    //
//    @@@@@@@@@@@@@&B5P!  &@@@@@@G  [email protected]@@P. &@B?^. [email protected]@#[email protected]@@@: [email protected]@@@@@@@@@@@@:  [email protected]@@@@@@    //
//    @@@@@@@@@@&?.     .&@@@@@@#  [email protected]@&~ :P7  E   @&.       :@@^ [email protected]@@@@@@@@@@@@#  [email protected]@@@@@@@    //
//    @@@@@@@@@7  SSS  .B&#&&@@&  [email protected]@? .Y!  EE^ :&#  [email protected]@#^   G^ :@@@@@@@@@@@@#~ [email protected]@@@@@@@@    //
//    @@@@@@@@7              .7. ^KK  5B.     ^[email protected]  OOOOO&   . ^@@@@@@@@@@B!. ^[email protected]@@@@@@@@@@    //
//    @@@@@@@@#7~~!7JY55Y7.      ~ [email protected]@   [email protected]@@&   OOOOOO .  [email protected]@@@@@&G7.  ^5&@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@&BY!:  .!.   :[email protected]@&J   .?J?~:     ^~. :7. 7RRRRR:   :[email protected]@@@@@@@@@@@@@@@@    //
//    @@@@@@&#GY!:.    :7G&#~   .:.           :!5P:...:?GG.  ^.   .!YB&@@@&&###BB##&&@@@@@@    //
//    @@@B~.    .~?P#&@@@5:    .:^!?Y5G#@&&&@@@@@@BJ!^:.        ..::..                .:[email protected]@    //
//    @@&^~JG#&@@@@@@@@@B:  .#@@@@@@@@@@@@@@@@@@^              ...::^~!7?JY55P55YJ7~.   [email protected]@    //
//    @@@@@@@@@@@@@@@@@@@! .&@@@@@@@@@@@@@@@@@@&YY55PG:  G&&&@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@    //
//    @@@@@@@@@@@@@@@@@@~ .&@@@@@@@@@@@@@@@@@@@@@@@@@?  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@^ [email protected]@@@@@@@@@@@@@@@@@@@@@@@@@?  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@? [email protected]@@@@@@@@@@@@@@@@@@@@@@@@@5  [email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@. [email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                             //
//                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////


contract SUMMR is ERC721Creator {
    constructor() ERC721Creator("Summer Waves", "SUMMR") {}
}
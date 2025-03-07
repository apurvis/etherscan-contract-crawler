// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Jérôme Paressant
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                           //
//                                                                                           //
//                                                                                           //
//         ____.   __________  _____                  .__       .__                          //
//        |    |   \______   \/  _  \           ___  _|__| _____|__| ____   ____   ______    //
//        |    |    |     ___/  /_\  \   ______ \  \/ /  |/  ___/  |/  _ \ /    \ /  ___/    //
//    /\__|    |    |    |  /    |    \ /_____/  \   /|  |\___ \|  (  <_> )   |  \\___ \     //
//    \________| /\ |____|  \____|__  /           \_/ |__/____  >__|\____/|___|  /____  >    //
//               \/                 \/                        \/               \/     \/     //
//         ____.   __________  _____                  .__       .__                          //
//        |    |   \______   \/  _  \           ___  _|__| _____|__| ____   ____   ______    //
//        |    |    |     ___/  /_\  \   ______ \  \/ /  |/  ___/  |/  _ \ /    \ /  ___/    //
//    /\__|    |    |    |  /    |    \ /_____/  \   /|  |\___ \|  (  <_> )   |  \\___ \     //
//    \________| /\ |____|  \____|__  /           \_/ |__/____  >__|\____/|___|  /____  >    //
//               \/                 \/                        \/               \/     \/     //
//                                                                                           //
//                                                                                           //
//                                                                                           //
//                                                                                           //
//                                                                                           //
//                                                                                           //
//                                                                                           //
//                                                                                           //
//                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////


contract JPAV is ERC721Creator {
    constructor() ERC721Creator(unicode"Jérôme Paressant", "JPAV") {}
}
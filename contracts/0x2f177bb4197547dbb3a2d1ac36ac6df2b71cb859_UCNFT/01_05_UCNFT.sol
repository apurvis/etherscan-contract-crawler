// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: UC NFT Media Lab - On-Chain Royalty Test
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
//                                                                                                                     //
//    #     #  #####     #     # ####### #######    #     # ####### ######  ###    #       #          #    ######      //
//    #     # #     #    ##    # #          #       ##   ## #       #     #  #    # #      #         # #   #     #     //
//    #     # #          # #   # #          #       # # # # #       #     #  #   #   #     #        #   #  #     #     //
//    #     # #          #  #  # #####      #       #  #  # #####   #     #  #  #     #    #       #     # ######      //
//    #     # #          #   # # #          #       #     # #       #     #  #  #######    #       ####### #     #     //
//    #     # #     #    #    ## #          #       #     # #       #     #  #  #     #    #       #     # #     #     //
//     #####   #####     #     # #          #       #     # ####### ######  ### #     #    ####### #     # ######      //
//                                                                                                                     //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract UCNFT is ERC721Creator {
    constructor() ERC721Creator("UC NFT Media Lab - On-Chain Royalty Test", "UCNFT") {}
}
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Overworked - Bidders Editions
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                 //
//                                                                                                                                                                                                 //
//    ####### #     # ####### ######  #     # ####### ######  #    # ####### ######       ##       ###     #####     #    #     # ### #######    #######    #    #    # #######    ### #######     //
//    #     # #     # #       #     # #  #  # #     # #     # #   #  #       #     #     #  #       #     #     #   # #   ##    # ###    #          #      # #   #   #  #           #     #        //
//    #     # #     # #       #     # #  #  # #     # #     # #  #   #       #     #      ##        #     #        #   #  # #   #  #     #          #     #   #  #  #   #           #     #        //
//    #     # #     # #####   ######  #  #  # #     # ######  ###    #####   #     #     ###        #     #       #     # #  #  # #      #          #    #     # ###    #####       #     #        //
//    #     #  #   #  #       #   #   #  #  # #     # #   #   #  #   #       #     #    #   # #     #     #       ####### #   # #        #          #    ####### #  #   #           #     #        //
//    #     #   # #   #       #    #  #  #  # #     # #    #  #   #  #       #     #    #    #      #     #     # #     # #    ##        #          #    #     # #   #  #           #     #        //
//    #######    #    ####### #     #  ## ##  ####### #     # #    # ####### ######      ###  #    ###     #####  #     # #     #        #          #    #     # #    # #######    ###    #        //
//                                                                                                                                                                                                 //
//                                                                                                                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract OBE is ERC721Creator {
    constructor() ERC721Creator("Overworked - Bidders Editions", "OBE") {}
}
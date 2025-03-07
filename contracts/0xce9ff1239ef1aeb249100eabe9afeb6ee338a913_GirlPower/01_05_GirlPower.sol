// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Stellar Vault
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                                                                    //
//      __ _____ ___ _   _    __  ___   _   _   __  _  _ _ _____      //
//    /' _/_   _| __| | | |  /  \| _ \ | \ / | /  \| || | |_   _|     //
//    `._`. | | | _|| |_| |_| /\ | v / `\ V /'| /\ | \/ | |_| |       //
//    |___/ |_| |___|___|___|_||_|_|_\   \_/  |_||_|\__/|___|_|       //
//                                                                    //
//      *                   *                              *          //
//            **                *                     *               //
//                   **                * *  *                         //
//         *                                              *           //
//                                *                                   //
//                 *       ***                   **                   //
//                                                   *                //
//                    * **               *                            //
//                                                                    //
//                                                                    //
//                                                                    //
//                                *                                   //
//                                                                    //
//                                                                    //
////////////////////////////////////////////////////////////////////////


contract GirlPower is ERC721Creator {
    constructor() ERC721Creator("Stellar Vault", "GirlPower") {}
}
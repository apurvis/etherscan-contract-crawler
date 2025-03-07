// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Bekx Women
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                           //
//                                                                                           //
//                                                                                           //
//     _______       .-''-.  .--.   .--.  _____     __    ____    .-------. ,---------.      //
//    \  ____  \   .'_ _   \ |  | _/  /   \   _\   /  / .'  __ `. |  _ _   \\          \     //
//    | |    \ |  / ( ` )   '| (`' ) /    .-./ ). /  ' /   '  \  \| ( ' )  | `--.  ,---'     //
//    | |____/ / . (_ o _)  ||(_ ()_)     \ '_ .') .'  |___|  /  ||(_ o _) /    |   \        //
//    |   _ _ '. |  (_,_)___|| (_,_)   __(_ (_) _) '      _.-`   || (_,_).' __  :_ _:        //
//    |  ( ' )  \'  \   .---.|  |\ \  |  | /    \   \  .'   _    ||  |\ \  |  | (_I_)        //
//    | (_{;}_) | \  `-'    /|  | \ `'   / `-'`-'    \ |  _( )_  ||  | \ `'   /(_(=)_)       //
//    |  (_,_)  /  \       / |  |  \    / /  /   \    \\ (_ o _) /|  |  \    /  (_I_)        //
//    /_______.'    `'-..-'  `--'   `'-' '--'     '----''.(_,_).' ''-'   `'-'   '---'        //
//                                                                                           //
//                                                                                           //
//                                                                                           //
//                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////


contract BW is ERC721Creator {
    constructor() ERC721Creator("Bekx Women", "BW") {}
}
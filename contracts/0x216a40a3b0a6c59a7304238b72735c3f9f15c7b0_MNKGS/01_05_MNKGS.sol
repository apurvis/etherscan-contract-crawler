// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: MonKINGS
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                      //
//                                                                                                                      //
//          ___           ___           ___           ___                       ___           ___           ___         //
//         /\__\         /\  \         /\__\         /\__\          ___        /\__\         /\  \         /\  \        //
//        /::|  |       /::\  \       /::|  |       /:/  /         /\  \      /::|  |       /::\  \       /::\  \       //
//       /:|:|  |      /:/\:\  \     /:|:|  |      /:/__/          \:\  \    /:|:|  |      /:/\:\  \     /:/\ \  \      //
//      /:/|:|__|__   /:/  \:\  \   /:/|:|  |__   /::\__\____      /::\__\  /:/|:|  |__   /:/  \:\  \   _\:\~\ \  \     //
//     /:/ |::::\__\ /:/__/ \:\__\ /:/ |:| /\__\ /:/\:::::\__\  __/:/\/__/ /:/ |:| /\__\ /:/__/_\:\__\ /\ \:\ \ \__\    //
//     \/__/~~/:/  / \:\  \ /:/  / \/__|:|/:/  / \/_|:|~~|~    /\/:/  /    \/__|:|/:/  / \:\  /\ \/__/ \:\ \:\ \/__/    //
//           /:/  /   \:\  /:/  /      |:/:/  /     |:|  |     \::/__/         |:/:/  /   \:\ \:\__\    \:\ \:\__\      //
//          /:/  /     \:\/:/  /       |::/  /      |:|  |      \:\__\         |::/  /     \:\/:/  /     \:\/:/  /      //
//         /:/  /       \::/  /        /:/  /       |:|  |       \/__/         /:/  /       \::/  /       \::/  /       //
//         \/__/         \/__/         \/__/         \|__|                     \/__/         \/__/         \/__/        //
//                                                                                                                      //
//                                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract MNKGS is ERC721Creator {
    constructor() ERC721Creator("MonKINGS", "MNKGS") {}
}
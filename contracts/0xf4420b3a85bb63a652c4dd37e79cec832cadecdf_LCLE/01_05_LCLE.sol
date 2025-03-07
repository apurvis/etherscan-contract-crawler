// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Lee Cook Limited Editions
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                                                                                                    //
//                                                                                                                    //
//                        ___           ___           ___           ___           ___           ___                   //
//                       /\__\         /\__\         /\__\         /\  \         /\  \         /|  |                  //
//                      /:/ _/_       /:/ _/_       /:/  /        /::\  \       /::\  \       |:|  |                  //
//                     /:/ /\__\     /:/ /\__\     /:/  /        /:/\:\  \     /:/\:\  \      |:|  |                  //
//      ___     ___   /:/ /:/ _/_   /:/ /:/ _/_   /:/  /  ___   /:/  \:\  \   /:/  \:\  \   __|:|  |                  //
//     /\  \   /\__\ /:/_/:/ /\__\ /:/_/:/ /\__\ /:/__/  /\__\ /:/__/ \:\__\ /:/__/ \:\__\ /\ |:|__|____              //
//     \:\  \ /:/  / \:\/:/ /:/  / \:\/:/ /:/  / \:\  \ /:/  / \:\  \ /:/  / \:\  \ /:/  / \:\/:::::/__/              //
//      \:\  /:/  /   \::/_/:/  /   \::/_/:/  /   \:\  /:/  /   \:\  /:/  /   \:\  /:/  /   \::/~~/~                  //
//       \:\/:/  /     \:\/:/  /     \:\/:/  /     \:\/:/  /     \:\/:/  /     \:\/:/  /     \:\~~\                   //
//        \::/  /       \::/  /       \::/  /       \::/  /       \::/  /       \::/  /       \:\__\                  //
//         \/__/         \/__/         \/__/         \/__/         \/__/         \/__/         \/__/                  //
//                                    ___                                     ___                                     //
//                                   /\  \                                   /\__\         _____                      //
//                      ___         |::\  \       ___           ___         /:/ _/_       /::\  \                     //
//                     /\__\        |:|:\  \     /\__\         /\__\       /:/ /\__\     /:/\:\  \                    //
//      ___     ___   /:/__/      __|:|\:\  \   /:/__/        /:/  /      /:/ /:/ _/_   /:/  \:\__\                   //
//     /\  \   /\__\ /::\  \     /::::|_\:\__\ /::\  \       /:/__/      /:/_/:/ /\__\ /:/__/ \:|__|                  //
//     \:\  \ /:/  / \/\:\  \__  \:\~~\  \/__/ \/\:\  \__   /::\  \      \:\/:/ /:/  / \:\  \ /:/  /                  //
//      \:\  /:/  /   ~~\:\/\__\  \:\  \        ~~\:\/\__\ /:/\:\  \      \::/_/:/  /   \:\  /:/  /                   //
//       \:\/:/  /       \::/  /   \:\  \          \::/  / \/__\:\  \      \:\/:/  /     \:\/:/  /                    //
//        \::/  /        /:/  /     \:\__\         /:/  /       \:\__\      \::/  /       \::/  /                     //
//         \/__/         \/__/       \/__/         \/__/         \/__/       \/__/         \/__/                      //
//          ___                                                               ___           ___           ___         //
//         /\__\         _____                                               /\  \         /\  \         /\__\        //
//        /:/ _/_       /::\  \       ___           ___         ___         /::\  \        \:\  \       /:/ _/_       //
//       /:/ /\__\     /:/\:\  \     /\__\         /\__\       /\__\       /:/\:\  \        \:\  \     /:/ /\  \      //
//      /:/ /:/ _/_   /:/  \:\__\   /:/__/        /:/  /      /:/__/      /:/  \:\  \   _____\:\  \   /:/ /::\  \     //
//     /:/_/:/ /\__\ /:/__/ \:|__| /::\  \       /:/__/      /::\  \     /:/__/ \:\__\ /::::::::\__\ /:/_/:/\:\__\    //
//     \:\/:/ /:/  / \:\  \ /:/  / \/\:\  \__   /::\  \      \/\:\  \__  \:\  \ /:/  / \:\~~\~~\/__/ \:\/:/ /:/  /    //
//      \::/_/:/  /   \:\  /:/  /   ~~\:\/\__\ /:/\:\  \      ~~\:\/\__\  \:\  /:/  /   \:\  \        \::/ /:/  /     //
//       \:\/:/  /     \:\/:/  /       \::/  / \/__\:\  \        \::/  /   \:\/:/  /     \:\  \        \/_/:/  /      //
//        \::/  /       \::/  /        /:/  /       \:\__\       /:/  /     \::/  /       \:\__\         /:/  /       //
//         \/__/         \/__/         \/__/         \/__/       \/__/       \/__/         \/__/         \/__/        //
//                                                                                                                    //
//                                                                                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract LCLE is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
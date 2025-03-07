// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: gregrha
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//        ___       ___       ___       ___       ___       ___       ___       //
//       /\  \     /\  \     /\  \     /\  \     /\  \     /\__\     /\  \      //
//      /::\  \   /::\  \   /::\  \   /::\  \   /::\  \   /:/__/_   /::\  \     //
//     /:/\:\__\ /::\:\__\ /::\:\__\ /:/\:\__\ /::\:\__\ /::\/\__\ /::\:\__\    //
//     \:\:\/__/ \;:::/  / \:\:\/  / \:\:\/__/ \;:::/  / \/\::/  / \/\::/  /    //
//      \::/  /   |:\/__/   \:\/  /   \::/  /   |:\/__/    /:/  /    /:/  /     //
//       \/__/     \|__|     \/__/     \/__/     \|__|     \/__/     \/__/      //
//                                                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////


contract GRH is ERC721Creator {
    constructor() ERC721Creator("gregrha", "GRH") {}
}
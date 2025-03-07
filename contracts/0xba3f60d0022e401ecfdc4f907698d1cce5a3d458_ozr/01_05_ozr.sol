// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Omar Z Robles
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                  ╓╬  ╦                                                   //
//                                ╗╬ ╠  ╫╣╣╣                                                //
//                    ╓╖╗╗ ╣╣╣╣╣╣╣╣╣╣╣╣╣╬╓ ╝╣                                               //
//                ╔╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╗                                            //
//                ╣╣╣╣╣╣╣╣╣╣╣╣ ╝╝╝╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣ ╓                                         //
//                 ╣╣╣╣╣╣╣╣╣         ╝╬╣╣╣╣╣╣╣╣╣╣╣╣╣╦                                       //
//                   ╣╣╣╣╣╣           ╫╝╣╣ ╫╣╣╣╣╣╣╣╣╣╣╓                                     //
//                   ╙╝╫╣╣ ╫    ╜╣╣╣╫ ╣ ╣ ╣╣╣╫╣╣╣╣╣╣╣╣╣╗                                    //
//                         ╒╒─╘╫╣╓ ╝═╣╜╣ ╬╣╫╣╫╣╣╣╣╣╣╣╣╣╣╕                                   //
//                             ╣╟   └╨└    ╫╣╣╣╝╣╣╣╣╣╣╣╣╣                                   //
//                             ╙        ╓╓ ╣╣╔╓ ╒═╣╣╣╣╣╣╣                                   //
//                         ╓╖╣╣╣╝     ┌ ╓ ╣╫╣╓╣╣╟╟╣╣╣╣╣╣╬                                   //
//                        ╦╝╝╝╣╣╣╣╣╓╗  ╝╫╣╣╣╣╝ ╟╣╣╣╣╣╣╣╣                                    //
//                      ┌╟╣╦╗╗╖╣╬╟╣╣╣╣╣╣╣╣╣╣╣╒╣╣╣╣╣╣╣╣╨                                     //
//                      ╔ ╫╣╣╣╬╣╣╣╣╣╣╣╣╣╣╣╣╣ ╣╣╣╣╣╝╣   ╓╗╬╣╣╣╣╣╗   ╬╣╣╣╣╣╣╣╣╣ ╒╣╣╣╣╣╣╣╣╪    //
//                      ╬╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣          ╬╣╣╣   ╣╣╣╣      ╫╣╣╣╨  ╣╣╣╝  ╟╣╣╣    //
//                    ─╒╝╣╣╫╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣ ╒╣       ╣╣╣     ╣╣╣╝   ╓╬╣╣     ╟╣╣╣╣╣╣╣╝╝     //
//                    ──╓╣╣╣╣╣╣╬╣╣╣╣╣╣╨╣╪╣╣╟╫╣      ╞╣╣╣    ╬╣╣  ╓╬╣╣╬       ╣╣╣  ╣╣╣╣      //
//                 ─   ╗╫╣╣╣╫╣╣╣╣╣╣╣╣╣╣╣╜ ╓╣╣╣   ╗   ╝╣╣╣╣╣╣╣   ╬╣╣╣╣╣╣╣╣╣╣ ╣╣╣╣  ╚╣╣╣╕     //
//                  └  └╬╣╣╣╣╣╣╣╣╣╫╣╟╝  ╦╣╫╣   ┌                                            //
//                 ╦ ╦   ╨╣╫╣╣╫╝╣ ╫   ╓   ╣╓═ ╗       ╔                                     //
//                ╒╙╬ ═  ╕╫    ╚╣╙╦ ╬    ╟╣╝─╝┌      ╒                                      //
//         ╙  ╗╬╘┐╬╕╣╞└  ╣╟      ╙╬ ╣╣ ╓╣╣   ╪ ╒ ─═ ╫╙╗                                     //
//               ╝╬╓╣╘ ╜ ╬╣╦╒─ ─╓╡ ╟└ ╫╣╣ ╒╓╝  └   ╓ ╣ ╟╠╒                                  //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////


contract ozr is ERC721Creator {
    constructor() ERC721Creator("Omar Z Robles", "ozr") {}
}
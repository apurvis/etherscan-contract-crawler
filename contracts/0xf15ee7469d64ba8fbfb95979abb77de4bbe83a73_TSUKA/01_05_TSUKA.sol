// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Secret Tsuka Society
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//                                       ═         ╟╦                                                         //
//                                       ╣         ╣╣═                                                        //
//                                       ╫╣╦       ╫╣╣                                                        //
//                              ╘╦       ╚╣╣╣╦     ╚╣╣╣╗     ╔╬                                               //
//                               ╚╣╗╦      ╣╣╣╣╣╗╦╔ ╚╣╣╣╣╗   ╟╣╦                                              //
//                                 ╚╣╣╣╣╗╗╗╗╫╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╗╟╣╣╦                                             //
//                                ╔╔╓╒╚╚╝╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╦                                           //
//                          ╔╓╗╣╣╣╣╣╣╣╣╣╗╖╦╔╔╚╚╝╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╦                                        //
//                       ╓╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╝╝╜╜═╚╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╬╚╙╣╣╦                                       //
//                    ╔╣╣╣╣╩╚╚╔╓╣╣╣╣╣╣╦╘╔╗╗╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╗╔╟╣╣╦                                      //
//                   ╫╣╩╚   ╗╣╣╣╣╣╣╣╣╣╣╝╩  ╒╔╦╦╟╚╝╣╣╣╣╣╣╣╣╣╣╣╣╝╣╣╣╣╣╣╣╣╣╗╔                                    //
//                  ╝╘   ╔╣╣╣╣╣╣╣╣╣╣╩╘ ╔╗╣╣╣╣╣╣╣╣╣╗╦╚╝╣╣╣╣╣╣╣╣╦    ╚╙╣╣╣╣╣╣╣╣╣╣╣╗╦                            //
//                     ╔╣╣╣╣╣╣╣╣╣╩═ ╓╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╗╖╟╚╝╣╣╣╗╒  ╘╗  ╚╙╩╩╩╜╣╣╣╣╣                            //
//                    ╔╣╣╣╣╣╣╣╣╝═ ╗╣╣╣╣╣╣╝╩╚╘        ╔╗╗╣╣╣╣╣╣╣╣╣╣╗  ╙╗╦╔╔╔  ╔╝╚╚                             //
//                   ╟╣╣╣╣╣╣╣╣╩ ╓╣╣╣╣╣╩╘╔╝         ┌╩╚═     ═╚╚╝╣╣╣╗╓  ╚╚╙╬╚╣╗                                //
//                  ╟╣╣╣╣╣╣╣╣═ ╫╣╣╣╝╚ ╗╣                        ╘╣╣╣╣╗╦╗═    ╟╣╣═                             //
//                 ╓╣╣╣╣╣╣╣╣═ ╣╣╣╣╩ ╔╣╩                           ╟╣╣╣╣╝      ═╚╣╦                            //
//                 ╣╣╣╣╣╣╣╣╬ ╟╣╣╣  ╫╣╩                           ╚╚╚             ╩                            //
//                ╔╣╣╣╩╟╣╣╣ ╔╣╣╣═ ╟╣╣                                                                         //
//                ╟╣╣═╓╣╣╣╣ ╟╣╣╩  ╣╣╣                                                                         //
//                ╟╣  ╫╣╣╣╣ ╟╣╣  ╔╣╣╣                                                                         //
//                ╙╩  ╫╣╣╣╣═╟╣╣  ═╣╣╣                                                                         //
//                 ═  ╟╣╣╣╣╣═╣╣═  ╫╣╣╗                                                                        //
//                    ╙╣╣╣╣╣╦╙╣╣  ╚╣╣╣╦                                                                       //
//                     ╫╣╣╣╣╣╦╚╣╦  ╚╣╣╣╗                                                                      //
//                     ╚╣╣╣╣╣╣╗╚╣╦  ╚╣╣╣╣╗                            ╔╩                                      //
//                      ╚╣╣╣╫╣╣╣╦╚╗   ╚╣╣╣╣╗╦                        ╗╩                                       //
//                       ╙╣╣╦╚╣╣╣╣╦╚╦   ═╚╣╣╣╣╣╗╗╔      ╔╔╔╗═      ╗╣╩                                        //
//                        ╚╣╣╦╚╣╣╣╣╣╣╬═╦    ╘╚╚╝╝╝╝╝╝╝╜╩╚═      ╔╣╣╝                                          //
//                          ╚╣╦ ╚╝╣╣╣╣╣╣╣╬╦╔               ╔╔╗╣╣╣╩                                            //
//                            ═╚   ╚╣╣╣╣╣╣╣╣╣╣╣╗╗╗╗╗╗╗╗╣╣╣╣╣╣╣╝╚                                              //
//                                    ╚╙╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╝╩╘                                                 //
//                                         ╚╚╚╚╩╩╝╝╩╩╚╚╘                                                      //
//                                                                                                            //
//    ╔╦╗╦ ╦╔═╗  ╔═╗╔═╗╔═╗╦═╗╔═╗╔╦╗  ╔╦╗╔═╗╦ ╦╦╔═╔═╗  ╔═╗╔═╗╔═╗╦╔═╗╔╦╗╦ ╦                                     //
//     ║ ╠═╣║╣   ╚═╗║╣ ║  ╠╦╝║╣  ║    ║ ╚═╗║ ║╠╩╗╠═╣  ╚═╗║ ║║  ║║╣  ║ ╚╦╝                                     //
//     ╩ ╩ ╩╚═╝  ╚═╝╚═╝╚═╝╩╚═╚═╝ ╩    ╩ ╚═╝╚═╝╩ ╩╩ ╩  ╚═╝╚═╝╚═╝╩╚═╝ ╩  ╩                                      //
//    The Secret Tsuka Society awards the Tsuka Medals of Honor to those who witnessed the                    //
//    awakening of the sleeping dragon.                                                                       //
//    These medals are made of various materials and are limited in number.                                   //
//    The Secret Tsuka Society believes that                                                                  //
//    the Great Dragon will fly high and bring prosperity and peace.                                          //
//                                                                                                            //
//                                                                                                            //
//    The Secret Tsuka Society seeks to create more variety around the                                        //
//    Dejitaru Tsuka and aims to raise awareness for                                                          //
//    the great dragon and spread the word of his arrival.                                                    //
//                                                                                                            //
//                                                                                                            //
//    Expect the Dragon                                                                                       //
//    ~The Secret Tsuka Society (@TsukaSociety)                                                               //
//                                                                                                            //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract TSUKA is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
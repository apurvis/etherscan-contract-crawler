// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Joelle Editions
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    ╠┌]▐╟╫ë▒╠╬▌▓█▓║▌█▓▓█████████████▓▐█╣▓▒▒].│~  ] ~l |⌐ 'j╡   ─[ ⌐  ▒╟  ▓█▌▒╟█▓╣╡»[    //
//    ╠┌]▐╟╫ë▒╠╬▌▓█▓║▌█▓▓▌████████████▓▐█╣▓▒▒].│~  ] ~l |⌐ 'j╡   ─[ ⌐  ▒╟  ▓█▌▒╢█▓╣╡ⁿ[    //
//    ╠┌]▐╟╫ë▒╠╬▌▓█▓║▌█▓▓█████████████▓▐█╣▓▒▒].│~  ] ~l |⌐ 'j╡   ─[ ⌐  ▒╟  ▓█▌▒╢█▓╣╠[[    //
//    ╠┌]▐╟╫ë▒╠╬▌▓█▓║▌█▓▓█████████████▓▐█╣▓▒▒].│~  ] ~l |⌐ 'j╡   ─[ ⌐  ▒╟  ▓█▌▒╢█▓╣╡"[    //
//    ╠┌]▐╟╫ë▒╠╬▌▓█▓║▌█▓▓███╬█████████▓▐█╣▓▒▒].│~  ] ~l |⌐ 'j╡   ─[ ⌐  ▒╟  ▓█▌▒╢█▓╣╡ⁿ[    //
//    ╠┌]▐╟╫ë▒╠╬▌▓█▓║▌█▓▓█████████████▓▐█╣▓▒▒].│~  ] ~l |⌐ 'j╡   ─[ ⌐  ▒╟  ╣▓▌▒╢█▓╣╡»»    //
//    ╠┌]▐╟╫ë▒╠╬▌▓█▓║▌█▓▓████████▌████▓▐█╣▓▒▒].│~  ] ~l |⌐ 'j╡   ─[ ⌐  ▒╟  ╣▓▌▒╟█▓╣╬ε[    //
//    ╠┌]▐╟╫ë▒╠╬▌▓█▓║▌█▓▓█████████████▓▐█╣▓▒▒].│~  ] ~l |⌐ 'j╡   ─[ ⌐  ▒╟  ╣█▌▒╢█▓╣╬",    //
//    ╠┌]▐╟╫ë▒╠╬▌▓█▓║▌█▓▓█████████████▓▐█╣▓▒▒].│~  ] ~l |⌐ 'j╡   ─[ ⌐  ▒╟  ▓█▌▒╢█▓╣╡ⁿ[    //
//    ╠┌]▐╟╫ë▒╠╬▌▓█▓║▌█▓▓█████████████▓▐█╣▓▒▒].│~  ] ~l |⌐ 'j╡   ─[ ⌐  ▒╟  ╬▓▌▒╠█▓╣╠,[    //
//    █████████████████████████████████████████████▓███████████████▓████▓▌╬███████████    //
//    ████████╣▌████████████████╬█▓▓▓██████████████████████████████████▓█▓████████████    //
//    ████████▓██████████████████████████████▓██▓╬▓▓╬▓▓▓▓▓▓▓█▓█▓▓▓▓▓▓▓▓▓▓██▓▓╬╬╣╬▓╬╣╬▓    //
//    ╬╬╣▌╬╬╬╬▓▌╬╬╬╬╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓▌╬╬╬╬╬▓╬▓▓▓▓███▓▓▓▓▓▓▌▓╬▓▓▓▓▓▓▓▓████████▓█▓▓▓█▓    //
//    ████████████████████████████████████████████████████████████████████▓███████████    //
//    ███▌███████████████▓▓██████╬██████████████████████████████████████▓▓╙███████████    //
//    █████████████████████████████████████████████▓█▓█████████████▓███╣▌Γë▓▓▓████████    //
//    ▓▓▌▓▓▓▓▓╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬▌╩╠╬▓╣▓╬▓▓▓╣▓▌▓▓▓▓╣╫▀░▐▒▌╙╚╚╟╬╫╫▀▀╬▓    //
//    ""│""""└∩^""""│""└"""""""^"""""" ^"""""["`;,.φ┐╓`,`,,"^┐└┌^,└][└,║╫▓▓▒▒φε;;ë:»]'    //
//    ▒▒╠▒▒▒▒▒╣║▒▒▒▒║▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒╢▒▒▒▒▒▒║▒║╫╣╣▓▓╣╬╬╬╣╬╣▒╣▒╣╬╣╣╣╬╣╣▓▓██▓▓▓▓▌▓╣╬╣╣╣    //
//    ╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙▀╙▀▀╙╙╙╙╙╙╙╙╙╙╙    //
//                                                                                        //
//                ▓█▓                   ▄▄   ▄▄    ]▓▓▌   ▓▓▓                             //
//                ▀█▀                  ▓██▀ ╫██▌O└L╣███─╧L███Jε>Ë▀▓ Ë                     //
//                          ,╓╓,         ,,╓,      ▐██▌   ███       ,╓╓                   //
//                ███    ▄███████▓µ    ▄███████▌   ▐██▌   ███    ▄╬█╬╝▓▓▓▄Φ▀▀▀Φ▀Φ▀▀Φ²O    //
//                ███   ███╙    ███µ  ███─    ███  ▐██▌   ███   ███─    ███               //
//                ███  j███     ▐██▌ j███████████  ▐██▌   ███  j███████████               //
//                ███   ███     ▓██▀  ███     ▄    ▐██▌   ███   ███     ▄                 //
//    ▀▀▀⌐▀▀╧▀Γ'"Φ▓██╧²ë╝╟██▓▌▓███▀   └███▓▄▓███└  ▐██▌   ███   └███▓▄▓███└               //
//                ███      ╙╙▀▀╙─        ╙╙▀▀╙─     ╙╙─   ╙╙╙      ╙╙▀▀╙─                 //
//            ╒▄▄▄███                                                                     //
//            ▀▀█▀▀╙                       ²▀                                             //
//    ,,,                                                                                 //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract JLED is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
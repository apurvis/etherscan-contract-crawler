// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Kevin Merge BLeU
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                  //
//                                                                                                                                  //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX0KKKKKKKKKKKKKKKKK0XMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWl...................cNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO;;;;;;;;;;;;;;;:oxxxxxxxxxxxxxxxxxxxd:;;;;;;;;;;;;;;;kMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMW0xxxxxxxo:::::::::::::::c0MMMMMMMMMMMMMMMMMMMKl;::::::::::::::lxxxxxxx0WMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMWNNNNNXc.......oWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd.......:KNNNNNWMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMx,'..';xKKKKKKKNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNKKKKKKKx;'....dMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMXoclllooodKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxoooollcl0MMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMW0kd:'dNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0kkkkkkkkkkkkkkkkkkk0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMx,'lO0NMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMK, ;0WWMMMMMMMMMMMMMMMMMWNNNNNNNNNNNWK,                   '0WNNNNNNNNNNNWMMMMMMMMMMMMMMMMMWWX: 'OMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMK, ,KMMMMMMMMMMMMMMMMMMXl'''''''''''',lkkkkkkk;      :kkkkl;''''''''''''cKMMMMMMMMMMMMMMMMMMN: .OMMMMMMMMMMMM    //
//    MMMMMMMMMMW0xdl:dNMMMMMMMMMMMMM0oloolcccccccccccccl0MMMMMMM0lcc.  ,ldXMKocccccccccccccloollOWMMMMMMMMMMMMWx:cddOWMMMMMMMMM    //
//    MMMMMMMMMMN: '0MMMMMMMMMMMMMNK0c     c0000000000000000KKKKKKKKK:    .OMMMMMMMMMMMMMMMO,....:O0NMMMMMMMMMMMMMK, ;XMMMMMMMMM    //
//    MMMMMMMMMMN: '0MMMMMMMMMMMMMk.        .........................     '0MMMMMMMMMMMMMMMWXXXX0: .xMMMMMMMMMMMMMK, ;XMMMMMMMMM    //
//    MMMMMMMMMMN: '0MMMMMMMMMMXo;:ldoddddddddddddddddddddddddddddddd,    .,::::kWMMMMMMMMMKl;:;;.  .;lKMMMMMMMMMMK, ;XMMMMMMMMM    //
//    MMMMMMMMKkkl,lKMMMMMMMW0xo:,lXMMMMMMMMMMMMNOxxxxxxxxxONMMMMMMMMk,,,,'     'xkxkkkkxxkl. .,,,,,,,;oxONMMMMMMMXo,lxkKWMMMMMM    //
//    MMMMMMMWc .xWWMMMMMMMMK; .xWWMMWNNNNNNNNNWk.         .kWNNNNNNNNNNNWO'      ..........  lNMWWWWWO. '0MMMMMMMMWWO. :NMMMMMM    //
//    MMMMMMMWc .xMMMMMMMMMMX; .kMMMMO,.''''''''.           .'''''''''''''.     ,O000000000000XMMMMMMMO. '0MMMMMMMMMMO. :NMMMMMM    //
//    MMMMMMMWc .xMMMMMMMMMMX; .kMKdo;                ,do.    .odddddddo'    .coOWMMMMMMXxloooooooolll;. '0MMMMMMMMMMO. :NMMMMMM    //
//    MMMMMMMWc .xMMMMMMMXOOx:';oOl. .',.          .',kMWc    :NMMMMMMMWc    ;XMN000000Oxc,,,,.          .dOOKWMMMMMMO. :NMMMMMM    //
//    MMMMMMMWc .xMMMMMMWl  .dN0,    :NWl          cWWMMWc    :NMMMMMMMWc    ;XMx.      ;XWWWWd.             :NMMMMMMO. :NMMMMMM    //
//    MMMMMMMWc .xMMMMMMWc  .xMK, 'dx0WMo          lWMOc:. .lx0WMMMMMMMMKxo. .,:.  ;xxxx0WMXo;'  ;xxxxxxxl.  :NMMMMMMO. :NMMMMMM    //
//    MMMMMMMWc .xMMMMMMWc  .xMK, 'dxxxkoc:.       ,xx;    ,KMMMMMMMMMMMKxxl;'  .::OMMMMMMM0,    ;xONMW0xl.  :NMMMMMMO. :NMMMMMM    //
//    MMMMMMMWc .xMMMMMMWc  .xMK;....   lWN:  ...        ..:KMMMMMMMMMMWc '0MO. cWMMMMMMMMMK:..    .kWK,     :NMMMMMMO. :NMMMMMM    //
//    MMMMMMMWc .xMMMMMMWc  .xMWX0K00c  .''  .kXk'      .xXXWMMMMMMMMMMWc '0MO. lWMMMMMMMMMWXXo.    .,.      :NMMMMMMO. :NMMMMMM    //
//    MMMMM0oooldKMMMMMMWc  .xMMMMMMMKdoooc. .:oxkxdddddkXMMMMMMMMMMM0ol. '0MO. .lolldXMMMMMMMXxdddddddddc.  :NMMMMMMXdlooo0MMMM    //
//    MMMMMo  dMMMMMMMXOx:..,kMMMMN0kKWMMMNo'''.l0KKKKKKKKKKKKKKKKKK0:  .'cKM0:''''. .d0KWMMMMMMMNK0KK000d.  'xOKMMMMMMMx. lMMMM    //
//    MMMMMo  dMMMMMMMd  :0XNWMMMMO' :NMMMMWNNNNk'...................  .xNWWMWWNNWNc   .:XMMMMMMMd.......       cWMMMMMMx. lMMMM    //
//    MMMMMo  dMMMMMMMd  cNWMMMNo,cxx0WMMMMMMMMMNOxkxxkkkkkkkkkkxxkxxxxkXMMMMMMMMMMKxo. .,;;;;;;;.  :xxxxc      cWMMMMMMx. lMMMM    //
//    MMMMMo  dMMMMMMMd  cNWMMMX; ;XMMMM0ddddddddddddddddddddddddddddddddddddONMMMMMMNd::::'        ;ddod;      cWMMMMMMx. lMMMM    //
//    MMMMMo  dMMMMMMMd  cNWMMMXc.cXMMMWl  ................................  'OXXXXXXXKKKKKd.  ..............   cWMMMMMMx. lMMMM    //
//    MMMMMo  dMMMMMMMo  cXWMMMWXKXWMMMWl .oXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXk.  ..............  ;KXXXXXKKKKKXXKl  cWMMMMMMx. lMMMM    //
//    MMMMMo  dMMMMMMMKdoc;;c0MMMMMMMMMWl .xMNd;xNMMMMMMMMMMMMXo:ccccc:lKMNkdddddddddddddddddd0WWkc::::::::::cod0WMMMMMMx. lMMMM    //
//    MMMMMo  dMN0x0NMMMWc  .dMMMMMMMMMWl .xMXo'oNMMMMMMMMMMMMKl'',,'. .cOOOOOOOOOOOOOOOOOOOOOOOk;  .''''.   :NMMMW0xONMx. lMMMM    //
//    MMMMMo  dM0' 'OWWMWc   dNWWMMMMMMWl .xWWNNNWWWMMMWWMMMWWWWWWWWWl   ......................    .xWNNNx.  :NMWW0, .OMx. lMMMM    //
//    MMMMMo  dMN0kl,'lXWKkkd:';OMMMMMMMXkkl,,,,'''dWWx,:0MNo'oNMMMMMXOOOOOOOOOOOOOOOOOOOOOOOOOOOOkONMKc':dkkKWNo',lkONMx. lMMMM    //
//    MMNkdl:c0MMMMKl::coloolcc:looookNMMMWkcllllccOWMOcoXMN: .ldooooooxXMNOddoooooooooooooooooooooooooc:clooooc::l0MMMMKl:lxkXM    //
//    MMO. cWMMMMMMMMMx.....'o0x.  ..;k0000KKKWMMMMMMMMMMMMNl..........;0MXl''...........         ..  .d0o'.....oWMMMMMMMMMo .xM    //
//    MMO. cWMMMMMMMMMNXKXXXO;.   'kXo. .....'OMMMMMMMMMMMMMNXNNNNNNNNXNWMMWNNNNNNNNNNNNO'       :KO,   .,kXXXXXNMMMMMMMMMMo .xM    //
//    MMO. cWMMMMMMMMMMMMMMMNOddddl;;.  'dddxo:;;;;;:::;cKMMMMMMMO:;;::::::::::::::::::;:odddd,  .,;lddddkNMMMMMMMMMMMMMMMMo .xM    //
//    MMO. cWMMMMMMMMMMMMMMMMMMMMM0:'',':dxxxl.       .,:okOXMMMMk;,'.                  .cxxxxc,,,';OMMMMMMMMMMMMMMMMMMMMMMo .xM    //
//    MMO. cWMMMMMMMMMMMMMMMMMMMMMMWWWWNc     ...     cNX; .kMMMMWWMN:                 ..     :XWWWWMMMMMMMMMMMMMMMMMMMMMMMo .xM    //
//    MMO. cWMMMMMMMMMMMMMMMMMMMMMMMMMMMXOOOOO0K0OOOOOXMWKk0NMMMMMMMWc  cOo. .dOOOOOOO0K0OOOOOKWMMMMMMMMMMMMMMMMMMMMMMMMMMMo .xM    //
//    MMO. cWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOlcclcccxXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMo .xM    //
//    MMO. cWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX; .kMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMo .xM    //
//    MMO. cWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX; .kMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMo .xM    //
//    MMO. cWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX; .OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMo .xM    //
//                                                                                                                                  //
//                                                                                                                                  //
//                                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract KMB is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
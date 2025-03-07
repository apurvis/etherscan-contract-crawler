// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Karrie Ross Fine Art
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                      //
//                                                                                                                                                                                      //
//                                                              ,      ,,,,,,,,                                                                                                         //
//                                                    ,,;|||________________________ ___||;  _                                                                                          //
//                                               ,,l|||________________________||_________ __ |                                                                                         //
//                                           ,<l||____________________________________||_________ | _                                                                                   //
//                                        ,L||__|'   _____________________________________|||________!,                                                                                 //
//                                    ,Ll||___ _ _ ___________________________|________  __||||||||_____|__| _                                                                          //
//                                ,||_________________________________________________________||||||||||______|                                                                         //
//                              ,l__|__|||||___________________________ __ _____________________|||||||||||||___| _                                                                     //
//                           ,!|_||_||||||||______________ _,,[email protected]@@@@@@@@@gmppg,,_    _____________||||||||||||____L                                                                    //
//                         ,l__|___|||||||____________,[email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@Nwg,_ ______________|||||||||__ | _                                                                //
//                      _;|||_ __|||||||||_____ _,,[email protected]@@@@@@@@@P,@[email protected]@@@@@@@@@@@@@@@@@@@@@@@@@p,  _ ___ _||____|||||||____                                                                //
//                     ,|||  ___|||||||||____,[email protected]@@@@@@@@@@@ @C]@[email protected]]@@[email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@g,__|_________||||||___|                                                              //
//                    L__|  __|||||||||||_,[email protected]@@@@@@@@P,[email protected][email protected],[email protected][email protected]%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@g __________|||||___                                                              //
//                  |________|||||||||||,@@@@@@@@@@@P]@@P @K g$ @P)@]@@]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,|________||||||___                                                            //
//                | ______ _||||||||||[email protected]@[email protected]@@[email protected] @P [email protected] ]@ [email protected]@[email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@g_____|___|||||__                                                            //
//               |________||||||||||[email protected]@@@P  ]@@@@@C,]@@@@ [email protected]]@$,][email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,_|||_||||||||__|                                                          //
//              _________||||||||'[email protected]@@@@L  [email protected]@@@`@@@@[email protected][email protected][email protected]@@@@****"""*[email protected]   @Ng `%@@`[email protected]@@[email protected]@@@@@@@g__|_||__|||||__                                                          //
//             _________||||||||[email protected]@@@@@@K  [email protected]@P,@@@@@@@@@_  ]@@@@@@  ]@@@  ]@  ]@@@  [email protected]@, ,@  ]@@@N]@@@@@@@@@@__|_____||||||_                                                         //
//            __________|||||||__,@@@@@@@@K  [email protected]`@@@@@@@@@@@]C  @@@@@@  ]@@@_  @  ]@@@  [email protected]"""]  ]@@]@[email protected]@@@@@@@@@@_|||_|||||||||_                                                        //
//            ______|___|||||| [email protected]@@@@@@@@P  F,@@@@@@@@@@@ @@  ]@@@@@  ]@@@  [email protected]  ]@@"  @@@[  @P ]NP @@@@@@@@@@@@@@_||_||_|||||||                                                        //
//          |__________||||||[email protected]@@@@@@@@@P    "[email protected]@@@@@@@P][email protected]  @@@@@  ]*",[email protected]@@  ]gg'%@@@@K  @L  @g @@@@@@@@@@@@@@r|||||_||||||_L                                                       //
//          ____________||||___#@@@@@@@@@@P  @  _%@@@@@@@[email protected]@@/  ]@@@@  ]@C ]@@@  ]@@  ]@@@K  @K  @@@]@@@@@@@@@@@@@@|||||__||||||_                                                       //
//          ____________||||[email protected]@@@@@@@@@@P  @@_  %@@@@@ @@@@@W  [email protected]@@  ]@@  ]@@  [email protected]  @@M^^~,[  [email protected]@@@ [email protected]@@@@@@@@@@|||||___|||||||                                                      //
//          ___________|||||[email protected]@@@@@@@@@@P  @@@   %@@@[email protected]@@@@   @@@  ]@@   @[email protected]"%  ] @@@@__  ]*$$,,]@@@@@@@@@@@_||||__|||||||__                                                     //
//          ___________|||||[email protected]@@@@@@@@@@@P  @@@@p  %@@@@@@@@@[email protected]@   @@P  [%@@@@@ \  N`",@@ @@@@@@@@@@@@@@@@@@@@_||||||_||||||_                                                      //
//          __________|||||| [email protected]@@@@@@@@@@[,,,,[email protected]@@g  %@@@@@@@@@@@@@@[email protected]@  ][email protected]@ ]@_"[email protected]@@`[email protected]@@@@@@@@@@@@@@@@@@@P|||||___|||||__                                                     //
//          ________||__||||_]@@@@@@@@@@@@@@@@@@@@@@w,`*[email protected]@"""`]`"*@@@@@@@@@, ]@@@@`,@@@@[email protected]@@@@@@@@@@@@@@@@@@@@@@P|||||__||||||__                                                     //
//          ___________||||||]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ]@@K  %@@@@@@@[email protected]@P"2"M]@P"$Z%C]@@@@@@@@@@@@@@@@P|||||__||||||___                                                    //
//          __________|||||||]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ]@@@   @@@P ,@@@g "@@@  @@@p]  @@@@ ]@@@@@@@@@@@@@@@@P||||||_||||||___                                                    //
//          _____________'|||]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ]@@@   @@  ,@@@@@C [email protected]  ]@@@]  ]@@@K]@@@@@@@@@@@@@@@@P|||||_|||||||___                                                    //
//           _____________||_]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ]@@P [email protected]@_  @@@@@@@  ]@N  ]@@@@   [email protected]@@@@@@@@@@@@@@@@@@_|||||_||||||||__                                                    //
//          |______________|_"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  "*`,[email protected]@@_  @@@@@@@   @@@  _%@@@_  ]@@@@@@@@@@@@@@@@@@_|||||||||||||___                                                    //
//           _________________"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ]g _%@@@   @@@@@@@  ]@@@@   ]@@@g  "@@@@@@@@@@@@@@@@K||||||||||||||__                                                     //
//           |_________________]@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ]@P  %@@K  ]@@@@@C ,@@@@@@g  [email protected]@N   %@@@@@@@@@@@@@@_||||||||||||||_                                                      //
//            _|________________"@@@@@@@@@@@@@@@@@@@@@@@@@@@  ]@@   [email protected]@@, %@@@" [email protected]@@@@@@@@_  %@@@   ]@@@@@@@@@@@@_||||||_|||||||_L                                                      //
//            '___________________%@@@@@@@@@@@@@@@@@@@@@@@@@  ]@@@   @@@@@@[email protected]@@@@@@M**MB",,  _""Nw  [email protected]@@@@@@@@@_|'_____|||||||||_                                                      //
//             '_|________________ __"*[email protected]@@@@@@@@@@@@@@@@@@*  _*@@@g _%@@@@@@@@@@@,@@@@Pg]@@p ]@Ng   ]@@@@@@@@@_|______|_|||||_|'                                                       //
//              '|________||_____________'*[email protected]@@@@@@@@@@@@@@@@@@@@@@@@[email protected]@@@@@@@@ @@@@@ @@@@@ ]@@@@P __"[email protected]@@N"|||||____`||||__|'                                                        //
//               _|_________|___ ____________ "*[email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@p%@@@@@"[email protected]@@ @@@@P [email protected]@g, `'l||||||||_| ||___|'_                                                        //
//                 !____________ __ ___|_|________ "*[email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@g"[email protected]@@@[email protected]",**",[email protected]@@M" _lL,  _'*lL!'',l____|`                                                          //
//                  ' _________|_   _ __________________'"[email protected]@@@@@@@@@@@@@@@@@@@@@@@@@gg,[email protected]@@@@@N*`___||||__||llL;;Ll|___|_'                                                            //
//                   _'__|_|____|||__ _____________||________ ""[email protected]@@@@@@@@@@@@@@@@@@@@@@@@@NM"___|||||||||||||||____|___|'_                                                             //
//                     ' __|____||||_|_______________|_______||||__"*[email protected]@@@@@@@@@@@@@@N*"__||||||||||_||||||||____|__||'                                                                //
//                      _|___|_|_|||||_||________________|______________   ``````  _|||||||||||||||||||||||||_|||||_|'                                                                  //
//                        _|_____||||||||________________|_______________________|_____||||||||||||||||||___||||||_`                                                                    //
//                          ' ____||||||||_________|____|____________________||___|||__|_|||||||||||||__|__|||||_____                                                                   //
//                            '|____|||||||||_______________________|____ __________|____|||||||||__________|_|______                                                                   //
//                              `|___'|||||||||__________________|_______|||||_|_|___|||||||||_________|_____''__ ___                                                                   //
//                                _'___'||||||____||___________  ____________    ______  __ __    ______ |'                                                                             //
//                                   '!_ 'l!________________|______||||||_____|||_____________________'`                                                                                //
//                                     _     _''|_______________________|_____________________ _  '__                                                                                   //
//                                                _`'''| ______________________________ __ _ ''__                                                                                       //
//                                                        __`'''''         _  _    |''''`__                                                                                             //
//                                                                                                                                                                                      //
//                                                                                                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract KRFA is ERC721Creator {
    constructor() ERC721Creator("Karrie Ross Fine Art", "KRFA") {}
}
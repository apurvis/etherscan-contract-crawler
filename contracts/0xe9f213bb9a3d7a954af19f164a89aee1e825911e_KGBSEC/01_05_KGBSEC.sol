// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: KGB Secrets by Daniel Estulin
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                //
//                                                                                                                                //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#,  ,(%&@@@@@@@@@@@&%/.( *%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%  %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#%%@@#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@( (@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(@@@@@@*    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ &@ @@@@@.,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@* @@@@@@@@@@@  .  @@@@@@*   ,(%@@@@@@&&/.   (@@@@@@@@@@@#@ %@.#@@@@ %@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@*,@@@@@@@@@@@@@@@@@/ @@@@@@@@         @@      /#@@@@%. %@@@@@@. (@ (@/@@@ #@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@% @@@@@@@@@@@@@@@/ @@@@*           /#@%@&  %.     &@   @#,@@@@&%@@@@@ % @/[email protected]@@@ @@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@.(@@@@@@@@@@@@@( @@@*@        *   @@@@@@@@& (@          (    /. [email protected]@% @@@@@,%@/%@%@@,#@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@*&@@@@@@@@@@@@*,@@@#           . @@@@@@@@@@@&@&   .          &/#  &@( #@@ &@@@@# %@*/@@//@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@,%@@@@@@@@@@@&[email protected]@%  .   /  @&   ,@@@@@@@@@@@@@%@/    &            %    (   (@&%@@@@[email protected]@ ,@@,#@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@&[email protected]@@@@@@@@@@*(@@.  ,&     @     @@@@@@@@@@@@@@@@*@         #&@[email protected]    %(%      #@@ @@@@ %# #@@@ @@@@@@@@@@@@    //
//    @@@@@@@@@@@ @@[email protected]@@@@@@@*(@@       .   *  /@*@@@@@@@@@@@@@@@@@@           **@        /  ,.#/ # @@(&@@@ . @@@@#*@@@@@@@@@@    //
//    @@@@@@@@@@*@@&@@@%@@@&,@@     /. .  *(/   (@@@@@@@@@@@@@@@@@@@#      @@@           ,  #  /.&#*  @@ @@@@ (###@@ @@@@@@@@@    //
//    @@@@@@@@&[email protected]@@@%@@@@@@@@*             %   *@@@@@@@@@@@@@@@@@@@@@,  @@#.(@ [email protected]@  @@     @.*/@# , (  [email protected]@@@@@*@@@*@@ @@@@@@@@    //
//    @@@@@@@&*@@# .&@@@@*@@@@(  *       (     @@@@@@@@@@@@@@@@@@@@@@@   *@/.( #. @  @    .  &@@(.# / ,  @@ @@@(@ @#@@ @@@@@@@    //
//    @@@@@@@,@@( ,&@@@@ @@       @        ,  ,@@@@@@@@@@@@@@@@@@@@@@@@ @  @@@@ %  @ &        &@(   /(%.* @@ @@@/@@@#@@ @@@@@@    //
//    @@@@@@ @@%@@@@@@@[email protected]@      @%            #@@@@@@@@@@@@@@@@@@@@@@@@@ @  # (. &  @(         , * &% (@@(*&@@@@@@@[email protected]@@@[email protected]@@@@    //
//    @@@@@/@@.%/@ @@@[email protected]@      @*        /@@@@&@@@@@@@@&. &@@@@@@@@@@@@@& & .( /, @  ,    (/    ( /(#@@.%  %@@*@@&@@@@@@,@@@@@    //
//    @@@@@ @&((@(@@@*&@@    (.        %,@ %,@@[email protected]@@@&%@@@@#  #@%@@@@@@@@@/ & .( #  @/   %.       [email protected] (  .((,@@,@@@ @@@[email protected]@ @@@@    //
//    @@@@##@/    @@@ @@   ,  ( .*      [email protected] *@& (@@@@@(%/&  ,  &@@@@@@@@@@.                   @@,&/( %  ( %@  @@ @@@@%@@@@[email protected]@@@    //
//    @@@@*@@&@&.%@@%(@#         #   .(  % @@@ %@@@@@@@@@@@@&&@@@@@@@@@#                (@@@@@   #   #% . ,  (@ @@@@@@@@@%&@@@    //
//    @@@@[email protected]@@*,.%@@*@@,    [email protected]       ,(*(,#@@*/@@@@@@@@@@@@@@@@@@@@@@@          *&@@@@@@@@#       ([email protected],   #  [email protected],@@@ @@%/@@(@@@    //
//    @@@@ @@[email protected]@(%@@,@@,%            * (, @&@@/@@@@@@@@@@@@@@@@@@@@@     %@@@@@@@@@@@@@.         % # (   #/   @*&@@@@@@@@@[email protected]@@    //
//    @@@@ @@@(/@@@@/@@*     /     @@     &@*@#@@@@@@@@@@@@@@(@@@@&(@@@@@@@@@@@@@@@%   #@@      % / ,   .*.  [email protected],@@@ @,&/@@,@@@    //
//    @@@@,@@ @[email protected],@@&/@&       #@@          @@@@@@@@@@@@@@/%@@@@/@@@/     .#@@@@,%&,   ,%%,&    % . / , * /  (@ @@@@@@@@@#%@@@    //
//    @@@@%#@@@@/%@@@ @@        [email protected]             %@@@@@@@@@@@@@     [email protected]@@.         .%@/    /@(  #. %    .. *  , @@[email protected]@&.  @@@@@@@@    //
//    @@@@@ @@*,@,@@@(%@%                      [email protected]@@@@@@@@..       [email protected]@@@@         *@%.    %@*   ** /*  ,     /@,@/   *&@@@[email protected]@@@    //
//    @@@@@(&@@@@@@@@@ @@.            *,        /@@@@@@@. ,%&#@&(%&@@@@@@@        (@/    /@#.  .#@..( .%    @@@@@# @@ @@,@@@@@    //
//    @@@@@@ @@ @ @@@@@ @@             (  @@@%[email protected] @@@@@@ /@@@@@@%*.,@@@@@@@@@   .  .&@@,&@/.  * (&  (. .    @@[email protected]@@  *@@@&*@@@@@    //
//    @@@@@@@ @@&@%*&@@@ @@@            ,,(      @@,@@@((@@@@       & @@@@@@@#  %#    # *(  ( ,(    [email protected]    @@ @@@ &///@@#@@@@@@    //
//    @@@@@@@@[email protected]@,@@#(@@@ @@/                    @@@@ ,%#@@@@@@@@@& & ,. %@@@@@(    %  /* ,(    .(      [email protected]&,@@& #@&#@@ @@@@@@@    //
//    @@@@@@@@@ @@@@@@*@@@,@@@   %@@/       *    @@@@@@   @%(*%,&(( & *  [email protected] ,@@@@    #(.   .%, *@      @@,&@@(&@@,&@@ @@@@@@@@    //
//    @@@@@@@@@@ @@ @@@@@@@@ @@# /        *   #@@@@@@@@@@#          & / (  .    @@@    /%/   /#*     *@@ @@@[email protected] @[email protected]@@[email protected]@@@@@@@@    //
//    @@@@@@@@@@@,@@@@@@@@@@@#[email protected]@(           @@@ @@@@@@@@@@/ %      & (%           (@ .   (.      .,@@ @@@# *@&*@@*#@@@@@@@@@@    //
//    @@@@@@@@@@@@@ @@@@@@@@@@@%[email protected]@@  *#   @@@@  @@@@@@@@@@@@@@@    &&@ @ .        ..      *     %@@ @@@@*[email protected]@ @@@ @@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@//@@@@@@@@@@@@ &@@/  &@@@@   *@@@@@@@@@@@@@%  %./           *     &       ,@@(,@@@%@@@@@@@@ @@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@*(@@@@@@@@@@@@% @@@@@@@     /@@@@@@@@@@@ [email protected]@@                 (      (@@# @@@@%@@/ @@@@.%@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@(,@@@@@@@@@@@@@@ (@@@% /   [email protected]@@@@@@@@@@@@@&    ./           ,* #@@@.,@@@@& @@ #@@#@ &@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@ ,@@@@@. @@@@@@@@@@@@@@               &@@@@ ,@@@@@@@@@   @@(%#@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@#@@@@@@@@@@@@@@@@@@@, /@@@@@@@@@@@@@@&  .,*(%@@@@@@&, /@@@@@@@@@%&@@@& /@#@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@% @@@@@@@@@@@@@@@@[email protected]@@@@&#.   ,,*/***,.   %%@@@@@@@@@@@@@@@@@@*# &% @@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@, @@@@@@@@@@@  ,  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@& #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@# /@@@@@@&  @*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@. #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#, #(@(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                                                                //
//                                                                                                                                //
//                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract KGBSEC is ERC721Creator {
    constructor() ERC721Creator("KGB Secrets by Daniel Estulin", "KGBSEC") {}
}
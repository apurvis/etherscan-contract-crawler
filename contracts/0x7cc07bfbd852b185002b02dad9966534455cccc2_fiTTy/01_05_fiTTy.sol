// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Wild Weird West..
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    SSSSSSSSSSSSSSSSSSSSSSSSSS#############S#####@@####################@#@@####@@@@######@@@#@    //
//    %SSSS#SSSSSSSSSSSSSSSS##########################@########################@@@@@@######@@@@@    //
//    %%%%SSSSSSSSSSSSSSSSSSSSSSSSSSSSS##############@@########################@@@@@@@####@#@@@@    //
//    %%%%%SSSS%SSSSSSSSSSSSSSSSSSSSSS###############@#######@@###########SSSS%%S###############    //
//    %%%%%%%SS%%%%SSSS%%%S#S%SSSSSS####SSSS###############S############SSS%??*;+%SSS###########    //
//    %%%%%%SS%%%%%%%%%%%%S##S%%%%%SSSS#SSSSSSS%SSSSSSSSSSSS#######SSSSSSS%???**++;?%%SSSSS#####    //
//    %%%%%%%%%%%%%??%%%%%%S%%%?????%%%%%%%%%??*??%%%%???%SSSS####SSSSSSS%%????**+;;+**+;:;;+%S%    //
//    %%%%%%%%%%%%???%%%????????****++*???***??*+**********?%SSSS%%%%%%%%%%????**++;::,,,,,,,*++    //
//    %%SS%%%%%%%?%%%%%???*****+;;;++;:+???*?%%?**+++++++++++++**??%%%%%%%%????*++**+;;:::::,,,,    //
//    ?%%%%%%%?%%?%%%?*+++++;;;;;;;:::::;*?S#S?****+**++;++;;;+***%%%%%%%?*????*++*??*++++::,,,,    //
//    **??????????***;;**??*;;::;::;+***S##S*:,;*+**+***???**??%%%%%%%%?%SSSS??*****?**?***+;:::    //
//    *?************+;;*?*++*?*++*%?S#@@@##%?*:,::;*++*?%?%%%%%%%%%%%%%?S##@#??%SS??%???**++;:::    //
//    +****+++++*******??????**??%SS######@@@#S%*;;;;+;*%?%%%%%%%%%S#@@##@@@@###%?**????*++;::::    //
//    *****+;+++++++*????%S%??%SSS###########@@@S%?+:,,+?%%%%???%???%#@@@@@@#S?;;+*???*?*++;::::    //
//    ?*********+++;++?SS??S#@@@##SS#@@@#SSSSS#@@S%?:,:***?***++*+;+;;;??%S%*?+:;;*????*++;;::::    //
//    ???*********++++S?:,*@@@@####@@@@@@#S##S####S%?:,:;+******+;:,:::;+*%%%*:::+**??**++;;:::;    //
//    ??*????*??**+++++,;%#?+%[email protected]@@#@@@@@@@@@S#####%%?:,,,;*???****+*+::,+***+;+?%S%?**++;;;;::;    //
//    **+++++;;;;:::,:+%SS?;*S#S##@@@@@@@@@@@#S##@@#S#%:,,:+****????S#S%*+?%?*S#@#S%%%*;;;;;;:::    //
//    ;;;+++;::::::;+?%%??**##S%SS?***%#@@@@@@###@@@###%::,:+*?*?%S######SSS#@@@@@##SS%+;;;;;:::    //
//    ++++++++;+;+*?%%%%%%S#S*++++??;,;%#@@#@@@#@@@@@@##%;,,:+?S##@@#SS##########S%####S?+;;;:,:    //
//    ;;;;;+++*????????????%%?*+++;;**;+%####@@@@@@@@@#S#?,;*?%#######S#####SSSSS%?%%SS#@S+;;:;;    //
//    +**+;*???*****??*******??****+;;+*?%[email protected]@@@#@###@#@@;*%%%S#########SSSSSSS%**?;+*%S#?;;;++    //
//    ??****??********+****+++***+:,:;;;**?%[email protected]#@@#SSS##@@@**%[email protected]@#######SSS#SS##?+**+++SS%%?++++    //
//    ?************+++**+++;++++;+;:,,,,*%[email protected]@@@@#SSSS#@@#SSS###SSSSSS####[email protected]@@%*%?*+%@@#S??+**    //
//    ?*************+++;;;+;+++;::::,,,;*S#[email protected]@@@@@@##SSS#@@@#@@########@#SS#####S%%?SS#@@##??**?    //
//    ?**?**???***+++;;;;;;;;++++;:,,,,;%%@@@@@@#SSS%%%%S##@@@###@@@@##SS########S?%#@#%%%%?****    //
//    *???*??????*++;;;;;;;;;+++*+;+;,,+S*%[email protected]@#@#SS%??%S#####@@@######SS##S##SSSSSSS#@@#?******?    //
//    ?????*******++;;;;;;;;+++++**?*+;?++?##S#@@@############@@@@@S%%SS#S%%%%%%SSS#@@@@#%*****?    //
//    ?????**+++++++;;:;;++++++++****;+?*?SS?%##@@@@@@@#######@@@@@@#%S##S%****?%S#S#@@@@@S%?***    //
//    ???*****+++*+++++++++++******+::???%%?SSS#@@@@@@@@@@@@@@@@@@@@@@@##S%?*:;+*%#@#S#@@@@@S***    //
//    ?????******???*;;;;;;;;;;+++:::*S?*??%%S#@@@@@@@@@@@@@@@@@@@@@@@@@S%%?**?%??%#@#%SS#@@S***    //
//    ????????*****#S??****??%%SS%:%%%S%*?%SS#@@@@@@@@@@@@@@@@@@@###@#@@@S%%[email protected]@##%%[email protected]???%S#?**    //
//    ????????????%%S#@@##S%%SSS##**S#%S+;+?S#@#@@@@@@@@@@@@@@@@@#SSS#####%[email protected]@#S%SS%%#%????%S**    //
//    ?%#@S%%%%%%[email protected]@@@@@@@####S#%*SS%?+++%S#@#####@@@@@@@@@@@@#S###S####[email protected]@#%%##S%SS%%?%%%%*    //
//    %%SS####S%???*#@@@@@@@@@@@@@@@SS#S%%?%%%#S%SS%[email protected]@@@@@@@@@@@@@@@@##@@#%[email protected]@#%%S#SSS%%S%%SS%?    //
//    %%%%%%%SSS%%%%#@#SSSS###SS###@@@##%##SS#%??%%#@@@@##@@@@@@@@@@@@@@@@@SS#@#S%S##SSS?*?%***?    //
//    %%%%%%%%?%%%%[email protected]@#%%%%%%S#######@@@#S##@S**%S#######@@@@@@@@@@@@@@@@@@SS#@##%%@@##@#S?*+***    //
//    %%%%%%%%%%%[email protected]#SS%%%??*[email protected]@@@@@@@#S#%?%#@@#SS##@@##@@@@@@@@@@@@@@@@#S###S?%@###@@@@?;+**    //
//    %%%%%%%%%%%%S#@S%?*;::,,;+*?S#@#@@@@#%S#@@@###@@@#S#S#@@@#@@@@@@@@@@@@SS##S%%SSSS#@@@@%;;+    //
//    %%%%%%?%%%[email protected]@@@%+;;;+++*?%%%SS#@@@@@###@@@@@@@@#SS%SS###########@@@@@@[email protected]#%??%SSS#@####?;;    //
//    %??%%%%%%[email protected]@@S%%%%%%%?S##@@@@@@@@@##@@@@@@@#%%%%?%%SS#SSSS##S###@@@#[email protected]##S%?S###@#SSS%?;:    //
//    %??%%%%%SSSS#@@??*+*??%%[email protected]@@@@@@###@@@@@@####S????????%%?%%SSSS###S###%S##S%S#@@@##S%%?++;    //
//    %???????%%%%SS??+;;:*?%S#@@@#SS%%%#@@#S%????%%?***+**++++**??%%S%SSS#@SSS##[email protected]@@##S%???++;    //
//    ??*+*+;;+**?*;**+;::*?%%SSS%%?%%S#@@%???%%%%?%%%S#*;;;:::::;;+*?%SSS#@S%S##S#@@@#SS%?***+:    //
//    ?+;:,::::,:::,,++,,;???%%%%%%?%#@@@@%???????%%%%?+;:::::::;;;;+*%SS#@@%%S##@@@@@#S%%?**+:,    //
//    ?**?*+;+;;;,,:::::;*???%%%%%%%%%S#@@S***++++;:::,,,,,,,,::;;+++?%S###%%###@@@@@@#S%%?*+::,    //
//    SSS%%%?????****+++*??%%%%%%?????%%#@@S?*+::::,,,....,,,,,,,,:*%%S#####@@@@@@@@@@#S%%?+:,::    //
//    S%S%%%%%????******??????????%%????%%@@@S?++;:::,:;:,,:::,,.:?S#@@@@@@@@@@@@@@@@@#%%?+,.;;;    //
//    S%%%%%%%??%???*??????????****??????*%@@@@S*+++;++++++;;:;:;[email protected]@@@@@@@@@@@@@@@#[email protected]@#%%?;,;+;;    //
//    S%%%%????%**%%%%%?%%%%%%%+;??%????***[email protected]@@@S????+;;;+;;;;;,*@@@@@@@@@@@@@@@S+,,[email protected]@S%?;;*;;;    //
//    %???%%*?%%?*???%%%%S%%%%%*;+***+:::;*?%%S#@@@@%**:;;;,,,,.;#@@@@@@@@@@@?+:,,,,,[email protected]%?*+*::;    //
//    ***+++*%%%%%?????%%%%%%??%%?*+;:,,,,+*****%##%?+;,,::,,,,,,+#@@@@@@@@#;..,:,::,:%#S%**?;:;    //
//    ,,:;;:;+***????*???*%%%%????%%*+++;::;;;;;;;;+++;,,;;:;;;;+;[email protected]@@@@@@*:::,,:;:::;SS%??%*:;    //
//    :::;;;;;;;;;+***+++****?????%?%%%?**;:,,,,,,,,::::;;;;+;;++;;*@@#@@##+:;::::;;;;;+#S%%%+:;    //
//    ::,:,,::,::,,:;;;;;;;;;;;*?%%%??%?*+++;;;::::;;;;;;;;;;;;++;;;S#SSSS#S;:::::;;::::*@#S%;:;    //
//    ,,,,,..,,,,,,,,.,,,::,,,:;;****??***+++++++++++;;;;;;;;;;;;;;;;%S%%%S#S;::::::::::;S##S::;    //
//    ........,,,,.,,,....,,,,:::::::::;++********++++;;;;;;::;;;;;;;;*???%#@S;::::::::::%@@S::;    //
//    ..................,,,,..,,,,,,::,,,:::::;:;;;+++;;;;;;::::;;:::::+***?##*:;::::::::+#@#+;;    //
//    ...................,,......,,,,,:,,,,,,,,,,,::::;;;;;::::::::::::+++***;:;++;;;;+++:[email protected]@?:;    //
//    ........................................,,,:,,.:;::::::;;;;;::::+;++*+:::;;;;;;;;++;*@@S;;    //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract fiTTy is ERC721Creator {
    constructor() ERC721Creator("The Wild Weird West..", "fiTTy") {}
}
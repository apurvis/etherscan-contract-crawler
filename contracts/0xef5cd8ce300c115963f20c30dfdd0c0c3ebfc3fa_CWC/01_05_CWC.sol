// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Curtis Cardwell
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                           //
//                                                                                                                           //
//                                                                                                                           //
//      ____  _   _  ____   _____  ___  ____     ____     _     ____   ____  __        __ _____  _      _                    //
//     / ___|| | | ||  _ \ |_   _||_ _|/ ___|   / ___|   / \   |  _ \ |  _ \ \ \      / /| ____|| |    | |                   //
//    | |    | | | || |_) |  | |   | | \___ \  | |      / _ \  | |_) || | | | \ \ /\ / / |  _|  | |    | |                   //
//    | |___ | |_| ||  _ <   | |   | |  ___) | | |___  / ___ \ |  _ < | |_| |  \ V  V /  | |___ | |___ | |___                //
//     \____| \___/ |_| \_\  |_|  |___||____/   \____|/_/   \_\|_| \_\|____/    \_/\_/   |_____||_____||_____|               //
//                                                                                                                           //
//    ...................................................................................................................    //
//    ...................................................................................................................    //
//    ......................................................:;+*%?+;:....,...............................................    //
//    ................................................,;;**[email protected]@@@@@@@@*S%S#?:,............................................    //
//    ........................................:;;*?SS%[email protected]@@@@@@@@@@@@@@@@@@@@?%%?*+:......................................    //
//    .....................................;[email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@S?+,.....................................    //
//    .................................,,[email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#%*;:....................................    //
//    ..............................,:%#[email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#,...................................    //
//    ............................;[email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@?**?:...................................    //
//    ..........................,[email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+........................................    //
//    ..........................*@@@@@@@@@@@@@@@@@@@@@######@@@@@@@@@@@@@@@@@@@S,........................................    //
//    .........................;@@@@@@@@@@#SS###@##S%%??%%S##@@@@@@@@@@@@@@@@@@S,........................................    //
//    [email protected]@@@@@##S%?*+***?**?%%%%SSSSSS##@@@@@@@@@@@@@@@?.........................................    //
//    ........................,[email protected]@@@#S%%??**;:;+++++***?%SSSSS####@@@@@@@@@@@?:;.........................................    //
//    [email protected]@@@##S%%???*;;;;;:;;;;+*????%%SS############S*...........................................    //
//    ........................%@####%SS%%*;;;:;++;;;;+++*??*??%%SSSSSSSSSSS%%+,..........................................    //
//    ........................*%**%?+**++::::::++;+?%S#@###S%%%%%%%%SSS%SS%%?*:..........................................    //
//    ........................:+;:+*+++;:,::::::;*SS##S#@@@@@@#S%%%%%%%%%%%??*;,.........................................    //
//    ......................,,;::;;++*;,,,::::,:;++;+++****%S###S%%%%%%??%%??*+:.........................................    //
//    ....................,:;:+?;:++*+:,,,,::::::::::;++***?SS##S%%??????%%SS%%+.........................................    //
//    ...................,+%*,,::,**+:,,,,::;;+;:;;+*?%SSS###@##S%?????%SS##@@@#:........................................    //
//    ...................,?*:,;:..+%;,,,::::+*?**?%%##@@@@@@@@@#??*++*S#@@#S??%%,........................................    //
//    ...................,+:,;%S:.+%;,,,:::;++???*?*?S#@@@@@@@@S???*[email protected]@@@@#S%*,.........................................    //
//    ....................;:*S#S;,;+;:,,:::;;+********?S#@@@@@##SS%%%%@@@@@@@S:..........................................    //
//    ....................,:+SS?,,,::,,,,::;;+++++*?%%%%%%SSSSSSS%%SS%%@@@@#S+,..........................................    //
//    .....................;:,*%:,,,,,,,,::::;;;;;+?%SSS%%%%%%%%%%SSS#%%##S%?;...........................................    //
//    .....................,:,,,,,,,,,,,,,,::::;;;+*?%SSSSS%??%S?***%%%?*%%?+;,..........................................    //
//    .......................,,,:,,,,,,,,,:::::;;;++*??%%S####SS%?;;;+*?+*?*++,..........................................    //
//    .........................,,,,,,,,,,,:::::++;;;;+?%S#@@#*;;+*;;:;+***%*++,..........................................    //
//    ...........................,,,,,:,,,,:::::;::;;+?%S#@@#%%S##SS??SSS%%**;...........................................    //
//    ...........................,,,,,,,:,:::::::;;++**?%SS#@@@@#SS###@##S?**:...........................................    //
//    ...........................,,,,,,:;::;;:;;;;****??%%SS###@@@@@#@@SSS??*,...........................................    //
//    ............................,,,,,:::;++:::;;+*SSSS####@@@@@@#@@#@#SSS%:............................................    //
//    .......................,...,,,,::::;;**+:;;;[email protected]##@@@@#SS##########@#S*.............................................    //
//    ......................:,....,,:::;;++***+;;;+?#@@#%S###@@@@@@@@@@@#@%,.............................................    //
//    .....................,,....,,,::::;+**+++;;+*%S#S*+++??%S#@@@@@@@@@S:..............................................    //
//    ....................,,......,,,;+:,:;+;;++;+*SS#S?+;**?%S##@@@##S##;...............................................    //
//    ..................,,,.,,....,,,:+*+::;*?**+*%#@##%*+**?S#@@@@##[email protected]*................................................    //
//    .................:+,.,,,,...,,,::;??*+?%%??S#S####%?**[email protected]@@S%%[email protected]#+:,..............................................    //
//    ................,;*?*;:,,,,,,,,,::;*SS%SSSSSSSS#####SSSSSS##%?%#@#S%*;,............................................    //
//    ............,;:*%S##@@#%*:,,,,,,:;+*%S###########S#@########SS#@#S%SS*+;;,.........................................    //
//    ..........,;?++%#@@@@@@@@#%+:,,:::;+?%[email protected]@@@@@@@##@@@@@@@@@@@@@@%%#%*S%;++?:........................................    //
//    ........:+%##%%SS##@@@@@@@@@#%*;;;;+*%%%%S##@@@@@@@@@@@@@@@@@@?+*?S?+%S+;+S+.......................................    //
//    ......:?%;%#@@###@#@@@@@@@@@@@@@#%????%????***??*?%*+++%@@@#[email protected]@++**?*;%%;:+#+......................................    //
//    ....:*S#S+;%#@@@@@@@@@@@@@@@@@@@@@@@####SS%?+;;;:::;*?%#@@@S*%@#;;*+*+:??;:*S:.....................................    //
//    ..:?S#####%?SS#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##SS%SS#@@@@@#SS*+%@S:;+++;:;*;,*?,....................................    //
//    ,;+*?%SS#@@@@####@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#S+:+?%@?:;;++;,;*::*;....................................    //
//    %%+++++?%SS##@@@##@@@@@#@@@@@@@###@@@@@@@@@@@@@@@@@@@####S+:+:?S%S+:;+++:::;,::....................................    //
//    S?*?S###########@#S#@@@@@##@@@@@@##SS#@@@@@@@@@@@@@######%;;+::%%%%;:;++;:,::,,,...................................    //
//    ;*%SS#@@@@@@@@@@@@S%[email protected]@@@@###@@@@@@@S%%S#@@@@##@@@@@@@@@#%?*;::*?*??::;++;:,::,,,..................................    //
//    :+S#@@@@@@@@@@@@@@@@S%#@@@@@#S#@@@@@@#S%?%#@@@#SS#@@@@@@@##S?++++*;++::;++::,:,,,,.................................    //
//    *;+S#@@@@@@@@@@@@@@@@#%[email protected]@@@@@S%[email protected]@@@@@#S?*%#@@@#SS#####@###S%*+;;;:*:;:;+;:,,,,,::................................    //
//    #S?*%#@@@@@@@##@@@@@@@@%%#@@@@@#%?S#@@@@@#S??%S#@###S%%S###SSS??*+*;;;;;:;;::,,,,,::...............................    //
//    @@@#SS##@@@@@#####@@@@@@S%#@@@@@@S??S#@@@@@#%???S#####S%%%%%%%%??*?+;;;;;:;::,,,,,,;,..............................    //
//    @@@@@###[email protected]@@@@######@@@@@[email protected]@@@@@#%*?S##@@@@#%**?SS##SSS%?%?????***+;;:;;:;::,,,,,:;..............................    //
//    @@@@@@@@S%#@@@@@###S#@@@@@[email protected]@@@@@@%**%S####@#S%**?SSSSSSS%??**+++**++;;;:;::,,,,,,;:.............................    //
//    @@@@@@@@@S%@@@@@@###S#@@@@@%?##@@@@@@S???%%%%#@##S?+*?%SSSS%%?**+;+**+++:;;:::,,,,,,:;.............................    //
//                                                                                                                           //
//      ____  _   _  ____   _____  ___  ____     ____     _     ____   ____  __        __ _____  _      _                    //
//     / ___|| | | ||  _ \ |_   _||_ _|/ ___|   / ___|   / \   |  _ \ |  _ \ \ \      / /| ____|| |    | |                   //
//    | |    | | | || |_) |  | |   | | \___ \  | |      / _ \  | |_) || | | | \ \ /\ / / |  _|  | |    | |                   //
//    | |___ | |_| ||  _ <   | |   | |  ___) | | |___  / ___ \ |  _ < | |_| |  \ V  V /  | |___ | |___ | |___                //
//     \____| \___/ |_| \_\  |_|  |___||____/   \____|/_/   \_\|_| \_\|____/    \_/\_/   |_____||_____||_____|               //
//                                                                                                                           //
//    Original 1 0f 1 Art                                                                                                    //
//                                                                                                                           //
//                                                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract CWC is ERC721Creator {
    constructor() ERC721Creator("Curtis Cardwell", "CWC") {}
}
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

// name: Project Illuminati
// contract by: buildship.xyz

import "./ERC721Community.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                          //
//                                                                                                                                                                          //
//    ### ##   ### ##    ## ##      ####  ### ###   ## ##   #### ##             ####   ####     ####     ##  ###  ##   ##    ####   ###  ##    ##     #### ##    ####       //
//     ##  ##   ##  ##  ##   ##      ##    ##  ##  ##   ##  # ## ##              ##     ##       ##      ##   ##   ## ##      ##      ## ##     ##    # ## ##     ##        //
//     ##  ##   ##  ##  ##   ##      ##    ##      ##         ##                 ##     ##       ##      ##   ##  # ### #     ##     # ## #   ## ##     ##        ##        //
//     ##  ##   ## ##   ##   ##      ##    ## ##   ##         ##                 ##     ##       ##      ##   ##  ## # ##     ##     ## ##    ##  ##    ##        ##        //
//     ## ##    ## ##   ##   ##  ##  ##    ##      ##         ##                 ##     ##       ##      ##   ##  ##   ##     ##     ##  ##   ## ###    ##        ##        //
//     ##       ##  ##  ##   ##  ##  ##    ##  ##  ##   ##    ##                 ##     ##  ##   ##  ##  ##   ##  ##   ##     ##     ##  ##   ##  ##    ##        ##        //
//    ####     #### ##   ## ##    ## #    ### ###   ## ##    ####               ####   ### ###  ### ###   ## ##   ##   ##    ####   ###  ##  ###  ##   ####      ####       //
//                                                                                                                                                                          //
//                                                                                                                                                                          //
//                                                                                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

contract ILMNTI is ERC721Community {
    constructor() ERC721Community("Project Illuminati", "ILMNTI", 4444, 200, START_FROM_ONE, "ipfs://bafybeidtxntzoii4cqfqailkvm55hrpoxzbnc7cu5sp5igc3ax2ktggpom/",
                                  MintConfig(0.0069 ether, 5, 5, 0, 0xb97cA33391825187E59Eb66060ba6795e86E26e8, false, false, false)) {}
}
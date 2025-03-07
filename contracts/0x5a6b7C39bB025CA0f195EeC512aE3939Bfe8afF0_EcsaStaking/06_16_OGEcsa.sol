pragma solidity ^0.8.4;
// SPDX-License-Identifier: GPL-3.0-or-later

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * Created and owned by the staking contract. 
 *
 * It mints and burns OGEcsa as users stake/unstake
 */
contract OGEcsa is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("OGEcsa", "OG_ECSA") {
      // transferOwnership(address(0xf008153A449cA392b6F852E60F202aD9e620cb02));
    }

    function mint(address to, uint256 amount) external onlyOwner {
      _mint(to, amount);
    }
}
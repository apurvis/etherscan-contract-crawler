/*
 * SPDX-License-Identifier: MIT
 */

pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

import "./TokenSilo.sol";
import "../../ReentrancyGuard.sol";
import "../../../libraries/Token/LibTransfer.sol";

/*
 * @author Publius
 * @title SiloFacet handles depositing, withdrawing and claiming whitelisted Silo tokens.
 */
contract SiloFacet is TokenSilo {
    using SafeMath for uint256;
    using LibSafeMath32 for uint32;

    /*
     * Deposit
     */

    function deposit(
        address token,
        uint256 amount,
        LibTransfer.From mode
    ) external payable nonReentrant updateSilo {
        amount = LibTransfer.receiveToken(
            IERC20(token),
            amount,
            msg.sender,
            mode
        );
        _deposit(msg.sender, token, amount);
    }

    /*
     * Withdraw
     */

    function withdrawDeposit(
        address token,
        uint32 season,
        uint256 amount
    ) external payable updateSilo {
        _withdrawDeposit(msg.sender, token, season, amount);
    }

    function withdrawDeposits(
        address token,
        uint32[] calldata seasons,
        uint256[] calldata amounts
    ) external payable updateSilo {
        _withdrawDeposits(msg.sender, token, seasons, amounts);
    }

    /*
     * Claim
     */

    function claimWithdrawal(
        address token,
        uint32 season,
        LibTransfer.To mode
    ) external payable nonReentrant {
        uint256 amount = _claimWithdrawal(msg.sender, token, season);
        LibTransfer.sendToken(IERC20(token), amount, msg.sender, mode);
    }

    function claimWithdrawals(
        address token,
        uint32[] calldata seasons,
        LibTransfer.To mode
    ) external payable nonReentrant {
        uint256 amount = _claimWithdrawals(msg.sender, token, seasons);
        LibTransfer.sendToken(IERC20(token), amount, msg.sender, mode);
    }

    /*
     * Transfer
     */

    function transferDeposit(
        address recipient,
        address token,
        uint32 season,
        uint256 amount
    ) external payable nonReentrant updateSilo {
        // Need to update the recipient's Silo as well.
        _update(recipient);
        _transferDeposit(msg.sender, recipient, token, season, amount);
    }

    function transferDeposits(
        address recipient,
        address token,
        uint32[] calldata seasons,
        uint256[] calldata amounts
    ) external payable nonReentrant updateSilo {
        // Need to update the recipient's Silo as well.
        _update(recipient);
        _transferDeposits(msg.sender, recipient, token, seasons, amounts);
    }

    /*
     * Silo
     */

    function update(address account) external payable {
        _update(account);
    }

    function plant() external payable returns (uint256 beans) {
        return _plant(msg.sender);
    }

    function claimPlenty(address account) external payable {
        _claimPlenty(account);
    }

    /*
     * Update Unripe Deposits
     */

    function enrootDeposits(
        address token,
        uint32[] calldata seasons,
        uint256[] calldata amounts
    ) external nonReentrant updateSilo {
        // First, remove Deposits because every deposit is in a different season, we need to get the total Stalk/Seeds, not just BDV
        AssetsRemoved memory ar = removeDeposits(msg.sender, token, seasons, amounts);

        // Get new BDV and calculate Seeds (Seeds are not Season dependent like Stalk)
        uint256 newBDV = LibTokenSilo.beanDenominatedValue(token, ar.tokensRemoved);
        uint256 newStalk;

        // Iterate through all seasons, redeposit the tokens with new BDV and summate new Stalk.
        for (uint256 i; i < seasons.length; ++i) {
            uint256 bdv = amounts[i].mul(newBDV).div(ar.tokensRemoved); // Cheaper than calling the BDV function multiple times.
            LibTokenSilo.addDeposit(
                msg.sender,
                token,
                seasons[i],
                amounts[i],
                bdv
            );
            newStalk = newStalk.add(
                bdv.mul(s.ss[token].stalk).add(
                    LibSilo.stalkReward(
                        bdv.mul(s.ss[token].seeds),
                        season() - seasons[i]
                    )
                )
            );
        }

        uint256 newSeeds = newBDV.mul(s.ss[token].seeds);

        // Add new Stalk
        LibSilo.depositSiloAssets(
            msg.sender,
            newSeeds.sub(ar.seedsRemoved),
            newStalk.sub(ar.stalkRemoved)
        );
    }

    function enrootDeposit(
        address token,
        uint32 _season,
        uint256 amount
    ) external nonReentrant updateSilo {
        // First, remove Deposit and Redeposit with new BDV
        uint256 ogBDV = LibTokenSilo.removeDeposit(
            msg.sender,
            token,
            _season,
            amount
        );
        emit RemoveDeposit(msg.sender, token, _season, amount); // Remove Deposit does not emit an event, while Add Deposit does.
        uint256 newBDV = LibTokenSilo.beanDenominatedValue(token, amount);
        LibTokenSilo.addDeposit(msg.sender, token, _season, amount, newBDV);

        // Calculate the different in BDV. Will fail if BDV is lower.
        uint256 deltaBDV = newBDV.sub(ogBDV);

        // Calculate the new Stalk/Seeds associated with BDV and increment Stalk/Seed balances
        uint256 deltaSeeds = deltaBDV.mul(s.ss[token].seeds);
        uint256 deltaStalk = deltaBDV.mul(s.ss[token].stalk).add(
            LibSilo.stalkReward(deltaSeeds, season() - _season)
        );
        LibSilo.depositSiloAssets(msg.sender, deltaSeeds, deltaStalk);
    }
}
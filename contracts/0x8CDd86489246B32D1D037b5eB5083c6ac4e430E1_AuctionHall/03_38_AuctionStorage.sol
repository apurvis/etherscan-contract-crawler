// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.6.12;

import "../interfaces/IShorterBone.sol";
import "../interfaces/v1/IAuctionHall.sol";
import "../interfaces/v1/IVaultButler.sol";
import "../interfaces/v1/ITradingHub.sol";
import "../interfaces/v1/IPoolGuardian.sol";
import "../interfaces/governance/ICommittee.sol";
import "../oracles/IPriceOracle.sol";
import "../interfaces/uniswapv2/IUniswapV2Router02.sol";
import "./TitanCoreStorage.sol";

contract AuctionStorage is TitanCoreStorage {
    struct PositionInfo {
        address strToken;
        address stakedToken;
        address stableToken;
        uint256 stakedTokenDecimals;
        uint256 stableTokenDecimals;
        uint256 totalSize;
        uint256 unsettledCash;
        uint256 closingBlock;
        ITradingHub.PositionState positionState;
    }

    struct Phase1Info {
        uint256 bidSize;
        uint256 liquidationPrice;
        bool isSorted;
        bool flag; // If the debts have been cleared
    }

    struct Phase2Info {
        bool flag; // If the debts have been cleared
        bool isWithdrawn;
        address rulerAddr;
        uint256 debtSize;
        uint256 usedCash;
        uint256 dexCoverReward;
    }

    struct BidItem {
        bool takeBack;
        uint64 bidBlock;
        address bidder;
        uint256 bidSize;
        uint256 priorityFee;
    }

    uint256 public phase1MaxBlock;
    uint256 public auctionMaxBlock;
    bool internal _initialized;
    address public dexCenter;
    address public ipistrToken;
    ICommittee public committee;
    IPoolGuardian public poolGuardian;
    ITradingHub public tradingHub;
    IPriceOracle public priceOracle;

    mapping(address => bytes) public phase1Ranks;
    mapping(address => Phase1Info) public phase1Infos;
    mapping(address => Phase2Info) public phase2Infos;

    /// @notice { Position => BidItem[] } During Phase 1
    mapping(address => BidItem[]) public allPhase1BidRecords;
}
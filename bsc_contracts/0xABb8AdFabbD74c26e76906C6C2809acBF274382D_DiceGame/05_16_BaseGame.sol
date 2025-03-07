// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "../interfaces/IBankroll.sol";
import "../interfaces/IMinBetManager.sol";
import "../interfaces/IGasStation.sol";
import "../interfaces/VRFCoordinatorV2InterfaceExtended.sol";

error NotAGuardian(address caller);
error GameHalted();
error InvalidPriceFeed();
error InvalidVRFCost();
error FailedVRFHarvest();

abstract contract BaseGame is Ownable, VRFConsumerBaseV2 {
    using SafeERC20 for IERC20;
    /* Events */
    event UpdateChainlinkSettings(
        address coordinator,
        uint64 subscriptionId,
        bytes32 keyHash,
        uint256 vrfPremium
    );

    event UpdateGameSettings(uint256 houseEdge, uint256 bankrollShare);
    event UpdateBankroll(address newBankrollAddress);
    event UpdateMinBet(address newMinBetAddress);
    event UpdateFeeRouter(address newFeeRouterAddress);
    event UpdateVRFHarvester(address newHarvester);

    event RequestRandomness(uint256 requestId, uint32 randomValues);
    event ReceiveRandomness(uint256 requestId, uint256[] randomValues);

    /* Harvest events */
    event DeductVRFFee(uint256 paid, uint256 est);
    event HarvestVRFFees(uint256 amount);

    /* Guardian Events */
    event UpdateGuardian(address guardianAddress, bool state);
    event EmergencyHalted();
    event EmergencyStopped();

    /* Chainlink Settings */
    // see https://docs.chain.link/docs/vrf-contracts/#configurations
    VRFCoordinatorV2InterfaceExtended vrfCoordinator;

    struct ChainlinkConfig {
        uint64 subscriptionId;
        bytes32 keyHash;
        uint256 vrfPremium; // in bp
    }
    ChainlinkConfig public chainlinkConfig = ChainlinkConfig(0, 0, 10_200);

    struct SettingStruct {
        uint256 houseEdge;
        uint256 bankrollShare;
    }
    SettingStruct public settings = SettingStruct(500, 6666);

    IBankroll public bank;
    address public feeRouter;
    AggregatorV3Interface public linkPriceFeed; //price feed for LINK -> native token so we can est in gas token.
    address public vrfHarvester;
    /* Guardian */
    bool public halted = false;
    mapping(address => bool) public guardians;
    /* Guardian */

    constructor(
        uint64 _subId,
        address _vrfCoordinator,
        bytes32 _keyHash,
        address _linkPriceFeed,
        address bankAddress,
        address feeRouterAddress
    ) VRFConsumerBaseV2(_vrfCoordinator) {
        chainlinkConfig.subscriptionId = _subId;
        chainlinkConfig.keyHash = _keyHash;
        vrfCoordinator = VRFCoordinatorV2InterfaceExtended(_vrfCoordinator);

        bank = IBankroll(bankAddress);
        feeRouter = feeRouterAddress;
        linkPriceFeed = AggregatorV3Interface(_linkPriceFeed);
    }

    /* Emergency Stuff */
    modifier IsNotHalted() {
        if (halted) {
            revert GameHalted();
        }
        _;
    }

    modifier onlyGuardian() {
        if (guardians[msg.sender] == false) {
            revert NotAGuardian(msg.sender);
        }
        _;
    }

    function editGuardian(address _address, bool _state) external onlyOwner {
        guardians[_address] = _state;
        emit UpdateGuardian(_address, _state);
    }

    function emergencyHalt() external onlyGuardian {
        halted = true;
        emit EmergencyHalted();
    }

    function resetEmergencyHalt() external onlyOwner {
        halted = false;
        emit EmergencyStopped();
    }

    /* Emergency Stuff */

    /* Owner */
    function setChainlinkSettings(
        address _vrfCoordinator,
        uint64 _subId,
        bytes32 _keyHash,
        uint256 _vrfPremium
    ) external onlyOwner {
        vrfCoordinator = VRFCoordinatorV2InterfaceExtended(_vrfCoordinator);
        chainlinkConfig.subscriptionId = _subId;
        chainlinkConfig.keyHash = _keyHash;
        chainlinkConfig.vrfPremium = _vrfPremium;

        emit UpdateChainlinkSettings(
            _vrfCoordinator,
            chainlinkConfig.subscriptionId,
            chainlinkConfig.keyHash,
            chainlinkConfig.vrfPremium
        );
    }

    function setGameSettings(uint256 _edge, uint256 _share) external onlyOwner {
        settings.houseEdge = _edge;
        settings.bankrollShare = _share;

        emit UpdateGameSettings(settings.houseEdge, settings.bankrollShare);
    }

    function changeBank(address newBank) external onlyOwner {
        bank = IBankroll(newBank);

        emit UpdateBankroll(newBank);
    }

    function changeFeeRouter(address newRouter) external onlyOwner {
        feeRouter = newRouter;

        emit UpdateFeeRouter(feeRouter);
    }

    function changeVRFHarvester(address newHarvester)
        external
        onlyOwner
    {
        vrfHarvester = newHarvester;
        emit UpdateVRFHarvester(newHarvester);
    }

    function recoverTokens(address token) external onlyOwner {
        if (token == address(0)) {
            payable(msg.sender).transfer(address(this).balance);
        } else {
            IERC20(token).safeTransfer(
                msg.sender,
                IERC20(token).balanceOf(address(this))
            );
        }
    }

    /* Owner */

    /* VRF */
    function harvestVRFCost() external {
		require(vrfHarvester != address(0),"No Harvester");
        uint256 balance = address(this).balance;
        IGasStation(vrfHarvester).topUp{value: balance}(
            address(vrfCoordinator),
            chainlinkConfig.subscriptionId,
            msg.sender
        );
        emit HarvestVRFFees(balance);
    }

    function _deductVRFCost(uint256 sentVRFGas, uint256 callbackGasLimit)
        internal
    {
        uint256 VRFCost = getVRFCost(callbackGasLimit);

        if (sentVRFGas < (VRFCost - ((VRFCost * 5) / 100))) {
            revert InvalidVRFCost();
        }

        emit DeductVRFFee(sentVRFGas, VRFCost);
    }

    function _requestRandomValues(
        uint32 callbackGas,
        uint32 randomValues
    ) internal returns (uint256 requestId) {
		( uint16 minimumRequestConfirmations, , , ) = vrfCoordinator.getConfig();
        requestId = vrfCoordinator.requestRandomWords(
            chainlinkConfig.keyHash,
            chainlinkConfig.subscriptionId,
            minimumRequestConfirmations,
            callbackGas,
            randomValues
        );
        emit RequestRandomness(requestId, randomValues);

        return requestId;
    }

    function getVRFCost(uint256 callbackGasLimit)
        public
        view
        returns (uint256)
    {
        (, int256 unitsPerLink, , , ) = linkPriceFeed.latestRoundData();
        if (unitsPerLink == 0) revert InvalidPriceFeed();
        (uint32 fulfillmentFlatFeeLinkPPMTier1, , , , , , , , ) = vrfCoordinator
            .getFeeConfig();
        ( , , , uint32 gasAfterPaymentCalculation) = vrfCoordinator.getConfig();

        uint256 callGasCost = tx.gasprice *
            (gasAfterPaymentCalculation + callbackGasLimit);
        uint256 vrfCost = (1e12 *
            uint256(fulfillmentFlatFeeLinkPPMTier1) *
            uint256(unitsPerLink)) / 1e18;

        return ((callGasCost + vrfCost) * (chainlinkConfig.vrfPremium)) / 10_000;
    }
    /* VRF */
}
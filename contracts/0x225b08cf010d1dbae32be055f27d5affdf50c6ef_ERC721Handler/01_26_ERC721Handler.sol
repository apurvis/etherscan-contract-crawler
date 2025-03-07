pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "../interfaces/IDepositExecute.sol";
import "./HandlerHelpers.sol";
import "../ERC721Safe.sol";
import "../ERC721MinterBurnerPauser.sol";
import "@openzeppelin/contracts/introspection/ERC165Checker.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Metadata.sol";


/**
    @title Handles ERC721 deposits and deposit executions.
    @author ChainSafe Systems.
    @notice This contract is intended to be used with the Bridge contract.
 */
contract ERC721Handler is IDepositExecute, HandlerHelpers, ERC721Safe {
    using ERC165Checker for address;

    bytes4 private constant _INTERFACE_ERC721_METADATA = 0x5b5e139f;

    struct DepositRecord {
        address _tokenAddress;
        uint8    _lenDestinationRecipientAddress;
        uint8   _destinationChainID;
        bytes32 _resourceID;
        bytes   _destinationRecipientAddress;
        address _depositer;
        uint    _tokenID;
        bytes   _metaData;
    }

    // DepositNonce => Deposit Record
    mapping (uint8 => mapping (uint64 => DepositRecord)) public _depositRecords;

    /**
        @param bridgeAddress Contract address of previously deployed Bridge.
        @param initialResourceIDs Resource IDs are used to identify a specific contract address.
        These are the Resource IDs this contract will initially support.
        @param initialContractAddresses These are the addresses the {initialResourceIDs} will point to, and are the contracts that will be
        called to perform various deposit calls.
        @param burnableContractAddresses These addresses will be set as burnable and when {deposit} is called, the deposited token will be burned.
        When {executeProposal} is called, new tokens will be minted.

        @dev {initialResourceIDs} and {initialContractAddresses} must have the same length (one resourceID for every address).
        Also, these arrays must be ordered in the way that {initialResourceIDs}[0] is the intended resourceID for {initialContractAddresses}[0].
     */
    constructor(
        address bridgeAddress,
        bytes32[] memory initialResourceIDs,
        address[] memory initialContractAddresses,
        address[] memory burnableContractAddresses
    ) public {
        require(initialResourceIDs.length == initialContractAddresses.length,
            "initialResourceIDs and initialContractAddresses len mismatch");

        _bridgeAddress = bridgeAddress;

        for (uint256 i = 0; i < initialResourceIDs.length; i++) {
            _setResource(initialResourceIDs[i], initialContractAddresses[i]);
        }

        for (uint256 i = 0; i < burnableContractAddresses.length; i++) {
            _setBurnable(burnableContractAddresses[i]);
        }
    }

    /**
        @param depositNonce This ID will have been generated by the Bridge contract.
        @param destId ID of chain deposit will be bridged to.
        @return DepositRecord which consists of:
        - _tokenAddress Address used when {deposit} was executed.
        - _destinationChainID ChainID deposited tokens are intended to end up on.
        - _resourceID ResourceID used when {deposit} was executed.
        - _lenDestinationRecipientAddress Used to parse recipient's address from {_destinationRecipientAddress}
        - _destinationRecipientAddress Address tokens are intended to be deposited to on desitnation chain.
        - _depositer Address that initially called {deposit} in the Bridge contract.
        - _tokenID ID of ERC721.
        - _metaData Optional ERC721 metadata.
    */
    function getDepositRecord(uint64 depositNonce, uint8 destId) external view returns (DepositRecord memory) {
        return _depositRecords[destId][depositNonce];
    }

    /**
        @notice A deposit is initiatied by making a deposit in the Bridge contract.
        @param destinationChainID Chain ID of chain token is expected to be bridged to.
        @param depositNonce This value is generated as an ID by the Bridge contract.
        @param depositer Address of account making the deposit in the Bridge contract.
        @param data Consists of: {resourceID}, {tokenID}, {lenDestinationRecipientAddress},
        and {destinationRecipientAddress} all padded to 32 bytes.
        @notice Data passed into the function should be constructed as follows:
        tokenID                                     uint256    bytes    0  - 32
        destinationRecipientAddress     length      uint256    bytes    32 - 64
        destinationRecipientAddress                   bytes    bytes    64 - (64 + len(destinationRecipientAddress))
        @notice If the corresponding {tokenAddress} for the parsed {resourceID} supports {_INTERFACE_ERC721_METADATA},
        then {metaData} will be set according to the {tokenURI} method in the token contract.
        @dev Depending if the corresponding {tokenAddress} for the parsed {resourceID} is
        marked true in {_burnList}, deposited tokens will be burned, if not, they will be locked.
     */
    function deposit(bytes32    resourceID,
                    uint8       destinationChainID,
                    uint64      depositNonce,
                    address     depositer,
                    bytes       calldata data
                    ) external override onlyBridge {
        uint         lenDestinationRecipientAddress;
        uint         tokenID;
        bytes memory destinationRecipientAddress;
        bytes memory metaData;

        assembly {

            // Load tokenID from data + 32
            tokenID := calldataload(0xC4)

            // Load length of recipient address from data + 96
            lenDestinationRecipientAddress := calldataload(0xE4)
            // Load free mem pointer for recipient
            destinationRecipientAddress := mload(0x40)
            // Store recipient address
            mstore(0x40, add(0x20, add(destinationRecipientAddress, lenDestinationRecipientAddress)))

            // func sig (4) + destinationChainId (padded to 32) + depositNonce (32) + depositor (32) +
            // bytes lenght (32) + resourceId (32) + tokenId (32) + length (32) = 0xE4

            calldatacopy(
                destinationRecipientAddress,    // copy to destinationRecipientAddress
                0xE4,                           // copy from calldata after destinationRecipientAddress length declaration @0xE4
                sub(calldatasize(), 0xE4)       // copy size (calldatasize - (0xE4 + 0x20))
            )
        }

        address tokenAddress = _resourceIDToTokenContractAddress[resourceID];
        require(_contractWhitelist[tokenAddress], "provided tokenAddress is not whitelisted");

        // Check if the contract supports metadata, fetch it if it does
        if (tokenAddress.supportsInterface(_INTERFACE_ERC721_METADATA)) {
            IERC721Metadata erc721 = IERC721Metadata(tokenAddress);
            metaData = bytes(erc721.tokenURI(tokenID));
        }

        if (_burnList[tokenAddress]) {
            burnERC721(tokenAddress, depositer, tokenID);
        } else {
            lockERC721(tokenAddress, depositer, address(this), tokenID);
        }

        _depositRecords[destinationChainID][depositNonce] = DepositRecord(
            tokenAddress,
            uint8(lenDestinationRecipientAddress),
            uint8(destinationChainID),
            resourceID,
            destinationRecipientAddress,
            depositer,
            tokenID,
            metaData
        );
    }

    /**
        @notice Proposal execution should be initiated when a proposal is finalized in the Bridge contract.
        by a relayer on the deposit's destination chain.
        @param data Consists of {tokenID}, {resourceID}, {lenDestinationRecipientAddress},
        {destinationRecipientAddress}, {lenMeta}, and {metaData} all padded to 32 bytes.
        @notice Data passed into the function should be constructed as follows:
        tokenID                                     uint256    bytes    0  - 32
        destinationRecipientAddress     length      uint256    bytes    32 - 64
        destinationRecipientAddress                   bytes    bytes    64 - (64 + len(destinationRecipientAddress))
        metadata                        length      uint256    bytes    (64 + len(destinationRecipientAddress)) - (64 + len(destinationRecipientAddress) + 32)
        metadata                                      bytes    bytes    (64 + len(destinationRecipientAddress) + 32) - END
     */
    function executeProposal(bytes32 resourceID, bytes calldata data) external override onlyBridge {
        uint256         tokenID;
        bytes  memory   destinationRecipientAddress;
        bytes  memory   metaData;

        assembly {
            tokenID    := calldataload(0x64)


            // set up destinationRecipientAddress
            destinationRecipientAddress        := mload(0x40)              // load free memory pointer
            let lenDestinationRecipientAddress := calldataload(0x84)

            // set up metaData
            // 0xA4 is a combination of 0x24 (position of {data} in calldata) and
            // 0x80 is the relative position of the {metadata} length in {data}
            let lenMeta := calldataload(add(0xA4, lenDestinationRecipientAddress))

            mstore(0x40, add(0x40, add(destinationRecipientAddress, lenDestinationRecipientAddress))) // shift free memory pointer

            calldatacopy(
                destinationRecipientAddress,                             // copy to destinationRecipientAddress
                0x84,                                                    // copy from calldata after destinationRecipientAddress length declaration @0x84
                sub(calldatasize(), add(0x84, add(0x20, lenMeta)))       // copy size (calldatasize - (0xC4 + the space metaData takes up))
            )

            // metadata has variable length
            // load free memory pointer to store metadata
            metaData := mload(0x40)

            // incrementing free memory pointer
            mstore(0x40, add(0x40, add(metaData, lenMeta)))

            // metadata is located at (0x84 + 0x20 + lenDestinationRecipientAddress) in calldata
            let metaDataLoc := add(0xA4, lenDestinationRecipientAddress)

            // in the calldata, metadata is stored @0x124 after accounting for function signature and the depositNonce
            calldatacopy(
                metaData,                           // copy to metaData
                metaDataLoc,                       // copy from calldata after metaData length declaration
                sub(calldatasize(), metaDataLoc)   // copy size (calldatasize - metaDataLoc)
            )
        }

        bytes20 recipientAddress;

        assembly {
            recipientAddress := mload(add(destinationRecipientAddress, 0x20))
        }

        address tokenAddress = _resourceIDToTokenContractAddress[resourceID];
        require(_contractWhitelist[address(tokenAddress)], "provided tokenAddress is not whitelisted");

        if (_burnList[tokenAddress]) {
            mintERC721(tokenAddress, address(recipientAddress), tokenID, metaData);
        } else {
            releaseERC721(tokenAddress, address(this), address(recipientAddress), tokenID);
        }
    }

    /**
        @notice Used to manually release ERC721 tokens from ERC721Safe.
        @param tokenAddress Address of token contract to release.
        @param recipient Address to release token to.
        @param tokenID The ERC721 token ID to release.
     */
    function withdraw(address tokenAddress, address recipient, uint tokenID) external override onlyBridge {
        releaseERC721(tokenAddress, address(this), recipient, tokenID);
    }
}
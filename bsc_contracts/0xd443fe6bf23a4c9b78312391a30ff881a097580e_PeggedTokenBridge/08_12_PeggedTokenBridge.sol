// SPDX-License-Identifier: GPL-3.0-only

pragma solidity 0.8.9;

import "../interfaces/ISigsVerifier.sol";
import "../interfaces/IPeggedToken.sol";
import "../libraries/PbPegged.sol";
import "../safeguard/Pauser.sol";
import "../safeguard/VolumeControl.sol";
import "../safeguard/DelayedTransfer.sol";

/**
 * @title The bridge contract to mint and burn pegged tokens
 * @dev Work together with OriginalTokenVault deployed at remote chains.
 */
contract PeggedTokenBridge is Pauser, VolumeControl, DelayedTransfer {
    ISigsVerifier public immutable sigsVerifier;

    mapping(bytes32 => bool) public records;

    mapping(address => uint256) public minBurn;
    mapping(address => uint256) public maxBurn;

    event Mint(
        bytes32 mintId,
        address token,
        address account,
        uint256 amount,
        uint64 refChainId,
        bytes32 refId,
        address depositor
    );
    event Burn(bytes32 burnId, address token, address account, uint256 amount, address withdrawAccount);
    event MinBurnUpdated(address token, uint256 amount);
    event MaxBurnUpdated(address token, uint256 amount);

    constructor(ISigsVerifier _sigsVerifier) {
        sigsVerifier = _sigsVerifier;
    }

    /**
     * @notice Mint tokens triggered by deposit at a remote chain's OriginalTokenVault
     */
    function mint(
        bytes calldata _request,
        bytes[] calldata _sigs,
        address[] calldata _signers,
        uint256[] calldata _powers
    ) external whenNotPaused {
        bytes32 domain = keccak256(abi.encodePacked(block.chainid, address(this), "Mint"));
        sigsVerifier.verifySigs(abi.encodePacked(domain, _request), _sigs, _signers, _powers);
        PbPegged.Mint memory request = PbPegged.decMint(_request);
        bytes32 mintId = keccak256(
            // len = 20 + 20 + 32 + 20 + 8 + 32 = 132
            abi.encodePacked(
                request.account,
                request.token,
                request.amount,
                request.depositor,
                request.refChainId,
                request.refId
            )
        );
        require(records[mintId] == false, "record exists");
        records[mintId] = true;
        _updateVolume(request.token, request.amount);
        uint256 delayThreshold = delayThresholds[request.token];
        if (delayThreshold > 0 && request.amount > delayThreshold) {
            _addDelayedTransfer(mintId, request.account, request.token, request.amount);
        } else {
            IPeggedToken(request.token).mint(request.account, request.amount);
        }
        emit Mint(
            mintId,
            request.token,
            request.account,
            request.amount,
            request.refChainId,
            request.refId,
            request.depositor
        );
    }

    /**
     * @notice Burn tokens to trigger withdrawal at a remote chain's OriginalTokenVault
     * @param _token local token address
     * @param _amount locked token amount
     * @param _withdrawAccount account who withdraw original tokens on the remote chain
     * @param _nonce user input to guarantee unique depositId
     */
    function burn(
        address _token,
        uint256 _amount,
        address _withdrawAccount,
        uint64 _nonce
    ) external whenNotPaused {
        require(_amount > minBurn[_token], "amount too small");
        require(maxBurn[_token] == 0 || _amount <= maxBurn[_token], "amount too large");
        bytes32 burnId = keccak256(
            // len = 20 + 20 + 32 + 20 + 8 + 8 = 108
            abi.encodePacked(msg.sender, _token, _amount, _withdrawAccount, _nonce, uint64(block.chainid))
        );
        require(records[burnId] == false, "record exists");
        records[burnId] = true;
        IPeggedToken(_token).burn(msg.sender, _amount);
        emit Burn(burnId, _token, msg.sender, _amount, _withdrawAccount);
    }

    function executeDelayedTransfer(bytes32 id) external whenNotPaused {
        delayedTransfer memory transfer = _executeDelayedTransfer(id);
        IPeggedToken(transfer.token).mint(transfer.receiver, transfer.amount);
    }

    function setMinBurn(address[] calldata _tokens, uint256[] calldata _amounts) external onlyGovernor {
        require(_tokens.length == _amounts.length, "length mismatch");
        for (uint256 i = 0; i < _tokens.length; i++) {
            minBurn[_tokens[i]] = _amounts[i];
            emit MinBurnUpdated(_tokens[i], _amounts[i]);
        }
    }

    function setMaxBurn(address[] calldata _tokens, uint256[] calldata _amounts) external onlyGovernor {
        require(_tokens.length == _amounts.length, "length mismatch");
        for (uint256 i = 0; i < _tokens.length; i++) {
            maxBurn[_tokens[i]] = _amounts[i];
            emit MaxBurnUpdated(_tokens[i], _amounts[i]);
        }
    }
}
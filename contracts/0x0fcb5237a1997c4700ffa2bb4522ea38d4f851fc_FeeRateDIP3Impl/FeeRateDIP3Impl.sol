/**
 *Submitted for verification at Etherscan.io on 2022-09-10
*/

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

/**
 * @title Ownable
 * @author DODO Breeder
 *
 * @notice Ownership related functions
 */
contract InitializableOwnable {
    address public _OWNER_;
    address public _NEW_OWNER_;
    bool internal _INITIALIZED_;

    // ============ Events ============

    event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // ============ Modifiers ============

    modifier notInitialized() {
        require(!_INITIALIZED_, "DODO_INITIALIZED");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == _OWNER_, "NOT_OWNER");
        _;
    }

    // ============ Functions ============

    function initOwner(address newOwner) public notInitialized {
        _INITIALIZED_ = true;
        _OWNER_ = newOwner;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        emit OwnershipTransferPrepared(_OWNER_, newOwner);
        _NEW_OWNER_ = newOwner;
    }

    function claimOwnership() public {
        require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
        emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
        _OWNER_ = _NEW_OWNER_;
        _NEW_OWNER_ = address(0);
    }
}



/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}




/**
 * @title SafeMath
 * @author DODO Breeder
 *
 * @notice Math operations with safety checks that revert on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "MUL_ERROR");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "DIVIDING_ERROR");
        return a / b;
    }

    function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 quotient = div(a, b);
        uint256 remainder = a - quotient * b;
        if (remainder > 0) {
            return quotient + 1;
        } else {
            return quotient;
        }
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SUB_ERROR");
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "ADD_ERROR");
        return c;
    }

    function sqrt(uint256 x) internal pure returns (uint256 y) {
        uint256 z = x / 2 + 1;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}





interface ICrowdPooling {
    function _QUOTE_RESERVE_() external view returns (uint256);
    function getShares(address user) external view returns (uint256);
}

interface IFee {
    function getUserFee(address user) external view returns (uint256);
}

interface IQuota {
    function getUserQuota(address user) external view returns (int);
}

interface IPoolHeartBeat {
    function isPoolHeartBeatLive(address pool) external view returns(bool);
}

interface IPool {
    function version() external pure returns (string memory);
    function _LP_FEE_RATE_() external view returns (uint256);
    function _BASE_RESERVE_() external view returns (uint);
    function _QUOTE_RESERVE_() external view returns (uint);
    function _K_() external view returns (uint);
}

contract FeeRateDIP3Impl is InitializableOwnable {
    using SafeMath for uint256;

    // ============ Storage  ============

    uint256 public _LP_MT_RATIO_ = 25;

    struct CPPoolInfo {
        address quoteToken;
        int globalQuota;
        address feeAddr;
        address quotaAddr;
    }

    mapping(address => CPPoolInfo) public cpPools;
    mapping(address => uint256) public specPoolList;
    mapping (address => bool) public isAdminListed;
    address public poolHeartBeat;

    // ============ Events =============
    event AddAdmin(address admin);
    event RemoveAdmin(address admin);

    // ============ Ownable Functions ============
    
    function addCpPoolInfo(address cpPool, address quoteToken, int globalQuota, address feeAddr, address quotaAddr) external {
        require(isAdminListed[msg.sender], "ACCESS_DENIED");
        CPPoolInfo memory cpPoolInfo =  CPPoolInfo({
            quoteToken: quoteToken,
            feeAddr: feeAddr,
            quotaAddr: quotaAddr,
            globalQuota: globalQuota
        });
        cpPools[cpPool] = cpPoolInfo;
    }

    function setCpPoolInfo(address cpPool, address quoteToken, int globalQuota, address feeAddr, address quotaAddr) external onlyOwner {
        cpPools[cpPool].quoteToken = quoteToken;
        cpPools[cpPool].feeAddr = feeAddr;
        cpPools[cpPool].quotaAddr = quotaAddr;
        cpPools[cpPool].globalQuota = globalQuota;
    }

    function setLpMtRatio(uint256 newLpMtRatio) external onlyOwner {
        _LP_MT_RATIO_ = newLpMtRatio;
    }


    function setSpecPoolList (address poolAddr, uint256 mtFeeRate) public onlyOwner {
        specPoolList[poolAddr] = mtFeeRate;
    }

    function addAdminList (address userAddr) external onlyOwner {
        isAdminListed[userAddr] = true;
        emit AddAdmin(userAddr);
    }

    function removeAdminList (address userAddr) external onlyOwner {
        isAdminListed[userAddr] = false;
        emit RemoveAdmin(userAddr);
    }

    function setPoolHeartBeat (address newPoolHeartBeat) public onlyOwner {
        poolHeartBeat = newPoolHeartBeat;
    }

    // ============ View Functions ============

    function getFeeRate(address pool, address user) external view returns (uint256) {
        try IPool(pool).version() returns (string memory poolVersion) {
            bytes32 hashPoolVersion = keccak256(abi.encodePacked(poolVersion));
            if(_kjudge(hashPoolVersion)) {
                uint k = IPool(pool)._K_();
                uint baseReserve = IPool(pool)._BASE_RESERVE_();
                uint quoteReserve = IPool(pool)._QUOTE_RESERVE_();
                require(!(k==0 && (baseReserve ==0 || quoteReserve == 0)), "KJUDGE_ERROR");
            }

            if (poolHeartBeat != address(0) && !IPoolHeartBeat(poolHeartBeat).isPoolHeartBeatLive(pool)) {
                return 10**18 - IPool(pool)._LP_FEE_RATE_() - 1;
            }

            if(specPoolList[pool] != 0) {
                return specPoolList[pool];
            }

            if(_cp(hashPoolVersion)) {
                CPPoolInfo memory cpPoolInfo = cpPools[pool];
                address quoteToken = cpPoolInfo.quoteToken;
                if(quoteToken == address(0)) {
                    return 0;
                }else {
                    uint256 userInput = IERC20(quoteToken).balanceOf(pool).sub(ICrowdPooling(pool)._QUOTE_RESERVE_());
                    uint256 userStake = ICrowdPooling(pool).getShares(user);
                    address feeAddr = cpPoolInfo.feeAddr;
                    address quotaAddr = cpPoolInfo.quotaAddr;
                    int curQuota = cpPoolInfo.globalQuota;
                    if(quotaAddr != address(0))
                        curQuota = IQuota(quotaAddr).getUserQuota(user);

                    require(curQuota == -1 || (curQuota != -1 && int(userInput.add(userStake)) <= curQuota), "DODOFeeImpl: EXCEED_YOUR_QUOTA");

                    if(feeAddr == address(0)) {
                        return 0;
                    } else {
                        return IFee(feeAddr).getUserFee(user);
                    }
                }
            } else if(_dip3dvm(hashPoolVersion) || _dip3dsp(hashPoolVersion)) {
                uint256 lpFeeRate = IPool(pool)._LP_FEE_RATE_();
                uint256 mtFeeRate = lpFeeRate.mul(_LP_MT_RATIO_).div(100);
                if(lpFeeRate.add(mtFeeRate) >= 10**18) {
                    return 0;
                } else {
                    return mtFeeRate;
                }
            } else {
                return 0;
            }
        } catch (bytes memory) {
            return 0;
        }
    }

    function getCPInfoByUser(address pool, address user) external view returns (bool isHaveCap, int curQuota, uint256 userFee) {
        CPPoolInfo memory cpPoolInfo = cpPools[pool];
        if(cpPoolInfo.quoteToken == address(0)) {
            isHaveCap = false;
            curQuota = -1;
            userFee = 0;
        }else {
            address quotaAddr = cpPoolInfo.quotaAddr;
            curQuota = cpPoolInfo.globalQuota;
            if(quotaAddr != address(0))
                curQuota = IQuota(quotaAddr).getUserQuota(user);
        
            if(curQuota == -1) {
                isHaveCap = false;
            }else {
                isHaveCap = true;
                uint256 userStake = ICrowdPooling(pool).getShares(user);
                if(uint256(curQuota) >= userStake) {
                    curQuota = int(uint256(curQuota).sub(userStake));
                }else {
                    curQuota = 0;
                }
            }

            address feeAddr = cpPoolInfo.feeAddr;
            if(feeAddr == address(0)) {
                userFee =  0;
            } else {
                userFee = IFee(feeAddr).getUserFee(user);
            }
        }
    }

    function _cp(bytes32 _hashPoolVersion) internal pure returns (bool) {
        return (_hashPoolVersion == keccak256(abi.encodePacked("CP 1.0.0")) || _hashPoolVersion == keccak256(abi.encodePacked("CP 2.0.0")));
    }

    function _dip3dvm(bytes32 _hashPoolVersion) internal pure returns (bool){
        return (_hashPoolVersion == keccak256(abi.encodePacked("DVM 1.0.2")) || _hashPoolVersion == keccak256(abi.encodePacked("DVM 1.0.3")));
    }

    function _dip3dsp(bytes32 _hashPoolVersion) internal pure returns (bool){
        return (_hashPoolVersion == keccak256(abi.encodePacked("DSP 1.0.1")) || _hashPoolVersion == keccak256(abi.encodePacked("DSP 1.0.2")));
    }

    function _kjudge(bytes32 _hashPoolVersion) internal pure returns (bool) {
        return (_hashPoolVersion == keccak256(abi.encodePacked("DVM 1.0.2")) || _hashPoolVersion == keccak256(abi.encodePacked("DSP 1.0.1")) || _hashPoolVersion == keccak256(abi.encodePacked("DPP 1.0.0")) || _hashPoolVersion == keccak256(abi.encodePacked("DPP Advanced 1.0.0")));
    }
}
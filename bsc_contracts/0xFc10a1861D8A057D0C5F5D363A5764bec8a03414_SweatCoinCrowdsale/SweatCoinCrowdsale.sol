/**
 *Submitted for verification at BscScan.com on 2022-10-28
*/

/**
 *Submitted for verification at BscScan.com on 2022-10-26
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin/contracts/token/ERC721/IERC721.sol


// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;


/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin/contracts/utils/math/SafeMath.sol


// OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

// File: @openzeppelin/contracts/utils/Address.sol


// OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)

pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly
                /// @solidity memory-safe-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 */
interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.0;


/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol


// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;




/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     */
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

// File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol


// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)

pragma solidity ^0.8.0;




/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    function safePermit(
        IERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: TokensVesting.sol


pragma solidity 0.8.12;





contract TokensVesting is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for ERC20;

    event NewVest(address indexed _from, address indexed _to, uint256 _value);
    event UnlockVest(address indexed _holder, uint256 _value);
    event RevokeVest(address indexed _holder, uint256 _refund);

    struct Vest {
        uint256 value;
        uint256 transferred;
        bool revokable;
        bool revoked;
    }

    address public crowdsaleAddress;
    ERC20 public sweatToken;
    uint256 public totalVesting;
    uint256 public totalLimit;
    uint256 public RELEASES = 3;
    uint256 duration = 30 days; // TO BE MODIFIED
    uint256 finishOfVest = RELEASES * duration;
    address[] public vesters;
    mapping(address => Vest) public vests;
    uint256 start;
    uint256 finish;

    modifier onlyCrowdsale() {
        require(_msgSender() == crowdsaleAddress);
        _;
    }

    constructor(address _sweatToken) {
        require(
            _sweatToken != address(0),
            "TokenVestings: invalid zero address for token provided"
        );

        sweatToken = ERC20(_sweatToken);
        totalLimit = 150e6 * (10**sweatToken.decimals());
    }

    function setCrowdsaleAddress(address _crowdsaleAddress) public onlyOwner {
        require(
            _crowdsaleAddress != address(0),
            "TokenVestings: invalid zero address for crowdsale"
        );
        crowdsaleAddress = _crowdsaleAddress;
    }

    function vest(
        address _to,
        uint256 _value,
        bool _revokable
    ) public onlyCrowdsale {
        require(
            _to != address(0),
            "TokensVesting: invalid zero address for beneficiary!"
        );
        require(_value > 0, "TokensVesting: invalid value for beneficiary!");
        require(
            totalVesting.add(_value) <= totalLimit,
            "TokensVesting: total value exeeds total limit!"
        );

        if (vests[_to].value == 0) {
            vests[_to] = Vest({
                value: 0,
                transferred: 0,
                revokable: _revokable,
                revoked: false
            });
            vesters.push(_to);
        }

        vests[_to].value += _value;

        totalVesting = totalVesting.add(_value);

        emit NewVest(_msgSender(), _to, _value);
    }

    function revoke(address _holder) public onlyOwner {
        Vest storage vested = vests[_holder];

        require(vested.revokable, "TokensVesting: vested can not get revoked!");
        require(!vested.revoked, "TokensVesting: holder already revoked!");

        uint256 refund = vested.value.sub(vested.transferred);

        totalVesting = totalVesting.sub(refund);
        vested.revoked = true;
        sweatToken.safeTransfer(_msgSender(), refund);

        emit RevokeVest(_holder, refund);
    }

    function beneficiary(address _ben) public view returns (Vest memory) {
        return vests[_ben];
    }

    function startTheVesting(uint256 _start) public onlyCrowdsale {
        require(finish == 0, "TokensVesting: already started!");
        start = _start;
        finish = _start.add(finishOfVest);
    }

    function vestedTokens(address _holder, uint256 _time)
        public
        view
        returns (uint256)
    {
        if (start == 0) {
            return 0;
        }

        Vest memory vested = vests[_holder];
        if (vested.value == 0) {
            return 0;
        }

        return calculateVestedTokens(vested, _time);
    }

    function calculateVestedTokens(Vest memory _vested, uint256 _time)
        private
        view
        returns (uint256)
    {
        if (_time >= finish) {
            return _vested.value;
        }

        if (start > block.timestamp)
            return 0;

        uint256 initalUnlock = 2;
        uint256 timeLeftAfterStart = block.timestamp.sub(start);
        uint256 availableReleases = timeLeftAfterStart.div(duration) + initalUnlock;
        // with 2 unlocks, there are 3 + 2 releases (40% right away, 60% in 3 months)
        uint256 tokensPerRelease = _vested.value.div(RELEASES + initalUnlock);

        return availableReleases.mul(tokensPerRelease);
    }

    function unlockVestedTokens() public {
        require(start != 0, "TokensVesting: not started yet");
        Vest storage vested = vests[_msgSender()];
        require(vested.value != 0);
        require(!vested.revoked);

        uint256 vestedAmount = calculateVestedTokens(vested, block.timestamp);
        if (vestedAmount == 0) {
            return;
        }

        uint256 transferable = vestedAmount.sub(vested.transferred);
        if (transferable == 0) {
            return;
        }

        vested.transferred = vested.transferred.add(transferable);
        totalVesting = totalVesting.sub(transferable);
        sweatToken.safeTransfer(_msgSender(), transferable);

        emit UnlockVest(_msgSender(), transferable);
    }
}
// File: CrowdFunding.sol


pragma solidity ^0.8.0;






contract SweatCoinCrowdsale is Context {
    using SafeMath for uint256;
    using Address for address;
    using SafeERC20 for IERC20;
    using SafeERC20 for ERC20;

    ERC20 public sweatToken;

    address public busd = address(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);
    address private _owner;

    uint256 public startVesting;
    TokensVesting public vestingContract;

    uint256 public tokenAmountRateOne = 333;
    uint256 public tokenAmountRateTwo = 143;
    uint256 public tokenAmountRateThree = 100;
    uint256 public tokensRaised;
    uint256 private startCrowdsaleTime;
    uint256 public limitPhaseOne; // 100_000_000_000_000_000
    uint256 public limitPhaseTwo; // 50_000_000_000_000_000
    uint256 public limitPhaseThree;
    uint256 public minimumBuyAmount = 10 * 1e18;
    uint256 public BNBPrice = 280;
    bool public isIcoCompleted = false;
    bool public hasIcoPaused = false;

    bool public isIcoFirstRoundCompleted = false;
    bool public isIcoSecondRoundCompleted = false;
    uint256 public startSecondRoundTime;
    uint256 public startThirdRoundTime;

    event SweatTokenBuy(address indexed buyer, uint256 value, uint256 amount);

    modifier whenIcoCompleted() {
        require(isIcoCompleted);
        _;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    modifier onlyAfterStart() {
        require(
            block.timestamp >= startCrowdsaleTime,
            "Crowdsale: crowdsale not started yet"
        );
        _;
    }

    modifier onlyWhenNotPaused() {
        require(!hasIcoPaused, "Crowdsale: crowdsale has paused");
        _;
    }

    constructor(
        uint256 _startCrowdsaleTime,
        address _sweatToken,
        address payable _vestingContract
    ) {
        require(_startCrowdsaleTime >= 0, "Crowdsale: invalid time provided");
        require(
            _startCrowdsaleTime + 60 >= block.timestamp,
            "Crowdsale: can not start in past"
        );

        require(
            _sweatToken != address(0),
            "Crowdsale: invalid zero address for token provided"
        );

        require(
            _vestingContract != address(0),
            "Crowdsale: invalid zero address for vest provided"
        );
        startCrowdsaleTime = _startCrowdsaleTime;
        vestingContract = TokensVesting(_vestingContract);
        sweatToken = ERC20(_sweatToken);
        _owner = _msgSender();

        limitPhaseOne = 50_000_000 * (10**sweatToken.decimals()); //100M  // TO BE MODIFIED
        limitPhaseTwo = 100_000_000 * (10**sweatToken.decimals()); //50M  // TO BE MODIFIED
        limitPhaseThree = 175_000_000 * (10**sweatToken.decimals()); //50M  // TO BE MODIFIED
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "new owner is the zero address");
        _owner = newOwner;
    }

    function setBUSD(address _busd) public onlyOwner {
        require(_busd != address(0));
        busd = _busd;
    }

    function setBNBPrice(uint256 price) public onlyOwner {
        require(price > 0, "Crowdsale: price");
        BNBPrice = price;
    }

    function deposit(uint256 amount) public onlyOwner {
        sweatToken.safeTransferFrom(_msgSender(), address(this), amount);
    }

    function withdrawSweat() public onlyOwner {
        uint256 balance = sweatToken.balanceOf(address(this));
        sweatToken.safeTransfer(_msgSender(), balance);
    }

    function setStartCrowdsaleTime(uint256 _time) public onlyOwner {
        require(_time >= 0, "Crowdsale: invalid time provided");
        require(
            _time + 60 >= block.timestamp,
            "Crowdsale: can not start in past"
        );
        startCrowdsaleTime = _time;
    }

    function timeUntilCrowdsaleStarts() public view returns (uint256) {
        return startCrowdsaleTime;
    }

    function buy(uint256 _amount)
        public
        onlyAfterStart
        onlyWhenNotPaused
    {
        require(
            tokensRaised <= limitPhaseThree,
            "Crowdsale: reached the maximum amount"
        );

        uint256 tokensToBuy;

        if (tokensRaised < limitPhaseOne) {
            tokensToBuy = _getTokensAmount(_amount, tokenAmountRateOne);
            require(
                (_amount >= minimumBuyAmount) ||
                    (tokensToBuy >= (limitPhaseOne - tokensRaised)),
                "Crowdsale: insufficient balance for buying (minimum 10 busd)"
            );
            if (tokensRaised + tokensToBuy > limitPhaseOne) {
                // revert("Crowdsale: exceeds the maximum allowed limit");
                // adjust tokensToBuy
                tokensToBuy = limitPhaseOne.sub(tokensRaised);
                // set actual cost
                _amount = _getBUSDAmount(tokensToBuy, tokenAmountRateOne);
            }
        } else if (
            tokensRaised >= limitPhaseOne &&
            tokensRaised < limitPhaseTwo &&
            isIcoFirstRoundCompleted
        ) {
            require(
                startSecondRoundTime > 0 && block.timestamp >= startSecondRoundTime,
                "Crowdsale: second round not started!"
            );
            tokensToBuy = _getTokensAmount(_amount, tokenAmountRateTwo);
            require(
                (_amount >= minimumBuyAmount) ||
                    (tokensToBuy >= (limitPhaseTwo - tokensRaised)),
                "Crowdsale: insufficient balance for buying (minimum 10 busd)"
            );
            if (tokensRaised + tokensToBuy > limitPhaseTwo) {
                // revert("Crowdsale: exceeds the maximum allowed limit");
                // adjust tokensToBuy
                tokensToBuy = limitPhaseTwo.sub(tokensRaised);
                // set actual cost
                _amount = _getBUSDAmount(tokensToBuy, tokenAmountRateTwo);
            }
        } else if (tokensRaised >= limitPhaseTwo && tokensRaised < limitPhaseThree && isIcoSecondRoundCompleted) {
            require(
                startThirdRoundTime > 0 && block.timestamp >= startThirdRoundTime,
                "Crowdsale: third round not started!"
            );
            // public presale
            tokensToBuy = _getTokensAmount(_amount, tokenAmountRateThree);
            require(
                (_amount >= minimumBuyAmount) ||
                    (tokensToBuy >= (limitPhaseThree - tokensRaised)),
                "Crowdsale: insufficient balance for buying (minimum 10 busd)"
            );
            if (tokensRaised + tokensToBuy > limitPhaseThree) {
                // revert("Crowdsale: exceeds the maximum allowed limit");
                // adjust tokensToBuy
                tokensToBuy = limitPhaseThree.sub(tokensRaised);
                // set actual cost
                _amount = _getBUSDAmount(tokensToBuy, tokenAmountRateThree);
            }
        }

        require(
            tokensToBuy > 0,
            "Crowdsale: insufficient balance for buying (minimum 10 busd)"
        );

        IERC20(busd).safeTransferFrom(_msgSender(), owner(), _amount);
        sweatToken.safeTransfer(address(vestingContract), tokensToBuy);

        vestingContract.vest(_msgSender(), tokensToBuy, false);
        emit SweatTokenBuy(_msgSender(), _amount, tokensToBuy);

        tokensRaised += tokensToBuy;
        if (tokensRaised >= limitPhaseOne) {
            isIcoFirstRoundCompleted = true;
        }
        if (tokensRaised >= limitPhaseTwo) {
            isIcoSecondRoundCompleted = true;
        }
    }

    function buyNative() public payable onlyAfterStart onlyWhenNotPaused {
        require(
            tokensRaised <= limitPhaseThree,
            "Crowdsale: reached the maximum amount"
        );

        uint256 _amount = msg.value;
        uint256 busdAmount = _amount * BNBPrice;

        uint256 tokensToBuy = 0;

        if (tokensRaised < limitPhaseOne) {
            tokensToBuy = _getTokensAmount(busdAmount, tokenAmountRateOne);
            require(
                (busdAmount >= minimumBuyAmount) ||
                    (tokensToBuy >= (limitPhaseOne - tokensRaised)),
                "Crowdsale: insufficient balance for buying (minimum 10 busd)"
            );
            if (tokensRaised + tokensToBuy > limitPhaseOne) {
                // revert("Crowdsale: exceeds the maximum allowed limit");
                // adjust tokensToBuy
                tokensToBuy = limitPhaseOne.sub(tokensRaised);
                // set actual cost
                busdAmount = _getBUSDAmount(tokensToBuy, tokenAmountRateOne);
                _amount = busdAmount.div(BNBPrice);
            }
        } else if (
            tokensRaised >= limitPhaseOne &&
            tokensRaised < limitPhaseTwo &&
            isIcoFirstRoundCompleted
        ) {
            require(
                startSecondRoundTime > 0 && block.timestamp >= startSecondRoundTime,
                "Crowdsale: second round not started!"
            );
            tokensToBuy = _getTokensAmount(busdAmount, tokenAmountRateTwo);
            require(
                (busdAmount >= minimumBuyAmount) ||
                    (tokensToBuy >= (limitPhaseTwo - tokensRaised)),
                "Crowdsale: insufficient balance for buying (minimum 10 busd)"
            );
            if (tokensRaised + tokensToBuy > limitPhaseTwo) {
                // revert("Crowdsale: exceeds the maximum allowed limit");
                // adjust tokensToBuy
                tokensToBuy = limitPhaseTwo.sub(tokensRaised);
                // set actual cost
                busdAmount = _getBUSDAmount(tokensToBuy, tokenAmountRateTwo);
                _amount = busdAmount.div(BNBPrice);
            }
        }else if (tokensRaised >= limitPhaseTwo && tokensRaised < limitPhaseThree && isIcoSecondRoundCompleted) {
            require(
                startThirdRoundTime > 0 && block.timestamp >= startThirdRoundTime,
                "Crowdsale: third round not started!"
            );
            // public presale
            tokensToBuy = _getTokensAmount(_amount, tokenAmountRateThree);
            require(
                (_amount >= minimumBuyAmount) ||
                    (tokensToBuy >= (limitPhaseThree - tokensRaised)),
                "Crowdsale: insufficient balance for buying (minimum 10 busd)"
            );
            if (tokensRaised + tokensToBuy > limitPhaseThree) {
                // revert("Crowdsale: exceeds the maximum allowed limit");
                // adjust tokensToBuy
                tokensToBuy = limitPhaseThree.sub(tokensRaised);
                // set actual cost
                busdAmount = _getBUSDAmount(tokensToBuy, tokenAmountRateThree);
                _amount = busdAmount.div(BNBPrice);
            }
        }

        require(
            tokensToBuy > 0,
            "Crowdsale: cannot buy 0 zero tokens. presale round has ended already."
        );

        payable(owner()).transfer(_amount);
        if (_amount < msg.value){
            // refund the rest back to sender if _amount < msg.value
            payable(_msgSender()).transfer(msg.value.sub(_amount));
        }
        sweatToken.safeTransfer(address(vestingContract), tokensToBuy);

        vestingContract.vest(_msgSender(), tokensToBuy, false);
        emit SweatTokenBuy(_msgSender(), _amount, tokensToBuy);

        tokensRaised += tokensToBuy;
        if (tokensRaised >= limitPhaseOne) {
            isIcoFirstRoundCompleted = true;
        }
        if (tokensRaised >= limitPhaseTwo) {
            isIcoSecondRoundCompleted = true;
        }
    }    
    
    function _getBUSDAmount(uint256 _tokenAmount, uint256 _tokenAmountRate)
        public
        view
        returns (uint256)
    {
        // var _tokenAmount = _busdAmount.mul(oneSweatToken).div(1e18).mul(_tokenAmountRate)
        // convert to busd with correct decimals: .mul(1e18).div(1e9)
        uint256 oneSweatToken = (10**sweatToken.decimals());
        return _tokenAmount.div(_tokenAmountRate).mul(1e18).div(oneSweatToken);
    }

    function _getTokensAmount(uint256 _busdAmount, uint256 _tokenAmountRate)
        internal
        view
        returns (uint256)
    {
        // 1 Sweat Token = 1_000_000_000 => 1e9
        // 1 busd       = 1_000_000_000_000_000_000 => 1e18
        // (10^18) * (1*10^9) / (1*10^18) => 1 Sweat Token

        uint256 oneSweatToken = (10**sweatToken.decimals());
        uint256 amountOfTokens = _busdAmount.mul(oneSweatToken).div(1e18);

        return amountOfTokens.mul(_tokenAmountRate);
    }

    function getTokensAmount(uint256 _busdAmount, uint256 _tokenAmountRate)
        public
        view
        returns (uint256 tokensAmount)
    {
        tokensAmount = _getTokensAmount(_busdAmount, _tokenAmountRate);
    }

    function closeCrowdsale() public onlyOwner {
        isIcoCompleted = true;
        setStartVestingTime();
        vestingContract.startTheVesting(getStartVestingTime());
    }

    function togglePauseCrowdsale() public onlyOwner {
        hasIcoPaused = !hasIcoPaused;
    }

    function getPauseCrowdsaleState() public view returns (bool) {
        return hasIcoPaused;
    }

    function totalCrowdsale() public view returns (uint256) {
        return limitPhaseTwo;
    }

    function startSecondRound(uint256 _time) public onlyOwner {
        require(_time >= 0, "Crowdsale: invalid time provided");
        require(
            _time + 60 >= block.timestamp,
            "Crowdsale: can not start in past"
        );
        startSecondRoundTime = _time;
    }   
    
    function startThirdRound(uint256 _time) public onlyOwner {
        require(_time >= 0, "Crowdsale: invalid time provided");
        require(
            _time >= block.timestamp,
            "Crowdsale: can not start in past"
        );
        startThirdRoundTime = _time;
    }

    function has2ndRoundStarted() external view returns (bool) {
        return block.timestamp >= startSecondRoundTime && startSecondRoundTime > 0;
    }

    function has3rdRoundStarted() external view returns (bool) {
        return block.timestamp >= startThirdRoundTime && startThirdRoundTime > 0;
    }

    function withdraw() public whenIcoCompleted onlyOwner {
        (bool success, ) = payable(owner()).call{value: address(this).balance}(
            ""
        );
        require(success);
    }

    function setStartVestingTime() public onlyOwner {
        startVesting = block.timestamp + 24 hours;
    }

    function getStartVestingTime() public view returns (uint256) {
        return startVesting;
    }

    function getTotalBuyedTokens() public view returns (uint256) {
        return tokensRaised;
    }
}
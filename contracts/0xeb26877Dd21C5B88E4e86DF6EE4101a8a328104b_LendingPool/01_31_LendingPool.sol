// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;
pragma abicoder v2;

import {IERC20} from '../../dependencies/openzeppelin/contracts/IERC20.sol';
import {IERC20Detailed} from '../../dependencies/openzeppelin/contracts/IERC20Detailed.sol';
import {SafeERC20} from '../../dependencies/openzeppelin/contracts/SafeERC20.sol';
import {Address} from '../../dependencies/openzeppelin/contracts/Address.sol';
import {ILendingPoolAddressesProvider} from '../../interfaces/ILendingPoolAddressesProvider.sol';
import {IAToken} from '../../interfaces/IAToken.sol';
import {IVariableDebtToken} from '../../interfaces/IVariableDebtToken.sol';
import {IPriceOracleGetter} from '../../interfaces/IPriceOracleGetter.sol';
import {ISturdyAPRDataProvider} from '../../interfaces/ISturdyAPRDataProvider.sol';
import {IStableDebtToken} from '../../interfaces/IStableDebtToken.sol';
import {ILendingPool} from '../../interfaces/ILendingPool.sol';
import {IReserveInterestRateStrategy} from '../../interfaces/IReserveInterestRateStrategy.sol';
import {VersionedInitializable} from '../libraries/sturdy-upgradeability/VersionedInitializable.sol';
import {Helpers} from '../libraries/helpers/Helpers.sol';
import {Errors} from '../libraries/helpers/Errors.sol';
import {WadRayMath} from '../libraries/math/WadRayMath.sol';
import {PercentageMath} from '../libraries/math/PercentageMath.sol';
import {ReserveLogic} from '../libraries/logic/ReserveLogic.sol';
import {GenericLogic} from '../libraries/logic/GenericLogic.sol';
import {ValidationLogic} from '../libraries/logic/ValidationLogic.sol';
import {ReserveConfiguration} from '../libraries/configuration/ReserveConfiguration.sol';
import {UserConfiguration} from '../libraries/configuration/UserConfiguration.sol';
import {DataTypes} from '../libraries/types/DataTypes.sol';
import {LendingPoolStorage} from './LendingPoolStorage.sol';
import {UserConfiguration} from '../libraries/configuration/UserConfiguration.sol';
import {ReserveConfiguration} from '../libraries/configuration/ReserveConfiguration.sol';

/**
 * @title LendingPool contract
 * @dev Main point of interaction with an Sturdy protocol's market
 * - Users can:
 *   # Deposit
 *   # Withdraw
 *   # Borrow
 *   # Repay
 *   # Liquidate positions
 * - To be covered by a proxy contract, owned by the LendingPoolAddressesProvider of the specific market
 * - All admin functions are callable by the LendingPoolConfigurator contract defined also in the
 *   LendingPoolAddressesProvider
 * @author Sturdy, inspiration from Aave
 **/
contract LendingPool is VersionedInitializable, ILendingPool, LendingPoolStorage {
  using WadRayMath for uint256;
  using PercentageMath for uint256;
  using SafeERC20 for IERC20;
  using ReserveLogic for DataTypes.ReserveData;
  using ReserveConfiguration for DataTypes.ReserveConfigurationMap;
  using UserConfiguration for DataTypes.UserConfigurationMap;

  uint256 private constant LENDINGPOOL_REVISION = 0x3;

  modifier whenNotPaused() {
    _whenNotPaused();
    _;
  }

  modifier onlyLendingPoolConfigurator() {
    _onlyLendingPoolConfigurator();
    _;
  }

  function _whenNotPaused() internal view {
    require(!_paused, Errors.LP_IS_PAUSED);
  }

  function _onlyLendingPoolConfigurator() internal view {
    require(
      _addressesProvider.getLendingPoolConfigurator() == msg.sender,
      Errors.LP_CALLER_NOT_LENDING_POOL_CONFIGURATOR
    );
  }

  function getRevision() internal pure override returns (uint256) {
    return LENDINGPOOL_REVISION;
  }

  /**
   * @dev Function is invoked by the proxy contract when the LendingPool contract is added to the
   * LendingPoolAddressesProvider of the market.
   * - Caching the address of the LendingPoolAddressesProvider in order to reduce gas consumption
   *   on subsequent operations
   * - Caller is initializer (LendingPoolAddressesProvider or deployer)
   * @param provider The address of the LendingPoolAddressesProvider
   **/
  function initialize(ILendingPoolAddressesProvider provider) external initializer {
    require(address(provider) != address(0), Errors.LPC_INVALID_CONFIGURATION);

    _addressesProvider = provider;
    // _maxStableRateBorrowSizePercent = 2500;    ToDo: Currently don't support stable debt
    // _flashLoanPremiumTotal = 9;                ToDo: Currently don't support flashloan
    _maxNumberOfReserves = 128;
  }

  /**
   * @dev Register the vault address
   * - To check if the caller is vault for some functions
   * - Caller is only LendingPoolConfigurator
   * @param _vaultAddress The address of the Vault
   **/
  function registerVault(address _vaultAddress)
    external
    payable
    override
    onlyLendingPoolConfigurator
  {
    _availableVaults[_vaultAddress] = true;
  }

  /**
   * @dev Unregister the vault address
   * - To check if the caller is vault for some functions
   * - Caller is only LendingPoolConfigurator
   * @param _vaultAddress The address of the Vault
   **/
  function unregisterVault(address _vaultAddress)
    external
    payable
    override
    onlyLendingPoolConfigurator
  {
    _availableVaults[_vaultAddress] = false;
  }

  /**
   * @dev Deposits an `amount` of underlying asset into the reserve, receiving in return overlying aTokens.
   * - E.g. User deposits 100 USDC and gets in return 100 aUSDC
   * - Caller is anyone.
   * @param asset The address of the underlying asset to deposit
   * @param amount The amount to be deposited
   * @param onBehalfOf The address that will receive the aTokens, same as msg.sender if the user
   *   wants to receive them on his own wallet, or a different address if the beneficiary of aTokens
   *   is a different wallet
   * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
   *   0 if the action is executed directly by the user, without any middle-man
   **/

  function deposit(
    address asset,
    uint256 amount,
    address onBehalfOf,
    uint16 referralCode
  ) external override whenNotPaused {
    DataTypes.ReserveData storage reserve = _reserves[asset];
    (, , , , bool isCollateral) = reserve.configuration.getFlags();
    address yieldAddress = reserve.yieldAddress;
    bool isFirstDeposit = false;

    _validateVault(isCollateral, asset, yieldAddress, Errors.VT_COLLATERAL_DEPOSIT_INVALID);

    ValidationLogic.validateDeposit(reserve, amount);
    address aToken = reserve.aTokenAddress;

    if (!_isInterestRateNotAvailable(reserve.interestRateStrategyAddress)) {
      reserve.updateState();
      reserve.updateInterestRates(asset, aToken, amount, 0);
    }

    IERC20(asset).safeTransferFrom(msg.sender, aToken, amount);

    if (isCollateral && yieldAddress != address(0)) {
      isFirstDeposit = IAToken(aToken).mint(
        onBehalfOf,
        amount,
        reserve.getIndexFromPricePerShare()
      );
    } else {
      isFirstDeposit = IAToken(aToken).mint(onBehalfOf, amount, reserve.liquidityIndex);
    }

    if (isFirstDeposit) {
      _usersConfig[onBehalfOf].setUsingAsCollateral(reserve.id, isCollateral);
      if (isCollateral) {
        emit ReserveUsedAsCollateralEnabled(asset, onBehalfOf);
      }
    }

    emit Deposit(asset, msg.sender, onBehalfOf, amount, referralCode);
  }

  /**
   * @dev Deposits an `amount` of underlying asset into the reserve for supplier from vault
   * - Caller is only Vault which is registered in this contract
   * @param asset The address of the underlying asset to deposit
   * @param amount The amount to be deposited
   **/
  function depositYield(address asset, uint256 amount) external override whenNotPaused {
    DataTypes.ReserveData storage reserve = _reserves[asset];
    (, , , , bool isCollateral) = reserve.configuration.getFlags();
    address aToken = reserve.aTokenAddress;

    require(!isCollateral, Errors.VT_PROCESS_YIELD_INVALID);
    require(_availableVaults[msg.sender] == true, Errors.VT_PROCESS_YIELD_INVALID);

    reserve.updateState();

    // update liquidityIndex based on yield amount
    uint256 totalAmount = IERC20(aToken).totalSupply();
    reserve.cumulateToLiquidityIndex(totalAmount, amount);

    reserve.updateInterestRates(asset, aToken, amount, 0);

    // update APR
    address aprDataProvider = _addressesProvider.getAddress('APR_PROVIDER');
    ISturdyAPRDataProvider(aprDataProvider).updateAPR(asset, amount, totalAmount);

    IERC20(asset).safeTransferFrom(msg.sender, aToken, amount);
  }

  /**
   * @dev Grab an Yield `amount` of underlying asset into the vault
   * - Caller is only Vault which is registered in this contract
   * @param asset The address of the underlying asset to get yield
   * @param amount The yield amount
   **/
  function getYield(address asset, uint256 amount) external override whenNotPaused {
    DataTypes.ReserveData storage reserve = _reserves[asset];
    (, , , , bool isCollateral) = reserve.configuration.getFlags();

    require(isCollateral, Errors.VT_PROCESS_YIELD_INVALID);
    _validateVault(isCollateral, asset, reserve.yieldAddress, Errors.VT_PROCESS_YIELD_INVALID);
    IAToken(reserve.aTokenAddress).transferUnderlyingTo(msg.sender, amount);
  }

  /**
   * @dev Get underlying asset and aToken's total balance
   * @param asset The address of the underlying asset
   * @return The underlying asset balance and aToken's total balance
   **/
  function getTotalBalanceOfAssetPair(address asset)
    external
    view
    override
    returns (uint256, uint256)
  {
    DataTypes.ReserveData storage reserve = _reserves[asset];
    (, , , , bool isCollateral) = reserve.configuration.getFlags();
    address aToken = reserve.aTokenAddress;

    // collateral assetBalance should increase overtime based on vault strategy
    uint256 assetBalance = IERC20(asset).balanceOf(aToken);
    // assetBalanceAcknowledgedByAToken should not increase overtime because of no borrower.
    uint256 assetBalanceAcknowledgedByAToken = IAToken(aToken).totalSupply();

    if (isCollateral && reserve.yieldAddress != address(0)) {
      assetBalanceAcknowledgedByAToken = assetBalanceAcknowledgedByAToken.rayDiv(
        reserve.getIndexFromPricePerShare()
      );
      uint256 decimal = IERC20Detailed(aToken).decimals();
      if (decimal < 18)
        assetBalanceAcknowledgedByAToken = assetBalanceAcknowledgedByAToken / 10**(18 - decimal);
    }

    return (assetBalance, assetBalanceAcknowledgedByAToken);
  }

  /**
   * @dev Get total underlying asset which is borrowable
   *  and also list of underlying asset
   * @return The total borrowable underlying asset balance and list of borrowable underlying assets
   **/
  function getBorrowingAssetAndVolumes()
    external
    view
    override
    returns (
      uint256,
      uint256[] memory,
      address[] memory,
      uint256
    )
  {
    uint256 totalVolume;
    uint256 reserveCount = _reservesCount;
    uint256[] memory volumes = new uint256[](reserveCount);
    address[] memory assets = new address[](reserveCount);
    uint256 pos;

    for (uint256 i; i < reserveCount; ++i) {
      DataTypes.ReserveData storage reserve = _reserves[_reservesList[i]];
      (bool isActive, bool isFrozen, bool isBorrowing, , ) = reserve.configuration.getFlags();
      if (isActive && !isFrozen && isBorrowing) {
        volumes[pos] = IERC20(reserve.aTokenAddress).totalSupply();
        volumes[pos] = volumes[pos] / 10**reserve.configuration.getDecimals();
        assets[pos] = _reservesList[i];
        totalVolume += volumes[pos];
        pos += 1;
      }
    }

    return (totalVolume, volumes, assets, pos);
  }

  /**
   * @dev Withdraws an `amount` of underlying asset from the reserve, burning the equivalent aTokens owned
   * - E.g. User has 100 aUSDC, calls withdraw() and receives 100 USDC, burning the 100 aUSDC
   * - Caller is anyone
   * @param asset The address of the underlying asset to withdraw
   * @param amount The underlying amount to be withdrawn
   *   - Send the value type(uint256).max in order to withdraw the whole aToken balance
   * @param to Address that will receive the underlying, same as msg.sender if the user
   *   wants to receive it on his own wallet, or a different address if the beneficiary is a
   *   different wallet
   * @return The final amount withdrawn
   **/
  function withdraw(
    address asset,
    uint256 amount,
    address to
  ) external override whenNotPaused returns (uint256) {
    return _withdraw(asset, amount, msg.sender, to);
  }

  /**
   * @dev Withdraws an `amount` of underlying asset from the reserve, burning the equivalent aTokens owned
   * - E.g. User has 100 aUSDC, calls withdraw() and receives 100 USDC, burning the 100 aUSDC
   * - Caller is only vault
   * @param asset The address of the underlying asset to withdraw
   * @param amount The underlying amount to be withdrawn
   *   - Send the value type(uint256).max in order to withdraw the whole aToken balance
   * @param from The address of user who is depositor of underlying asset
   * @param to Address that will receive the underlying, same as msg.sender if the user
   *   wants to receive it on his own wallet, or a different address if the beneficiary is a
   *   different wallet
   * @return The final amount withdrawn
   **/
  function withdrawFrom(
    address asset,
    uint256 amount,
    address from,
    address to
  ) external override whenNotPaused returns (uint256) {
    return _withdraw(asset, amount, from, to);
  }

  /**
   * @dev Withdraws an `amount` of underlying asset from the reserve, burning the equivalent aTokens owned
   * - E.g. User has 100 aUSDC, calls withdraw() and receives 100 USDC, burning the 100 aUSDC
   * @param asset The address of the underlying asset to withdraw
   * @param amount The underlying amount to be withdrawn
   *   - Send the value type(uint256).max in order to withdraw the whole aToken balance
   * @param from The address of user who is depositor of underlying asset
   * @param to Address that will receive the underlying, same as msg.sender if the user
   *   wants to receive it on his own wallet, or a different address if the beneficiary is a
   *   different wallet
   * @return The final amount withdrawn
   **/
  function _withdraw(
    address asset,
    uint256 amount,
    address from,
    address to
  ) internal returns (uint256) {
    DataTypes.ReserveData storage reserve = _reserves[asset];
    uint256 amountToWithdraw = amount;
    address aToken = reserve.aTokenAddress;
    uint256 userBalance = IAToken(aToken).balanceOf(from);
    DataTypes.UserConfigurationMap storage fromConfig = _usersConfig[from];

    if (amount == type(uint256).max) {
      amountToWithdraw = userBalance;
    }

    ValidationLogic.validateWithdraw(
      asset,
      from,
      amountToWithdraw,
      userBalance,
      _reserves,
      fromConfig,
      _reservesList,
      _reservesCount,
      _addressesProvider.getPriceOracle()
    );

    if (!_isInterestRateNotAvailable(reserve.interestRateStrategyAddress)) {
      reserve.updateState();
      reserve.updateInterestRates(asset, aToken, 0, amountToWithdraw);
    }

    uint8 id = reserve.id;
    if (amountToWithdraw == userBalance && fromConfig.isUsingAsCollateral(id)) {
      fromConfig.setUsingAsCollateral(id, false);
      emit ReserveUsedAsCollateralDisabled(asset, from);
    }

    (, , , , bool isCollateral) = reserve.configuration.getFlags();
    address yieldAddress = reserve.yieldAddress;

    _validateVault(isCollateral, asset, yieldAddress, Errors.VT_COLLATERAL_WITHDRAW_INVALID);

    if (isCollateral && yieldAddress != address(0)) {
      uint256 aTokenIndex = reserve.getIndexFromPricePerShare();
      IAToken(aToken).burn(from, to, amountToWithdraw, aTokenIndex);
      amountToWithdraw = amountToWithdraw.rayDiv(aTokenIndex);
      uint256 decimal = IERC20Detailed(aToken).decimals();
      if (decimal < 18) amountToWithdraw = amountToWithdraw / 10**(18 - decimal);
    } else {
      IAToken(aToken).burn(from, to, amountToWithdraw, reserve.liquidityIndex);
    }

    emit Withdraw(asset, from, to, amountToWithdraw);

    return amountToWithdraw;
  }

  /**
   * @dev Allows users to borrow a specific `amount` of the reserve underlying asset, provided that the borrower
   * already deposited enough collateral, or he was given enough allowance by a credit delegator on the
   * corresponding debt token (StableDebtToken or VariableDebtToken)
   * - E.g. User borrows 100 USDC passing as `onBehalfOf` his own address, receiving the 100 USDC in his wallet
   *   and 100 stable/variable debt tokens, depending on the `interestRateMode`
   * - Caller is anyone
   * @param asset The address of the underlying asset to borrow
   * @param amount The amount to be borrowed
   * @param interestRateMode The interest rate mode at which the user wants to borrow: 1 for Stable, 2 for Variable
   * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
   *   0 if the action is executed directly by the user, without any middle-man
   * @param onBehalfOf Address of the user who will receive the debt. Should be the address of the borrower itself
   * calling the function if he wants to borrow against his own collateral, or the address of the credit delegator
   * if he has been given credit delegation allowance
   **/
  function borrow(
    address asset,
    uint256 amount,
    uint256 interestRateMode,
    uint16 referralCode,
    address onBehalfOf
  ) external override whenNotPaused {
    DataTypes.ReserveData storage reserve = _reserves[asset];

    _executeBorrow(
      ExecuteBorrowParams(
        asset,
        msg.sender,
        onBehalfOf,
        amount,
        interestRateMode,
        reserve.aTokenAddress,
        referralCode,
        true
      )
    );
  }

  /**
   * @notice Repays a borrowed `amount` on a specific reserve, burning the equivalent debt tokens owned
   * - E.g. User repays 100 USDC, burning 100 variable/stable debt tokens of the `onBehalfOf` address
   * - Caller is anyone
   * @param asset The address of the borrowed underlying asset previously borrowed
   * @param amount The amount to repay
   * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
   * @param rateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
   * @param onBehalfOf Address of the user who will get his debt reduced/removed. Should be the address of the
   * user calling the function if he wants to reduce/remove his own debt, or the address of any other
   * other borrower whose debt should be removed
   * @return The final amount repaid
   **/
  function repay(
    address asset,
    uint256 amount,
    uint256 rateMode,
    address onBehalfOf
  ) external override whenNotPaused returns (uint256) {
    DataTypes.ReserveData storage reserve = _reserves[asset];

    (uint256 stableDebt, uint256 variableDebt) = Helpers.getUserCurrentDebt(onBehalfOf, reserve);

    DataTypes.InterestRateMode interestRateMode = DataTypes.InterestRateMode(rateMode);

    ValidationLogic.validateRepay(
      reserve,
      amount,
      interestRateMode,
      onBehalfOf,
      stableDebt,
      variableDebt
    );

    uint256 paybackAmount = interestRateMode == DataTypes.InterestRateMode.STABLE
      ? stableDebt
      : variableDebt;

    if (amount < paybackAmount) {
      paybackAmount = amount;
    }

    address interestRateStrategyAddress = reserve.interestRateStrategyAddress;
    if (!_isInterestRateNotAvailable(interestRateStrategyAddress)) {
      reserve.updateState();
    }

    if (interestRateMode == DataTypes.InterestRateMode.STABLE) {
      IStableDebtToken(reserve.stableDebtTokenAddress).burn(onBehalfOf, paybackAmount);
    } else {
      IVariableDebtToken(reserve.variableDebtTokenAddress).burn(
        onBehalfOf,
        paybackAmount,
        reserve.variableBorrowIndex
      );
    }

    address aToken = reserve.aTokenAddress;
    if (!_isInterestRateNotAvailable(interestRateStrategyAddress)) {
      reserve.updateInterestRates(asset, aToken, paybackAmount, 0);
    }

    if (stableDebt + variableDebt - paybackAmount == 0) {
      _usersConfig[onBehalfOf].setBorrowing(reserve.id, false);
    }

    IERC20(asset).safeTransferFrom(msg.sender, aToken, paybackAmount);

    IAToken(aToken).handleRepayment(msg.sender, paybackAmount);

    emit Repay(asset, onBehalfOf, msg.sender, paybackAmount);

    return paybackAmount;
  }

  /**
   * @dev Allows depositors to enable/disable a specific deposited asset as collateral
   * - Caller is anyone
   * @param asset The address of the underlying asset deposited
   * @param useAsCollateral `true` if the user wants to use the deposit as collateral, `false` otherwise
   **/
  function setUserUseReserveAsCollateral(address asset, bool useAsCollateral)
    external
    override
    whenNotPaused
  {
    DataTypes.ReserveData storage reserve = _reserves[asset];

    ValidationLogic.validateSetUseReserveAsCollateral(
      reserve,
      asset,
      useAsCollateral,
      _reserves,
      _usersConfig[msg.sender],
      _reservesList,
      _reservesCount,
      _addressesProvider.getPriceOracle()
    );

    _usersConfig[msg.sender].setUsingAsCollateral(reserve.id, useAsCollateral);

    if (useAsCollateral) {
      emit ReserveUsedAsCollateralEnabled(asset, msg.sender);
    } else {
      emit ReserveUsedAsCollateralDisabled(asset, msg.sender);
    }
  }

  /**
   * @dev Function to liquidate a non-healthy position collateral-wise, with Health Factor below 1
   * - The caller (liquidator) covers `debtToCover` amount of debt of the user getting liquidated, and receives
   *   a proportionally amount of the `collateralAsset` plus a bonus to cover market risk
   * - Caller is anyone
   * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
   * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
   * @param user The address of the borrower getting liquidated
   * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
   * @param receiveAToken `true` if the liquidators wants to receive the collateral aTokens, `false` if he wants
   * to receive the underlying collateral asset directly
   **/
  function liquidationCall(
    address collateralAsset,
    address debtAsset,
    address user,
    uint256 debtToCover,
    bool receiveAToken
  ) external override whenNotPaused {
    address collateralManager = _addressesProvider.getLendingPoolCollateralManager();

    //solium-disable-next-line
    (bool success, bytes memory result) = collateralManager.delegatecall(
      abi.encodeWithSignature(
        'liquidationCall(address,address,address,uint256,bool)',
        collateralAsset,
        debtAsset,
        user,
        debtToCover,
        receiveAToken
      )
    );

    require(success, Errors.LP_LIQUIDATION_CALL_FAILED);

    (uint256 returnCode, string memory returnMessage) = abi.decode(result, (uint256, string));

    require(returnCode == 0, string(abi.encodePacked(returnMessage)));
  }

  /**
   * @dev Returns the state and configuration of the reserve
   * @param asset The address of the underlying asset of the reserve
   * @return The state of the reserve
   **/
  function getReserveData(address asset)
    external
    view
    override
    returns (DataTypes.ReserveData memory)
  {
    return _reserves[asset];
  }

  /**
   * @dev Returns the user account data across all the reserves
   * @param user The address of the user
   * @return totalCollateralETH the total collateral in ETH of the user
   * @return totalDebtETH the total debt in ETH of the user
   * @return availableBorrowsETH the borrowing power left of the user
   * @return currentLiquidationThreshold the liquidation threshold of the user
   * @return ltv the loan to value of the user
   * @return healthFactor the current health factor of the user
   **/
  function getUserAccountData(address user)
    external
    view
    override
    returns (
      uint256 totalCollateralETH,
      uint256 totalDebtETH,
      uint256 availableBorrowsETH,
      uint256 currentLiquidationThreshold,
      uint256 ltv,
      uint256 healthFactor
    )
  {
    (
      totalCollateralETH,
      totalDebtETH,
      ltv,
      currentLiquidationThreshold,
      healthFactor
    ) = GenericLogic.calculateUserAccountData(
      user,
      _reserves,
      _usersConfig[user],
      _reservesList,
      _reservesCount,
      _addressesProvider.getPriceOracle()
    );

    availableBorrowsETH = GenericLogic.calculateAvailableBorrowsETH(
      totalCollateralETH,
      totalDebtETH,
      ltv
    );
  }

  /**
   * @dev Returns the configuration of the reserve
   * @param asset The address of the underlying asset of the reserve
   * @return The configuration of the reserve
   **/
  function getConfiguration(address asset)
    external
    view
    override
    returns (DataTypes.ReserveConfigurationMap memory)
  {
    return _reserves[asset].configuration;
  }

  /**
   * @dev Returns the configuration of the user across all the reserves
   * @param user The user address
   * @return The configuration of the user
   **/
  function getUserConfiguration(address user)
    external
    view
    override
    returns (DataTypes.UserConfigurationMap memory)
  {
    return _usersConfig[user];
  }

  /**
   * @dev Returns the normalized income per unit of asset
   * @param asset The address of the underlying asset of the reserve
   * @return The reserve's normalized income
   */
  function getReserveNormalizedIncome(address asset)
    external
    view
    virtual
    override
    returns (uint256)
  {
    return _reserves[asset].getNormalizedIncome();
  }

  /**
   * @dev Returns the normalized variable debt per unit of asset
   * @param asset The address of the underlying asset of the reserve
   * @return The reserve normalized variable debt
   */
  function getReserveNormalizedVariableDebt(address asset)
    external
    view
    override
    returns (uint256)
  {
    return _reserves[asset].getNormalizedDebt();
  }

  /**
   * @dev Returns if the LendingPool is paused
   * @return `true` if the lending pool is paused
   */
  function paused() external view override returns (bool) {
    return _paused;
  }

  /**
   * @dev Returns the list of the initialized reserves
   * @return The list of the reserves
   **/
  function getReservesList() external view override returns (address[] memory) {
    uint256 reserveCount = _reservesCount;
    address[] memory _activeReserves = new address[](reserveCount);

    for (uint256 i; i < reserveCount; ++i) {
      _activeReserves[i] = _reservesList[i];
    }
    return _activeReserves;
  }

  /**
   * @dev Returns the cached LendingPoolAddressesProvider connected to this contract
   * @return The address of LendingPoolAddressesProvider
   **/
  function getAddressesProvider() external view override returns (ILendingPoolAddressesProvider) {
    return _addressesProvider;
  }

  /**
   * @dev Returns the maximum number of reserves supported to be listed in this LendingPool
   * @return The max number of reserves count
   */
  function MAX_NUMBER_RESERVES() public view returns (uint256) {
    return _maxNumberOfReserves;
  }

  /**
   * @dev Validates and finalizes an aToken transfer
   * - Only callable by the overlying aToken of the `asset`
   * - Caller is only aToken contract which is storing the underlying asset of depositors
   * @param asset The address of the underlying asset of the aToken
   * @param from The user from which the aTokens are transferred
   * @param to The user receiving the aTokens
   * @param amount The amount being transferred/withdrawn
   * @param balanceFromBefore The aToken balance of the `from` user before the transfer
   * @param balanceToBefore The aToken balance of the `to` user before the transfer
   */
  function finalizeTransfer(
    address asset,
    address from,
    address to,
    uint256 amount,
    uint256 balanceFromBefore,
    uint256 balanceToBefore
  ) external override whenNotPaused {
    require(msg.sender == _reserves[asset].aTokenAddress, Errors.LP_CALLER_MUST_BE_AN_ATOKEN);
    require(from != to, Errors.LPC_INVALID_CONFIGURATION);

    DataTypes.UserConfigurationMap storage fromConfig = _usersConfig[from];

    ValidationLogic.validateTransfer(
      from,
      _reserves,
      fromConfig,
      _reservesList,
      _reservesCount,
      _addressesProvider.getPriceOracle()
    );

    uint256 reserveId = _reserves[asset].id;
    (, , , , bool isCollateral) = _reserves[asset].configuration.getFlags();

    if (from != to) {
      if (balanceFromBefore - amount == 0 && fromConfig.isUsingAsCollateral(reserveId)) {
        fromConfig.setUsingAsCollateral(reserveId, false);
        emit ReserveUsedAsCollateralDisabled(asset, from);
      }

      if (balanceToBefore == 0 && amount != 0 && isCollateral) {
        DataTypes.UserConfigurationMap storage toConfig = _usersConfig[to];
        toConfig.setUsingAsCollateral(reserveId, true);
        emit ReserveUsedAsCollateralEnabled(asset, to);
      }
    }
  }

  /**
   * @dev Initializes a reserve, activating it, assigning an aToken and debt tokens and an
   * interest rate strategy
   * - Caller is only LendingPoolConfigurator
   * @param asset The address of the underlying asset of the reserve
   * @param yieldAddress The address of the underlying asset's yield contract of the reserve
   * @param aTokenAddress The address of the aToken that will be assigned to the reserve
   * @param stableDebtAddress The address of the StableDebtToken that will be assigned to the reserve
   * @param variableDebtAddress The address of the VariableDebtToken that will be assigned to the reserve
   * @param interestRateStrategyAddress The address of the interest rate strategy contract
   **/
  function initReserve(
    address asset,
    address yieldAddress,
    address aTokenAddress,
    address stableDebtAddress,
    address variableDebtAddress,
    address interestRateStrategyAddress
  ) external payable override onlyLendingPoolConfigurator {
    require(Address.isContract(asset), Errors.LP_NOT_CONTRACT);
    require(IERC20(aTokenAddress).totalSupply() == 0, Errors.LP_ATOKEN_INIT_INVALID);
    _reserves[asset].init(
      aTokenAddress,
      yieldAddress,
      stableDebtAddress,
      variableDebtAddress,
      interestRateStrategyAddress
    );
    _addReserveToList(asset);
  }

  /**
   * @dev Updates the address of the interest rate strategy contract
   * - Caller is only LendingPoolConfigurator
   * @param asset The address of the underlying asset of the reserve
   * @param rateStrategyAddress The address of the interest rate strategy contract
   **/
  function setReserveInterestRateStrategyAddress(address asset, address rateStrategyAddress)
    external
    payable
    override
    onlyLendingPoolConfigurator
  {
    _reserves[asset].interestRateStrategyAddress = rateStrategyAddress;
  }

  /**
   * @dev Sets the configuration bitmap of the reserve as a whole
   * - Caller is only LendingPoolConfigurator
   * @param asset The address of the underlying asset of the reserve
   * @param configuration The new configuration bitmap
   **/
  function setConfiguration(address asset, uint256 configuration)
    external
    payable
    override
    onlyLendingPoolConfigurator
  {
    _reserves[asset].configuration.data = configuration;
  }

  /**
   * @dev Set the _pause state of a reserve
   * - Caller is only LendingPoolConfigurator
   * @param val `true` to pause the reserve, `false` to un-pause it
   */
  function setPause(bool val) external payable override onlyLendingPoolConfigurator {
    _paused = val;
    if (_paused) {
      emit Paused();
    } else {
      emit Unpaused();
    }
  }

  struct ExecuteBorrowParams {
    address asset;
    address user;
    address onBehalfOf;
    uint256 amount;
    uint256 interestRateMode;
    address aTokenAddress;
    uint16 referralCode;
    bool releaseUnderlying;
  }

  function _executeBorrow(ExecuteBorrowParams memory vars) internal {
    DataTypes.ReserveData storage reserve = _reserves[vars.asset];
    DataTypes.UserConfigurationMap storage userConfig = _usersConfig[vars.onBehalfOf];

    address oracle = _addressesProvider.getPriceOracle();

    uint256 amountInETH = (IPriceOracleGetter(oracle).getAssetPrice(vars.asset) * vars.amount) /
      10**reserve.configuration.getDecimals();

    ValidationLogic.validateBorrow(
      vars.asset,
      reserve,
      vars.onBehalfOf,
      vars.amount,
      amountInETH,
      vars.interestRateMode,
      _maxStableRateBorrowSizePercent,
      _reserves,
      userConfig,
      _reservesList,
      _reservesCount,
      oracle
    );

    address interestRateStrategyAddress = reserve.interestRateStrategyAddress;
    if (!_isInterestRateNotAvailable(interestRateStrategyAddress)) {
      reserve.updateState();
    }

    uint256 currentStableRate;

    bool isFirstBorrowing = false;
    if (DataTypes.InterestRateMode(vars.interestRateMode) == DataTypes.InterestRateMode.STABLE) {
      currentStableRate = reserve.currentStableBorrowRate;

      isFirstBorrowing = IStableDebtToken(reserve.stableDebtTokenAddress).mint(
        vars.user,
        vars.onBehalfOf,
        vars.amount,
        currentStableRate
      );
    } else {
      isFirstBorrowing = IVariableDebtToken(reserve.variableDebtTokenAddress).mint(
        vars.user,
        vars.onBehalfOf,
        vars.amount,
        reserve.variableBorrowIndex
      );
    }

    if (isFirstBorrowing) {
      userConfig.setBorrowing(reserve.id, true);
    }

    if (!_isInterestRateNotAvailable(interestRateStrategyAddress)) {
      reserve.updateInterestRates(
        vars.asset,
        vars.aTokenAddress,
        0,
        vars.releaseUnderlying ? vars.amount : 0
      );
    }

    if (vars.releaseUnderlying) {
      IAToken(vars.aTokenAddress).transferUnderlyingTo(vars.user, vars.amount);
    }

    emit Borrow(
      vars.asset,
      vars.user,
      vars.onBehalfOf,
      vars.amount,
      vars.interestRateMode,
      DataTypes.InterestRateMode(vars.interestRateMode) == DataTypes.InterestRateMode.STABLE
        ? currentStableRate
        : reserve.currentVariableBorrowRate,
      vars.referralCode
    );
  }

  /**
   * @dev Add the asset to reserves list
   * @param asset The address of the underlying asset of the reserve
   **/
  function _addReserveToList(address asset) internal {
    uint256 reservesCount = _reservesCount;

    require(reservesCount < _maxNumberOfReserves, Errors.LP_NO_MORE_RESERVES_ALLOWED);

    bool reserveAlreadyAdded = _reserves[asset].id != 0 || _reservesList[0] == asset;

    if (!reserveAlreadyAdded) {
      _reserves[asset].id = uint8(reservesCount);
      _reservesList[reservesCount] = asset;

      _reservesCount = reservesCount + 1;
    }
  }

  /**
   * @dev Check the availability of interest rate
   * @param interestRateStrategyAddress The address of interest rate strategy contract
   * @return The availability of interest rate
   **/
  function _isInterestRateNotAvailable(address interestRateStrategyAddress)
    internal
    view
    returns (bool)
  {
    return
      IReserveInterestRateStrategy(interestRateStrategyAddress).variableRateSlope1() == 0 &&
      IReserveInterestRateStrategy(interestRateStrategyAddress).variableRateSlope2() == 0 &&
      IReserveInterestRateStrategy(interestRateStrategyAddress).baseVariableBorrowRate() == 0;
  }

  /**
   * @dev Validate the request from vault in case of deposit, getYield, withdrawFrom, depositYield
   * @param isCollateral if asset is collateral then true otherwise false
   * @param asset The underlying asset address
   * @param yieldAddress The underlying asset's vault address, if zero, it means lidoVault
   * @param errCode The error string code
   **/
  function _validateVault(
    bool isCollateral,
    address asset,
    address yieldAddress,
    string memory errCode
  ) internal view {
    if (!isCollateral) return;

    // sender is only vault
    require(_availableVaults[msg.sender] == true, errCode);

    if (yieldAddress != address(0)) {
      // sender is only reserve related vault
      require(yieldAddress == msg.sender, errCode);
    } else {
      // sender is only lidoVault
      require(asset == _addressesProvider.getAddress('LIDO'), errCode);
    }
  }
}
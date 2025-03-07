// SPDX-License-Identifier: MIT

pragma solidity 0.7.6;
pragma abicoder v2;

import "./INextVersionStake.sol";
import "./StakingBase.sol";
import "./StakingRestake.sol";
import "./StakingVotes.sol";

contract Staking is StakingBase, StakingRestake, StakingVotes {
    using SafeMathUpgradeable for uint;
    using LibBrokenLine for LibBrokenLine.BrokenLine;

    function __Staking_init(IERC20Upgradeable _token, uint _startingPointWeek, uint _minCliffPeriod, uint _minSlopePeriod) external initializer {
        __StakingBase_init_unchained(_token, _startingPointWeek, _minCliffPeriod, _minSlopePeriod);
        __Ownable_init_unchained();
        __Context_init_unchained();
    }

    function stop() external onlyOwner notStopped {
        stopped = true;
        emit StopStaking(msg.sender);
    }

    function startMigration(address to) external onlyOwner {
        migrateTo = to;
        emit StartMigration(msg.sender, to);
    }

    function stake(address account, address _delegate, uint amount, uint slope, uint cliff) external notStopped notMigrating returns (uint) {
        require(amount > 0, "zero amount");
        require(cliff <= TWO_YEAR_WEEKS, "cliff too big");
        require(divUp(amount, slope) <= TWO_YEAR_WEEKS, "period too big");
        require(token.transferFrom(msg.sender, address(this), amount), "transfer failed");

        counter++;

        uint time = roundTimestamp(getBlockNumber());
        addLines(account, _delegate, amount, slope, cliff, time);
        accounts[account].amount = accounts[account].amount.add(amount);
        emit StakeCreate(counter, account, _delegate, time, amount, slope, cliff);

        // IVotesUpgradeable events
        emit DelegateChanged(account, address(0), _delegate);
        emit DelegateVotesChanged(_delegate, 0, accounts[_delegate].balance.actualValue(time));
        return counter;
    }

    function withdraw() external {
        uint value = getAvailableForWithdraw(msg.sender);
        if (value > 0) {
            accounts[msg.sender].amount = accounts[msg.sender].amount.sub(value);
            require(token.transfer(msg.sender, value), "transfer failed");
        }
        emit Withdraw(msg.sender, value);
    }

    // Amount available for withdrawal
    function getAvailableForWithdraw(address account) public view returns (uint value) {
        value = accounts[account].amount;
        if (!stopped) {
            uint time = roundTimestamp(getBlockNumber());
            uint bias = accounts[account].locked.actualValue(time);
            value = value.sub(bias);
        }
    }

    //Remaining locked amount
    function locked(address account) external view returns (uint) {
        return accounts[account].amount;
    }

    //For a given Line id, the owner and delegate addresses.
    function getAccountAndDelegate(uint id) external view returns (address account, address delegate) {
        account = stakes[id].account;
        delegate = stakes[id].delegate;
    }

    //Getting "current week" of the contract.
    function getWeek() external view returns (uint) {
        return roundTimestamp(getBlockNumber());
    }

    function delegateTo(uint id, address newDelegate) external notStopped notMigrating {
        address account = verifyStakeOwner(id);
        address _delegate = stakes[id].delegate;
        uint time = roundTimestamp(getBlockNumber());
        accounts[_delegate].balance.update(time);
        (uint bias, uint slope, uint cliff) = accounts[_delegate].balance.remove(id, time);
        LibBrokenLine.Line memory line = LibBrokenLine.Line(time, bias, slope);
        accounts[newDelegate].balance.update(time);
        accounts[newDelegate].balance.add(id, line, cliff);
        stakes[id].delegate = newDelegate;
        emit Delegate(id, account, newDelegate, time);

        // IVotesUpgradeable events
        emit DelegateChanged(account, _delegate, newDelegate);
        emit DelegateVotesChanged(_delegate, 0, accounts[_delegate].balance.actualValue(time));
        emit DelegateVotesChanged(newDelegate, 0, accounts[newDelegate].balance.actualValue(time));
    }

    function totalSupply() external view returns (uint) {
        if ((totalSupplyLine.initial.bias == 0) || (stopped)) {
            return 0;
        }
        uint time = roundTimestamp(getBlockNumber());
        return totalSupplyLine.actualValue(time);
    }

    function balanceOf(address account) external view returns (uint) {
        if ((accounts[account].balance.initial.bias == 0) || (stopped)) {
            return 0;
        }
        uint time = roundTimestamp(getBlockNumber());
        return accounts[account].balance.actualValue(time);
    }

    function migrate(uint[] memory id) external {
        if (migrateTo == address(0)) {
            return;
        }
        uint time = roundTimestamp(getBlockNumber());
        INextVersionStake nextVersionStake = INextVersionStake(migrateTo);
        for (uint256 i = 0; i < id.length; i++) {
            address account = verifyStakeOwner(id[i]);
            address _delegate = stakes[id[i]].delegate;
            updateLines(account, _delegate, time);
            //save data Line before remove
            LibBrokenLine.LineData memory lineData = accounts[account].locked.initiatedLines[id[i]];
            (uint residue,,) = accounts[account].locked.remove(id[i], time);

            require(token.transfer(migrateTo, residue), "transfer failed");
            accounts[account].amount = accounts[account].amount.sub(residue);

            accounts[_delegate].balance.remove(id[i], time);
            totalSupplyLine.remove(id[i], time);
            nextVersionStake.initiateData(id[i], lineData, account, _delegate);
        }
        emit Migrate(msg.sender, id);
    }

    function name() public view virtual returns (string memory) {
        return "Rarible Vote-Escrow";
    }

    function symbol() public view virtual returns (string memory) {
        return "veRARI";
    }

    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    uint256[50] private __gap;
}
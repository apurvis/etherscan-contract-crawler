// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import './Subwallet.sol';

/**
* @notice Stakeable is a contract who is ment to be inherited by other contract that wants Staking capabilities
*/
contract Stakeable {


    /**
    * @notice Constructor since this contract is not ment to be used without inheritance
    * push once to stakeholders for it to work proplerly
     */
    constructor() {
        // This push is needed so we avoid index 0 causing bug of index-1
        stakeholders.push();
        stakingWallet = new Subwallet();
        stakeholdersWallet = new Subwallet();
        thresholds.push(Threshold(20, 0, 0));
        thresholds.push(Threshold(15, 100000000000000000000000, 0));
        thresholds.push(Threshold(12, 1000000000000000000000000, 0));
        thresholds.push(Threshold(10, 5000000000000000000000000, 0));
        thresholds.push(Threshold(8,  10000000000000000000000000, 0));
        thresholds.push(Threshold(5,  50000000000000000000000000, 0));
        thresholds.push(Threshold(0, 100000000000000000000000000, 0));

        Threshold memory newThreshold =  thresholds[completedThresholds.length];
        newThreshold.since = block.timestamp;
        completedThresholds.push(newThreshold);
    }
    /**
     * @notice
     * A stake struct is used to represent the way we store stakes,
     * A Stake will contain the users address, the amount staked and a timestamp,
     * Since which is when the stake was made
     */
    struct Stake {
        address user;
        uint256 amount;
        uint256 since;
        // This claimable field is new and used to tell how big of a reward is currently available
        uint256 claimable;
        uint256 claimed;
    }
    /**
    * @notice Stakeholder is a staker that has active stakes
     */
    struct Stakeholder {
        address user;
        Stake[] address_stakes;

    }
    /**
    * @notice
     * StakingSummary is a struct that is used to contain all stakes performed by a certain account
     */
    struct StakingSummary {
        uint256 total_amount;
        Stake[] stakes;
    }

    struct Threshold {
        uint256 percentage;
        uint256 turnover;
        uint256 since;
    }




    /**
    * @notice
    *   This is a array where we store all Stakes that are performed on the Contract
    *   The stakes for each address are stored at a certain index, the index can be found using the stakes mapping
    */
    Stakeholder[] public stakeholders;

    Threshold[] internal thresholds;

    Threshold[] public completedThresholds;

    Subwallet internal stakingWallet;

    Subwallet internal stakeholdersWallet;

    uint public lastStakedDays;
    /**
    * @notice
    * stakes is used to keep track of the INDEX for the stakers in the stakes array
     */
    mapping(address => uint256) internal stakes;
    /**
    * @notice Staked event is triggered whenever a user stakes tokens, address is indexed to make it filterable
     */
    event Staked(address indexed user, uint256 amount, uint256 index, uint256 timestamp);
    event ThresholdAchieved(uint256 index, uint256 timestamp);

    /**
    * @notice
      rewardPerHour is 1000 because it is used to represent 0.001, since we only use integer numbers
      This will give users 0.1% reward for each staked token / H
     */

    uint256 public totalStakes = 0;

    /**
    * @notice _addStakeholder takes care of adding a stakeholder to the stakeholders array
     */
    function _addStakeholder(address staker) internal returns (uint256){
        // Push a empty item to the Array to make space for our new stakeholder
        stakeholders.push();
        // Calculate the index of the last item in the array by Len-1
        uint256 userIndex = stakeholders.length - 1;
        // Assign the address to the new index
        stakeholders[userIndex].user = staker;
        // Add index to the stakeHolders
        stakes[staker] = userIndex;
        return userIndex;
    }

    /**
    * @notice
    * _Stake is used to make a stake for an sender. It will remove the amount staked from the stakers account and place those tokens inside a stake container
    * StakeID
    */
    function _stake(uint256 _amount) public {
        // Simple check so that user does not stake 0
        require(_amount > 0, "Cannot stake nothing");


        // Mappings in solidity creates all values, but empty, so we can just check the address
        uint256 index = stakes[msg.sender];
        // block.timestamp = timestamp of the current block in seconds since the epoch
        uint256 timestamp = block.timestamp;
        // See if the staker already has a staked index or if its the first time
        if (index == 0) {
            // This stakeholder stakes for the first time
            // We need to add him to the stakeHolders and also map it into the Index of the stakes
            // The index returned will be the index of the stakeholder in the stakeholders array
            index = _addStakeholder(msg.sender);
        }

        // Use the index to push a new Stake
        // push a newly created Stake with the current block timestamp.
        stakeholders[index].address_stakes.push(Stake(msg.sender, _amount, timestamp, 0, 0));
        // Emit an event that the stake has occured
        emit Staked(msg.sender, _amount, index, timestamp);
        totalStakes += _amount;
        bool hasNext = true;
        while(hasNext) {
            if( completedThresholds.length < thresholds.length && thresholds[completedThresholds.length].turnover <= totalStakes) {
                Threshold memory newThreshold =  thresholds[completedThresholds.length];
                newThreshold.since = block.timestamp;
                completedThresholds.push(newThreshold);
                emit ThresholdAchieved(completedThresholds.length, block.timestamp);
            } else {
                hasNext = false;
            }

        }
    }

    /**
      * @notice
      * calculateStakeReward is used to calculate how much a user should be rewarded for their stakes
      * and the duration the stake has been active
     */
    function calculateStakeReward(Stake memory _current_stake) internal  view returns (uint256){
        // First calculate how long the stake has been active
        // Use current seconds since epoch - the seconds since epoch the stake was made
        // The output will be duration in SECONDS ,
        // We will reward the user 0.1% per Hour So thats 0.1% per 3600 seconds
        // the alghoritm is  seconds = block.timestamp - stake seconds (block.timestap - _stake.since)
        // hours = Seconds / 3600 (seconds /3600) 3600 is an variable in Solidity names hours
        // we then multiply each token by the hours staked , then divide by the rewardPerHour rate
        uint256 stakedSum = 0;
        for (uint i = 0; i < completedThresholds.length; i++) {
            uint timeFrom = max(completedThresholds[i].since, _current_stake.since) ;
            uint timeTo = block.timestamp;
            if(i + 1 < completedThresholds.length) {
                timeTo = completedThresholds[i+1].since;
            }
            timeTo =timeTo  / 1 days;
            timeFrom =timeFrom  / 1 days;
            uint stakedDays = 0;
            if(timeFrom <= timeTo) {
                stakedDays = timeTo - timeFrom;
            }
            if(stakedDays > 0) {
                stakedSum += stakedDays * _current_stake.amount * completedThresholds[i].percentage / 100 / 30;
            }
        }
        return stakedSum;
    }

    /**
     * @notice
     * withdrawStake takes in an amount and a index of the stake and will remove tokens from that stake
     * Notice index of the stake is the users stake counter, starting at 0 for the first stake
     * Will return the amount to MINT onto the acount
     * Will also calculateStakeReward and reset timer
    */
    function _withdrawStake(uint256 index) internal returns (Stake memory){
        // Grab user_index which is the index to use to grab the Stake[]
        uint256 user_index = stakes[msg.sender];
        Stake memory current_stake = stakeholders[user_index].address_stakes[index];

        // Calculate available Reward first before we start modifying data
        current_stake.claimable =  calculateStakeReward(current_stake) - current_stake.claimed;
        uint amount  = current_stake.amount;
        delete stakeholders[user_index].address_stakes[index];
        return current_stake;
    }

    /**
     * @notice
     * withdrawStake takes in an amount and a index of the stake and will remove tokens from that stake
     * Notice index of the stake is the users stake counter, starting at 0 for the first stake
     * Will return the amount to amount claimed
    */
    function _claimStake(uint256 amount, uint256 index) internal returns (uint256){
        // Grab user_index which is the index to use to grab the Stake[]
        uint256 user_index = stakes[msg.sender];
        Stake memory current_stake = stakeholders[user_index].address_stakes[index];

//         Calculate available Reward first before we start modifying data

        uint256 reward = calculateStakeReward(current_stake) - current_stake.claimed;
        require(reward >= amount, "Staking: Cannot withdraw more than you have staked");
        stakeholders[user_index].address_stakes[index].claimed = current_stake.claimed + amount;


    return amount ;
    }

    /**
    * @notice
     * hasStake is used to check if a account has stakes and the total amount along with all the seperate stakes
     */
    function hasStake(address _staker) public view returns (StakingSummary memory){
        // totalStakeAmount is used to count total staked amount of the address
        uint256 totalStakeAmount;
        // Keep a summary in memory since we need to calculate this
        StakingSummary memory summary = StakingSummary(0, stakeholders[stakes[_staker]].address_stakes);
        // Itterate all stakes and grab amount of stakes
        for (uint256 s = 0; s < summary.stakes.length; s += 1) {
            uint256 availableReward = calculateStakeReward(summary.stakes[s]);
            summary.stakes[s].claimable =   availableReward - summary.stakes[s].claimed ;
            totalStakeAmount = totalStakeAmount + summary.stakes[s].amount;
        }
        // Assign calculate amount to summary
        summary.total_amount = totalStakeAmount;
        return summary;
    }


    function getStakingAddress() public view returns (address ){
        // totalStakeAmount is used to count total staked amount of the address
       return stakingWallet.selfAddress();
    }
    function getContractAddress() public view returns (address ){
        // totalStakeAmount is used to count total staked amount of the address
       return address(this);
    }


    function max(uint256 a, uint256 b) internal view returns (uint256) {
        return a >= b ? a : b;
    }
}







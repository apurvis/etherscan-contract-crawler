//SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

interface ITrancheMasterManual {
    function setDuration(uint256 _duration) external;

    function setDevAddress(address payable _devAddress) external;

    function add(
        uint256 target,
        uint256 apy,
        uint256 fee
    ) external;

    function set(
        uint256 tid,
        uint256 target,
        uint256 apy,
        uint256 fee
    ) external;

    function balanceOf(address account) external view returns (uint256 balance, uint256 invested);

    function getInvest(uint256 tid) external view returns (uint256);

    function investDirect(
        uint256 amountIn,
        uint256 tid,
        uint256 amountInvest
    ) external;

    function deposit(uint256 amount) external;

    function invest(
        uint256 tid,
        uint256 amount,
        bool returnLeft
    ) external;

    function redeem(uint256 tid) external;

    function redeemDirect(uint256 tid) external;

    function withdraw(uint256 amount) external;

    function stop(uint256[] memory minBaseAmounts) external;

    function start(uint256[] memory minLPAmounts) external;

    function setStaker(address _staker) external;

    function setStrategy(address _strategy) external;

    function withdrawFee(uint256 amount) external;

    function producedFee() external view returns (uint256);

    function duration() external view returns (uint256);

    function cycle() external view returns (uint256);

    function actualStartAt() external view returns (uint256);

    function active() external view returns (bool);

    function tranches(uint256 id)
        external
        view
        returns (
            uint256 target,
            uint256 principal,
            uint256 apy,
            uint256 fee
        );

    function currency() external view returns (address);

    function staker() external view returns (address);

    function strategy() external view returns (address);

    function userInfo(address account) external view returns (uint256);

    function userInvest(address account, uint256 tid) external view returns (uint256 cycle, uint256 principal);

    function trancheSnapshots(uint256 cycle, uint256 tid)
        external
        view
        returns (
            uint256 target,
            uint256 principal,
            uint256 capital,
            uint256 rate,
            uint256 apy,
            uint256 fee,
            uint256 startAt,
            uint256 stopAt
        );
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract StakeEther {

    mapping(address => uint256) public balances;

    struct Stake {
        uint256 amount;
        uint256 timeStaked;
        uint256 duration;
        address owner;
        uint256 id;
        bool liquidated;
        uint256 reward;
    }

    mapping(address => Stake[]) public stakes;

    constructor() {}

    modifier ZeroCheck() {
        require(msg.sender != address(0), "Address zero detected");
        _;
    }

    event EtherStaked(address indexed staker, uint256 indexed amountStaked);
    event StakeWithdrawn(
        address indexed staker,
        uint256 indexed amountWithdrawn
    );

    function stake(uint256 _duration) external payable ZeroCheck {
        require(
            _duration == 30 || _duration == 60 || _duration == 90,
            "Invalid staking duration"
        );
        require(msg.value > 0, "Amount must be greater than 0");

        uint256 reward = calculateReward(msg.value, _duration);

        Stake[] storage userStakes = stakes[msg.sender];

        Stake memory newStake = Stake({
            amount: msg.value,
            timeStaked: block.timestamp,
            owner: msg.sender,
            id: userStakes.length + 1,
            liquidated: false,
            reward: reward,
            duration: _duration * 1 days
        });

        userStakes.push(newStake);

        balances[msg.sender] += msg.value;

        emit EtherStaked(msg.sender, msg.value);
    }

    function liquidate(uint256 _stakeId) external ZeroCheck {
        uint256 index = _stakeId - 1;

        Stake[] storage userStakes = stakes[msg.sender];
        require(index < userStakes.length, "Stake ID is invalid");

        Stake storage stakeToWithdraw = userStakes[index];

        require(!stakeToWithdraw.liquidated, "Stake already liquidated");

        balances[msg.sender] -= stakeToWithdraw.amount;

        stakeToWithdraw.liquidated = true;

        uint256 reward = stakeToWithdraw.reward;

        bool earlyWithdrawal = block.timestamp <
            (stakeToWithdraw.timeStaked + stakeToWithdraw.duration);

        if (earlyWithdrawal) {
            reward = 0;
        }

        uint256 totalPayout = stakeToWithdraw.amount + reward;

        (bool success, ) = msg.sender.call{value: totalPayout}("");
        require(success, "Ether transfer failed");

        emit StakeWithdrawn(msg.sender, stakeToWithdraw.amount);
    }

    function getTotalStakeBalance()
        external
        view
        ZeroCheck
        returns (uint256)
    {
        return balances[msg.sender];
    }

    /   
    function calculateReward(
        uint256 _amount,
        uint256 _durationDays
    ) private pure returns (uint256) {
        uint256 reward = 0;

        if (_durationDays == 90) {
            reward = (_amount * 5) / 100; // 5% for 3 months
        } else if (_durationDays == 60) {
            reward = (_amount * 1) / 100; // 1% for 2 months
        } else if (_durationDays == 30) {
            reward = (_amount * 5) / 10000; // 0.05% for 1 month
        }

        return reward;
    }

    // Fallback function to accept Ether sent directly to the contract
    receive() external payable {}
}

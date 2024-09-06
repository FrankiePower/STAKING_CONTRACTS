// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StakeSuperToken {

    address public tokenAddress;

    mapping(address => uint256) balances;

    struct Stake {
        uint256 amount;
        uint256 timeStaked;
        uint256 duration;
        address owner;
        uint256 id;
        bool liquidated;
        uint256 reward;
    }

    mapping(address => Stake[]) stakes;

   constructor() {
        tokenAddress = 0xA02e9FeC84C5a1dA7AB98817E14191A714f9287D;
    }

    modifier ZeroCheck() {
        require(msg.sender != address(0), "Address zero Detected");
        _;
    }

    // Events to emit when a token have been staked, and when it have been liquidated;

    event TokenStaked(address indexed staker, uint256 indexed amountStaked);
    event StakeWithdrawn(
        address indexed staker,
        uint256 indexed amountWithdrawn
    );


    function stake(uint256 _amount, uint256 _duration) external ZeroCheck {

        uint256 _userSuperTokenBalance = IERC20(tokenAddress).balanceOf(msg.sender);

        uint256 allowance = IERC20(tokenAddress).allowance(msg.sender,address(this));

        require(
            _duration == 30 || _duration == 60 || _duration == 90,  "Invalid staking duration"
        );

       require(_userSuperTokenBalance >= _amount, "Insufficient Funds"); 

        require(allowance >= _amount, "Insufficient Allowance");

        bool transferSuccess = IERC20(tokenAddress).transferFrom( msg.sender, address(this),  _amount);

        require(transferSuccess, "Token transfer failed");

        Stake[] storage userStakes = stakes[msg.sender];

        uint256 reward = calculateReward(_amount, _duration);

        Stake memory newStake = Stake({
            amount: _amount,
            timeStaked: block.timestamp,
            owner: msg.sender,
            id: userStakes.length + 1,
            liquidated: false,
            reward: reward,
            duration: _duration * 1 days
        });


        userStakes.push(newStake);


        balances[msg.sender] += _amount;


        emit TokenStaked(msg.sender, _amount);
    }

    function liquidate(uint256 _stakeId) external ZeroCheck {
      
        uint256 index = _stakeId - 1;

        Stake[] storage userStakes = stakes[msg.sender];


        require(index < userStakes.length, "Stake Id is Invalid");


        Stake storage stakeToWithdraw = userStakes[index];


        require(!stakeToWithdraw.liquidated, "Stake already Liquidated");

        balances[msg.sender] -= stakeToWithdraw.amount;

        stakeToWithdraw.liquidated = true;


        uint256 reward = stakeToWithdraw.reward;

        bool earlyWithdrawal = block.timestamp <
            (stakeToWithdraw.timeStaked + stakeToWithdraw.duration);

        if (earlyWithdrawal) {
            reward = 0;
        }

        uint256 totalPayout = stakeToWithdraw.amount + reward;

        bool transferSuccess = IERC20(tokenAddress).transfer(
            msg.sender,
            totalPayout
        );
        require(transferSuccess, "Token transfer failed");

        emit StakeWithdrawn(msg.sender, stakeToWithdraw.amount);
    }

    function getTotalStakeBalance() external view ZeroCheck returns (uint256)  {
        return balances[msg.sender];
    }
    
    function getDetailsOfASingleStake(uint256 _stakeId) external view ZeroCheck returns (Stake memory) {

        uint256 index = _stakeId - 1;

        Stake[] memory userStakes = stakes[msg.sender];

        require(index < userStakes.length, "Stake Id is Invalid");

        return userStakes[index];
    }

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
}

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
        require(
            _duration == 30 || _duration == 60 || _duration == 90,
            "Invalid staking duration"
        );

        uint256 _userSuperTokenBalance = IERC20(tokenAddress).balanceOf(
            msg.sender
        );

       require(_userSuperTokenBalance >= _amount, "Insufficient Funds");

        // here we transfer the intended stake amount to the contract address
        // just so the contract can manage it and stake it for the user

        uint256 allowance = IERC20(tokenAddress).allowance(
            msg.sender,
            address(this)
        );
        require(allowance >= _amount, "Insufficient Allowance");

        bool transferSuccess = IERC20(tokenAddress).transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        require(transferSuccess, "Token transfer failed");

        // we get the users stakes from storage
        // we are going to add the new staking to it

        Stake[] storage userStakes = stakes[msg.sender];

        // we initialize the new staking
        // using the stake struct

        // Calculate the reward based on time
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

        //  her we push to the array containing the stakes of the user;

        userStakes.push(newStake);

        // her we increment the total number (MND) that the user has staked on the platform

        balances[msg.sender] += _amount;

        // emit an event when the token is staked

        emit TokenStaked(msg.sender, _amount);
    }

    // this function allows a user to liquidate(withdraw) their stakings
    // users will reeive all the (MND) tokens that they have staked
    // including a profit for how long the stake have been

    function liquidate(uint256 _stakeId) external ZeroCheck {
        // we are expecting the _stakeId argument passed to be an integer
        // and it it going to be the index of the stake - 1
        // because when asigning the Id we did userStakes.length + 1
        // so we are substracting the exter 1, since array is 0 indexed

        uint256 index = _stakeId - 1;

        // we here we get the users stakes from the storage
        // so we can update the liquidity status later on

        Stake[] storage userStakes = stakes[msg.sender];

        // being sure if the index is not out of bound;

        require(index < userStakes.length, "Stake Id is Invalid");

        // get the stake indeded to liquidate

        Stake storage stakeToWithdraw = userStakes[index];

        // checking if the stake is already liquidated, return the function
        // this is just so the user does not get credited twice

        require(!stakeToWithdraw.liquidated, "Stake already Liquidated");

        balances[msg.sender] -= stakeToWithdraw.amount;

        stakeToWithdraw.liquidated = true;

        // the calculated reward for the user

        uint256 reward = stakeToWithdraw.reward;

        // check if this is an early withdrawal

        bool earlyWithdrawal = block.timestamp <
            (stakeToWithdraw.timeStaked + stakeToWithdraw.duration);

        if (earlyWithdrawal) {
            reward = 0;
        }

        // add the reward to the total payout if there is any

        uint256 totalPayout = stakeToWithdraw.amount + reward;

        // transfer the final payout to the user

        bool transferSuccess = IERC20(tokenAddress).transfer(
            msg.sender,
            totalPayout
        );
        require(transferSuccess, "Token transfer failed");

        emit StakeWithdrawn(msg.sender, stakeToWithdraw.amount);
    }

    /// @notice this function allows a user to get their total staked (MND) token
    /// @dev On the Frontend it can be displayed in an analytics tab
    /// @return returns the  total number of (MND) tokens staked
    function getTotalStakeBalance()
        external
        view
        ZeroCheck
        returns (uint256)
    {
        return balances[msg.sender];
    }

    /// @notice this function allows a user to get al their stakes
    /// @dev On the Frontend it can be displayed in a table, so users can manage stakes with ease
    /// @return returns an array of all the stakes a user have made and an Empty Array if none;

    function getStakesForUser()
        external
        view
        Check
        returns (Stake[] memory)
    {
        return stakes[msg.sender];
    }

    /// @notice this function id to get details of particular stake
    /// @param _stakeId  this is the id of the stake to get,(expected to be the position of the stake + 1)
    /// @return returns an object containing details of a Stake

    function getDetailsOfASingleStake(
        uint256 _stakeId
    ) external view ZeroCheck returns (Stake memory) {
        uint256 index = _stakeId - 1;

        Stake[] memory userStakes = stakes[msg.sender];
        require(index < userStakes.length, "Stake Id is Invalid");

        return userStakes[index];
    }

    /// @notice This function calculates the reward based on the staked amount and duration
    /// @param _amount The amount of tokens staked
    /// @param _durationDays The duration in days for which the tokens are staked
    /// @return The calculated reward
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

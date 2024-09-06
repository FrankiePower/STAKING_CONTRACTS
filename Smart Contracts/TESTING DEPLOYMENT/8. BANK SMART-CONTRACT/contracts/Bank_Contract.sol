// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract AccountContract {

    struct Account {
        string name;
        uint balance;
        address accountAddress;
    }

    mapping(address => Account) private accounts;

    // Events for functions create, transfer, withdraw & deposit
    event AccountCreated(address indexed accountAddress, string message);
    event TransferEvent(address indexed sender, address indexed receiver, uint amount);
    event WithdrawEvent(address indexed accountAddress, uint amount);
    event DepositEvent(address indexed accountAddress, uint amount);

    // Modifier to check if the account exists
    modifier onlyExistingAccount(address _address) {
        require(accounts[_address].accountAddress != address(0), "Account does not exist");
        _;
    }

    // Create account
    function createAccount(string memory _name) external {
        require(accounts[msg.sender].accountAddress == address(0), "User account already exists");
        
        accounts[msg.sender] = Account(_name, 0, msg.sender);
        emit AccountCreated(msg.sender, "New user account created successfully");
    }

    // Withdraw funds
    function withdraw(uint _amount) external onlyExistingAccount(msg.sender) {
        Account storage userAccount = accounts[msg.sender];
        require(_amount <= userAccount.balance, "Not enough balance");

        userAccount.balance -= _amount;
        (bool success,) = msg.sender.call{value: _amount}("");
        require(success, "Failed to send Ether");

        emit WithdrawEvent(msg.sender, _amount);
    }

    // Deposit funds
    function deposit() public payable onlyExistingAccount(msg.sender) {
        require(msg.value > 0, "Deposit amount must be greater than zero");

        accounts[msg.sender].balance += msg.value;

        emit DepositEvent(msg.sender, msg.value);
    }

    // Transfer funds to another account
    function transferToAddr(uint _amount, address payable _receiver) external onlyExistingAccount(msg.sender) onlyExistingAccount(_receiver) {
        Account storage senderAccount = accounts[msg.sender];
        require(_amount <= senderAccount.balance, "Not enough balance for transfer");
        require(_receiver == msg.sender, "You cannot transfer to yourself");

        senderAccount.balance -= _amount;
        accounts[_receiver].balance += _amount;

        (bool success,) = _receiver.call{value: _amount}("");
        require(success, "Failed to send Ether");

        emit TransferEvent(msg.sender, _receiver, _amount);
    }

    // Get account balance
    function getBalance() external view onlyExistingAccount(msg.sender) returns (uint) {
        return accounts[msg.sender].balance;
    }
}
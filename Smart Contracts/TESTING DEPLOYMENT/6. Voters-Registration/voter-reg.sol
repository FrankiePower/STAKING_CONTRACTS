// SPDX-License-Identifier: MIT
pragma solidity ^0.80;

contract VoterRegistration {

    // State variables
    address public admin;

    // ID counter for new voters
    uint256 private nextVoterId = 0;

    // Enum to define gender options
    enum Gender {
        Male, Female        
    }

    // Struct to hold voter details
    struct Voter {
        uint256 id;
        bool isRegistered;
        string name;
        uint256 age;
        uint256 nin;
        string location;
        string lga;
        Gender gender;        
    }

    // Mapping of voter IDS to their details
    mapping (uint256 => Voter) private votersById;

    // Mapping of addresses to their voter IDs
    mapping (address => uint256) private voterIdByAddress;

    // Events
    event VoterRegistered(uint256 indexed voterId, address indexed voterAddress, string name, uint256 age, Gender gender);
    event VoterDetailsRetrieved(uint 256 indexed voterId, string name, uint256 age, Gender gender);

    // Modifier to restrict access to admin only
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    // Constructor to initialize the contract with the admin address
    constructor() {
        admin = msg.sender;
    }

    // Function to register a voter with a unique ID
    function registerVoter(address _voterAddress, string memory name, uint256 _age, uint256 _nin, string memory location, string memory lga, Gender gender) public {
        require(voterIdByAddress)

    }
}
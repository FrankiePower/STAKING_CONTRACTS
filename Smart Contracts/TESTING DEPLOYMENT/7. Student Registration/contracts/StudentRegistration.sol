// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract StudentRegistration {
    address public admin;

    struct StudentData {
        string firstName;
        string lastName;
        uint256 age;
        uint256 studentId;
        uint256 cellPhone;
        string houseAddress;
        string city;
        string country;
        string sports;
        bool isRegistered;
    }

    StudentData[] public allStudentsData;

    mapping(uint256 => StudentData) private studentsById;

    event StudentsRegistered(address indexed studentAddress, uint256 studentId, string name);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    // Function to generate a pseudo-random 4-digit Student ID
    function generateRandomStudentId() internal view returns (uint256) {

        uint256 studentId = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender))) % 10000;

        while (!isStudentIdUnique(studentId)) {

            studentId = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender))) % 10000;
        }
        
        return studentId;
    }

    function isStudentIdUnique(uint256 _studentId) internal view returns (bool) {

        return studentsById[_studentId].studentId == 0;
    }

    function register(
        string memory _firstName,
        string memory _lastName,
        uint256 _age,
        uint256 _cellPhone,
        string memory _houseAddress,
        string memory _city,
        string memory _country,
        string memory _sports
    ) public onlyAdmin {

        uint256 newStudentId = generateRandomStudentId();

        StudentData memory newStudent = StudentData({
            firstName: _firstName,
            lastName: _lastName,
            age: _age,
            studentId: newStudentId,
            cellPhone: _cellPhone,
            houseAddress: _houseAddress,
            city: _city,
            country: _country,
            sports: _sports,
            isRegistered: true
        });

        studentsById[newStudentId] = newStudent;

        allStudentsData.push(newStudent);

        emit StudentsRegistered(msg.sender, newStudentId, _firstName);
    }

    function getStudentById(uint256 _studentId) public view returns (StudentData memory) {

        require(studentsById[_studentId].isRegistered, "Student not registered");

        return studentsById[_studentId];
    }
}

contract Example {
 function sendEther(address payable recipient) public payable {
 
bool success = recipient.send(msg.value); // Send Ether to the recipient

 require(success, "Transfer failed"); // Check if the transfer was successful
 }
}


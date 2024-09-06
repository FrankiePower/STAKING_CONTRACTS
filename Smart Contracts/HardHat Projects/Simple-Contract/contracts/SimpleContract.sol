// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
contract SimpleContract {
    string private message;    
    
    //function to set a message in the message variable
    function setMessage(string memory _message) external {
        message = _message;
    }
    
    //function to retrieve the message set in the message variable
    function getMessage() external view returns (string memory) {
        return message;
    }
}
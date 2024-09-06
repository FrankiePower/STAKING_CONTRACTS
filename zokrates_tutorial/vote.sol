// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract AnonymousVoting {
    using ECDSA for bytes32;

    struct Proposal {
        bytes32 proposalHash;
        uint256 voteCount;
    }

    mapping(bytes32 => Proposal) public proposals;
    mapping(bytes32 => bool) public hasVoted;
    
    uint256 public totalVotes;
    bytes32[] public validVoterHashes;

    constructor(bytes32[] memory _validVoterHashes, bytes32[] memory _proposalHashes) {
        validVoterHashes = _validVoterHashes;
        for (uint i = 0; i < _proposalHashes.length; i++) {
            proposals[_proposalHashes[i]] = Proposal(_proposalHashes[i], 0);
        }
    }

    function castVote(
        bytes32 _blindedVote,
        bytes32 _nullifier,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public {
        require(!hasVoted[_nullifier], "This vote has already been cast");
        
        bytes32 messageHash = keccak256(abi.encodePacked(_blindedVote, _nullifier));
        bytes32 ethSignedMessageHash = messageHash.toEthSignedMessageHash();
        address signer = ethSignedMessageHash.recover(v, r, s);
        
        bool isValidVoter = false;
        for (uint i = 0; i < validVoterHashes.length; i++) {
            if (validVoterHashes[i] == keccak256(abi.encodePacked(signer))) {
                isValidVoter = true;
                break;
            }
        }
        require(isValidVoter, "Not a valid voter");

        hasVoted[_nullifier] = true;
        proposals[_blindedVote].voteCount++;
        totalVotes++;
    }

    function getVoteCount(bytes32 _proposalHash) public view returns (uint256) {
        return proposals[_proposalHash].voteCount;
    }

    function getTotalVotes() public view returns (uint256) {
        return totalVotes;
    }
}
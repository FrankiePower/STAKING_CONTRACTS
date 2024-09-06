const { ethers } = require("ethers");

async function deployVotingContract(validVoterHashes, proposalHashes) {
    const provider = new ethers.providers.JsonRpcProvider("YOUR_RPC_URL");
    const signer = new ethers.Wallet("YOUR_PRIVATE_KEY", provider);
    
    const VotingFactory = new ethers.ContractFactory(ABI, BYTECODE, signer);
    const votingContract = await VotingFactory.deploy(validVoterHashes, proposalHashes);
    
    await votingContract.deployed();
    console.log("Voting contract deployed to:", votingContract.address);
}

deployVotingContract(validVoterHashes, proposalHashes);
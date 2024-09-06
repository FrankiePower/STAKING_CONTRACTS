const ethers = require("ethers");
const crypto = require("crypto");

async function prepareVoteParameters(
  proposalId,
  voterPrivateKey,
  contractAddress
) {
  // Create a wallet instance from the voter's private key
  const wallet = new ethers.Wallet(voterPrivateKey);

  // 1. Generate the blinded vote
  const blindedVote = ethers.utils.keccak256(
    ethers.utils.defaultAbiCoder.encode(
      ["uint256", "address"],
      [proposalId, wallet.address]
    )
  );

  // 2. Generate a random nullifier
  const nullifier = ethers.utils.keccak256(ethers.utils.randomBytes(32));

  // 3. Create the message to sign
  const message = ethers.utils.keccak256(
    ethers.utils.defaultAbiCoder.encode(
      ["bytes32", "bytes32"],
      [blindedVote, nullifier]
    )
  );

  // 4. Sign the message
  const messageHashBytes = ethers.utils.arrayify(message);
  const signature = await wallet.signMessage(messageHashBytes);

  // 5. Split the signature
  const sig = ethers.utils.splitSignature(signature);

  return {
    blindedVote,
    nullifier,
    v: sig.v,
    r: sig.r,
    s: sig.s,
  };
}

// Example usage
async function castVote(contractAddress, proposalId, voterPrivateKey) {
  const voteParams = await prepareVoteParameters(
    proposalId,
    voterPrivateKey,
    contractAddress
  );

  // Here you would typically send these parameters to your contract
  console.log("Parameters for castVote:");
  console.log("Blinded Vote:", voteParams.blindedVote);
  console.log("Nullifier:", voteParams.nullifier);
  console.log("v:", voteParams.v);
  console.log("r:", voteParams.r);
  console.log("s:", voteParams.s);

  // Example of how you might call the contract (pseudo-code)
  // const contract = new ethers.Contract(contractAddress, ABI, signer);
  // await contract.castVote(voteParams.blindedVote, voteParams.nullifier, voteParams.v, voteParams.r, voteParams.s);
}

// Example: Replace with actual values
const CONTRACT_ADDRESS = "0x..."; // Your deployed contract address
const PROPOSAL_ID = 1; // The ID of the proposal being voted on
const VOTER_PRIVATE_KEY = "0x..."; // The voter's private key (KEEP THIS SECRET!)

castVote(CONTRACT_ADDRESS, PROPOSAL_ID, VOTER_PRIVATE_KEY)
  .then(() => console.log("Vote parameters prepared successfully"))
  .catch((error) => console.error("Error:", error));

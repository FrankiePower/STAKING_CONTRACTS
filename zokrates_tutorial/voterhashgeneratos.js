const { ethers } = require("ethers");
const crypto = require("crypto");

async function generateValidVoterHashesFromENS(ensNames, providerUrl) {
  const provider = new ethers.providers.JsonRpcProvider(providerUrl);

  async function resolveENS(ensName) {
    try {
      const address = await provider.resolveName(ensName);
      if (!address) throw new Error(`Could not resolve ${ensName}`);
      return address;
    } catch (error) {
      console.error(`Error resolving ${ensName}: ${error.message}`);
      return null;
    }
  }

  function generateValidVoterHash(address) {
    // Remove '0x' prefix if present and convert to lowercase
    const cleanAddress = address.toLowerCase().replace("0x", "");

    // Hash the address using keccak256
    const hash = ethers.utils.keccak256("0x" + cleanAddress);

    return hash;
  }

  const voterHashes = [];
  for (const ensName of ensNames) {
    const address = await resolveENS(ensName);
    if (address) {
      const hash = generateValidVoterHash(address);
      voterHashes.push(hash);
      console.log(`${ensName} -> ${address} -> ${hash}`);
    }
  }

  return voterHashes;
}

// Example usage
const ensNames = [
  "luffy.eth",
  "vitalik.eth",
  "ens.eth",
  // ... add all voter ENS names
];

const providerUrl = "https://mainnet.infura.io/v3/YOUR-PROJECT-ID"; // Replace with your Ethereum node URL

generateValidVoterHashesFromENS(ensNames, providerUrl)
  .then((hashes) => {
    console.log("Valid voter hashes:", hashes);
  })
  .catch((error) => {
    console.error("Error:", error);
  });

const hre = require("hardhat");

async function main() {
  try {
    // Get the ContractFactory of your SimpleContract
    const SimpleContract = await hre.ethers.getContractFactory(
      "SimpleContract"
    );

    // Deploy the contract
    const contract = await SimpleContract.deploy();

    // Wait for the deployment transaction to be mined
    await contract.deployed();

    console.log(`SimpleContract deployed to: ${contract.address}`);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

main();

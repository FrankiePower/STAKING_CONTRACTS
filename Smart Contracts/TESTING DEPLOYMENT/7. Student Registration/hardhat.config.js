require("@nomicfoundation/hardhat-ignition");
require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-verify");

module.exports = {
  solidity: "0.8.24",
  // other configurations
  networks: {
    sepolia: {
      url: "https://sepolia.infura.io/v3/2c7f6d8116fd45adb63c13f00c776087",
      accounts: [
        "0x375779fa4c55dacbab26e7315884a11e8404f31830a3afac7576bfdd568f608b",
      ],
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: "W75FM33FHN84V7NDE4I88XR8VG2EY4B2T5",
  },
  sourcify: {
    // Disabled by default
    // Doesn't need an API key
    enabled: true,
  },
};

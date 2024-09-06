import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

require("dotenv").config();

const config: HardhatUserConfig = {
  solidity: "0.8.23",
  networks: {
    // for testnet
    sepolia: {
      url: "https://sepolia.infura.io/v3/2c7f6d8116fd45adb63c13f00c776087",
      accounts: [
        "375779fa4c55dacbab26e7315884a11e8404f31830a3afac7576bfdd568f608b",
      ],
      gasPrice: 1000000000,
    },
  },
};

export default config;

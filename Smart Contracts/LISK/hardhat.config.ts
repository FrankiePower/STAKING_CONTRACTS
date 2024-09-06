import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const WALLET_KEY =
  "a20ca6c555f231c801e23f0d359a24cb7d3637c51cb02c5b3be75faef8e4dee3";

const config: HardhatUserConfig = {
  solidity: "0.8.23",
  networks: {
    // for testnet
    "lisk-sepolia": {
      url: "https://rpc.sepolia-api.lisk.com",
      accounts: [WALLET_KEY],
      gasPrice: 1000000000,
    },
  },
};

export default config;

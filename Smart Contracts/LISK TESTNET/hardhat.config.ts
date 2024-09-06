import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

require("dotenv").config();

const config: HardhatUserConfig = {
  solidity: "0.8.23",
  networks: {
    // for testnet
    sepolia: {
      url: "https://lb.drpc.org/ogrpc?network=lisk-sepolia&dkey=AvFwAja_CUzLpeZulgUDwLuyvwYPXWoR75G7Wq9OWu41",
      accounts: [process.env.WALLET_KEY as string],
      gasPrice: 1000000000,
    },
  },
};

export default config;

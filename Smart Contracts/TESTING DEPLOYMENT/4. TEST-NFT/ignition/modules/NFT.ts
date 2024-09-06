import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const NFTModule = buildModule("NFTModule", (m) => {
  const NFTContract = m.contract("NFT");

  return { NFTContract };
});

export default NFTModule;

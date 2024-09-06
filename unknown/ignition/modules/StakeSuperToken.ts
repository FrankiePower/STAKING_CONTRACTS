import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const StakeSuperTokenModule = buildModule("StakeSuperTokenModule", (m) => {
  const StakeSuperToken = m.contract("StakeSuperToken");

  return { StakeSuperToken };
});

export default StakeSuperTokenModule;

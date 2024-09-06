const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("StudentRegistrationModule", (m) => {
  const StudentRegistration = m.contract("StudentRegistration");

  return { StudentRegistration };
});

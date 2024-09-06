const assert = require("assert");
const ganache = require("ganache");
const { Web3 } = require("web3");
const web3 = new Web3(ganache.provider());

const compiledUser = require("../ethereum/build/user.json");
const compiledMain = require("../ethereum/build/main.json");

let accounts;
let user;


beforeEach(async () => {
  accounts = await web3.eth.getAccounts();
});

user = await new web3.eth.Contract(compiledUser.abi).deploy({

})

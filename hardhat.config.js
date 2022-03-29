require("@nomiclabs/hardhat-waffle");
const fs = require('fs');
const privateKey = fs.readFileSync(".secret").toString();

module.exports = {
  networks: {
    hardhat: {
      chainId: 80001
    },
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com/",
      accounts: [privateKey]
    },
    // mainnet:{
    //   url:"https://rpc-mumbai.maticvigil.com/",
    //   accounts: [privateKey]
    // }
  },
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
};

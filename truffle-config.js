require('dotenv').config();
const HDWalletProvider = require("@truffle/hdwallet-provider");
const path = require("path");

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
      },
    rinkeby: {

     provider: () =>
      new HDWalletProvider(
        process.env.MNEMONIC,
        `https://rinkeby.infura.io/v3/${process.env.INFURA_API_KEY}`
      ),
    network_id: 4, // Rinkeby's id
    gas: 5500000, // Rinkeby has a lower block limit than mainnet
    confirmations: 2, // # of confs to wait between deployments. (default: 0)
    timeoutBlocks: 50000, // # of blocks before a deployment times out  (minimum/default: 50)
    skipDryRun: true // Skip dry run before migrations? (default: false for public nets )
  }
},
  mocha: {
    // timeout: 100000
  },
  compilers: {
    solc: {
       version: "0.6.12",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
      //  optimizer: {
      //    enabled: false,
      //    runs: 200
      //  },
      //  evmVersion: "byzantium"
      // }
    }
  }
};

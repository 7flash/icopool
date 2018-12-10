const HDWalletProvider = require('truffle-hdwallet-provider')
const mnemonic = require("fs").readFileSync("mnemonic").toString().trim()

module.exports = {
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  },
  networks: {
    ropsten: {
      provider: function () {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/c111c65249874931809ddc686f9962f1")
      },
      network_id: 3,
      gas: 4e6,
      gasPrice: 20e9
    },
    mainnet: {
      provider: function () {
        return new HDWalletProvider(mnemonic, "https://mainnet.infura.io/v3/c111c65249874931809ddc686f9962f1")
      },
      network_id: 1,
      gas: 3e5,
      gasPrice: 10e9
    }
  }
};


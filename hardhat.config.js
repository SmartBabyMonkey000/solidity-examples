// Support truffle-style test setup
require("@nomicfoundation/hardhat-toolbox");
require('@nomiclabs/hardhat-truffle5');
require('dotenv').config();

// Importing babel to be able to use ES6 imports
require('@babel/register')({
  presets: [
    ['@babel/preset-env', {
      'targets': {
        'node': '16',
      },
    }],
  ],
  only: [/test|scripts/],
  retainLines: true,
});
require('@babel/polyfill');

// Config from environment
const mnemonicPhrase = process.env.MNEMONIC || 'test test test test test test test test test test test junk';
const mnemonicPassword = process.env.MNEMONIC_PASSWORD;
const privateKey = process.env.PRIVATE_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      {
        version: '0.7.6',
        settings: {
          optimizer: {
            enabled: true,
            runs: 15000,
          },
        },
      },
      {
        version: "0.8.0",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      },
      {
        version: "0.8.17",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      },
      {
        version: '0.8.20',
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ]
  },
  networks: {
    hardhat: {},
    localhost: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*',
    },
    basesepolia: {
      url: 'https://base-sepolia-rpc.publicnode.com',
      accounts: [privateKey],
      chainId: 84532,
      gasPrice: 2000000000,
    },
    sepolia: {
      url: 'https://ethereum-sepolia.publicnode.com',
      accounts: [privateKey],
      chainId: 11155111,
      gasPrice: 100000000000,
      // network_id: '*',
    },
    railstestnet: {
      url: 'https://testnet.steamexchange.io',
      accounts: [privateKey],
      chainId: 24116,
      gasPrice: 2000000000,
      // network_id: '*',
    },
    ethereum: {
      url: 'https://ethereum-rpc.publicnode.com',
      accounts: [privateKey],
      chainId: 1,
      gasPrice: 2000000000,
    },
    bsc: {
      url: 'https://bsc.meowrpc.com',
      accounts: [privateKey],
      chainId: 56,
      gasPrice: 2000000000,
    },
    base: {
      url: 'https://base-rpc.publicnode.com',
      accounts: [privateKey],
      chainId: 8453,
      gasPrice: 2000000000,
    },
    rails: {
      url: 'https://mainnet.steamexchange.io',
      accounts: [privateKey],
      chainId: 6278,
      gasPrice: 2000000000,
    },
    pulsetest: {
      url: 'wss://pulsechain-testnet-rpc.publicnode.com',
      accounts: [privateKey],
      chainId: 943,
      gasPrice: 2000000000,
    }
  },
  paths: {
    sources: './contracts',
    tests: './test',
    cache: './cache',
    artifacts: './artifacts',
  },
  mocha: {
    timeout: 100000000,
  },
  etherscan: {
    apiKey: {
      sepolia: "3TEWVV2EK19S1Y6SV8EECZAGQ7W3362RCN",
      railstestnet: "0000000000000000000000000000000000",
      mainnet: "3TEWVV2EK19S1Y6SV8EECZAGQ7W3362RCN",
      bsc: "UKN1IH7EG27XHH35X9DUR1FX3TEG3Q6PQG",
      base: "21QBD7X75X222SSSTADIT6W9HWY92JCQ8M",
      basesepolia: "21QBD7X75X222SSSTADIT6W9HWY92JCQ8M",
      rails: "0000000000000000000000000000000000",
    },
    customChains: [
      {
        network: "sepolia",
        chainId: 11155111,
        urls: {
          apiURL: "https://api-sepolia.etherscan.io/api/",
          browserURL: "https://sepolia.etherscan.io/"
        }
      },
      {
        network: "railstestnet",
        chainId: 24116,
        urls: {
          apiURL: "https://build.steamexchange.io/api",
          browserURL: "https://build.steamexchange.io/"
        }
      },
      {
        network: "ethereum",
        chainId: 1,
        urls: {
          apiURL: "https://api.etherscan.io/api",
          browserURL: "https://etherscan.io/"
        }
      },
      {
        network: "bsc",
        chainId: 56,
        urls: {
          apiURL: "https://api.bscscan.com/api",
          browserURL: "https://bscscan.com/"
        }
      },
      {
        network: "base",
        chainId: 8453,
        urls: {
          apiURL: "https://api.basescan.org/api",
          browserURL: "https://basescan.org/"
        }
      },
      {
        network: "basesepolia",
        chainId: 8453,
        urls: {
          apiURL: "https://api.sepolia.basescan.org/api",
          browserURL: "https://sepolia.basescan.org/"
        }
      },
      {
        network: "rails",
        chainId: 6278,
        urls: {
          apiURL: "https://explore.steamexchange.io/api",
          browserURL: "https://explore.steamexchange.io/"
        }
      },
      {
        network: "pulsetest",
        chainId: 943,
        urls: {
          apiURL: "https://scan.v4.testnet.pulsechain.com/api",
          browserURL: "https://scan.v4.testnet.pulsechain.com"
        }
      },
    ]
  },
};

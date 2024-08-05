// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const hreconfig = require("@nomicsfoundations/hardhat-config");
const { mailbox_addresses, customHook_addresses, interchainSecurityModule_addresses } = require("../config");

require('dotenv').config();

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

const verifyContract = async (address, constructorArguments) => {
  try {
    await hre.run('verify:verify', {
      address,
      constructorArguments
    })
  } catch (error) {
    console.log("verify error =======>", error)
  }
}

async function main() {
  try {
    console.log('deploying...')
    
    await hre.run('clean')
    await hre.run('compile')
    console.log('hardhat init OK')

    console.log('AToken deploying...')

    const AToken = await hre.ethers.getContractFactory("AToken");
    const aToken = await AToken.deploy();

    console.log('AToken deploy submitted')

    await aToken.deployed();
    console.log('AToken deploy OK')
    console.log("Deployed Contract Address:", aToken.address);

    console.log('verifying...')

    console.log('AToken verifying...')

    await verifyContract(
      aToken.address,
      []
    )

    console.log('AToken verify OK')

    console.log('Verified Contract Address:', aToken.address)
  } catch (error) {
    console.log('hardhat try catch', error);
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

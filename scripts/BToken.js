// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const hreconfig = require("@nomicsfoundations/hardhat-config");

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

    console.log('BToken deploying...')

    const BToken = await hre.ethers.getContractFactory("BToken");
    const bToken = await BToken.deploy();

    console.log('BToken deploy submitted')

    await bToken.deployed();
    console.log('BToken deploy OK')
    console.log("Deployed Contract Address:", bToken.address);

    console.log('verifying...')

    console.log('BToken verifying...')

    await verifyContract(
      bToken.address,
      []
    )

    console.log('BToken verify OK')

    console.log('Verified Contract Address:', bToken.address)
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

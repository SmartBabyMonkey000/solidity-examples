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
    console.log('hardhat init...')
    const retVal = await hreconfig.hreInit(hre)
    if (!retVal) {
      console.log('hardhat init error!');
      return false;
    }
    await hre.run('clean')
    await hre.run('compile')
    console.log('hardhat init OK')

    console.log('HInterchainBridge deploying...')

    const networkName = hre.network.name;
    const mailboxAddress = mailbox_addresses[networkName];
    const customeHookAddress = customHook_addresses[networkName];
    const interchainSecurityModuleAddress = interchainSecurityModule_addresses[networkName];
    
    console.log("Mailbox: ", mailboxAddress);
    console.log("CustomHook: ", customeHookAddress);
    console.log("InterchainSecurityModule: ", interchainSecurityModuleAddress);

    const HInterchainBridge = await hre.ethers.getContractFactory("HInterchainBridge");
    const hInterchainBridge = await HInterchainBridge.deploy(mailboxAddress, customeHookAddress, interchainSecurityModuleAddress);

    console.log('HInterchainBridge deploy submitted')

    await hInterchainBridge.deployed();
    console.log('HInterchainBridge deploy OK')
    console.log("Deployed Contract Address:", hInterchainBridge.address);

    console.log('verifying...')

    console.log('HInterchainBridge verifying...')

    await verifyContract(
      hInterchainBridge.address,
      [mailboxAddress, customeHookAddress, interchainSecurityModuleAddress]
    )

    console.log('HInterchainBridge verify OK')

    console.log('Verified Contract Address:', hInterchainBridge.address)
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

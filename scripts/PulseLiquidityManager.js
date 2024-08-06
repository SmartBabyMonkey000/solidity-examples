// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const hreconfig = require("@nomicsfoundations/hardhat-config");
const axios = require('axios');

require('dotenv').config();

const IPulseXFactory = '0x29eA7545DEf87022BAdc76323F373EA1e707C523';
const IPulseXRouter = '0xDaE9dd3d1A52CfCe9d5F2fAC7fDe164D500E50f7 '
const IPulseXRouter02 = '0x636f6407B90661b73b1C0F7e24F4C79f624d0738';

const tokenA = '0xa85D2D8391c5ea241E2A1CAbcFe02e941F18E873';
const tokenB = '0x1d89194AD3698643e2f8093731D2c5691eAC726F';

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

        const [ deployer ] = await hre.ethers.getSigners();

        console.log("deployer = ", deployer.address);

        console.log('deploying...')
        
        await hre.run('clean')
        await hre.run('compile')

        console.log('PulseLiquidityManager deploying...')

        const PulseLiquidityManager = await hre.ethers.getContractFactory("PulseLiquidityManager");
        const pulseLiquidityManager = await PulseLiquidityManager.deploy(IPulseXFactory, IPulseXRouter02);

        console.log('PulseLiquidityManager deploy submitted')

        await pulseLiquidityManager.deployed();
        console.log('PulseLiquidityManager deploy OK')
        console.log("Deployed Contract Address:", pulseLiquidityManager.address);

        console.log('verifying...')

        console.log('PulseLiquidityManager verifying...')

        await verifyContract(
            pulseLiquidityManager.address,
            [IPulseXFactory, IPulseXRouter02]
        )

        console.log('PulseLiquidityManager verify OK')

        console.log('Verified Contract Address:', pulseLiquidityManager.address);

        // Example amounts (replace with actual amounts)
        const amountADesired = ethers.utils.parseUnits("1", 18);
        const amountBDesired = ethers.utils.parseUnits("1", 18);
        const amountAMin = ethers.utils.parseUnits("0.9", 18);
        const amountBMin = ethers.utils.parseUnits("0.9", 18);
        const deadline = Math.floor(Date.now() / 1000) + 60 * 20; // 20 minutes from now

        // Create Pair
        await pulseLiquidityManager.createPair(tokenA, tokenB);
        console.log('XXXXXXXXXXXXXXXX')

        // Add liquidity token A + token B
        await pulseLiquidityManager.addLiquidity(
            tokenA,
            tokenB,
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin,
            deployer.address,
            deadline
        );

        // Add Liquidity PLS
        const amountTokenDesired = ethers.utils.parseUnits("1", 18);
        const amountTokenMin = ethers.utils.parseUnits("0.9", 18);
        const amountETHMin = ethers.utils.parseUnits("0.9", 18);
        
        await pulseLiquidityManager.addLiquidityETH(
            amountTokenDesired,
            amountTokenMin,
            amountETHMin,
            deployer.address,
            deadline,
            { value: ethers.utils.parseUnits("1", 18)}
        )

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

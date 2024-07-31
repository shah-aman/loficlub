const hre = require("hardhat");

async function main() {
    const Loficlub = await hre.ethers.getContractFactory("LofiClub");
    const loficlub = await Loficlub.deploy();
    // Wait for the contract to be mined
    await loficlub.waitForDeployment();
    console.log("LofiClub deployed to:", loficlub.address);
    
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
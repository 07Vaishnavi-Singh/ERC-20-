const { ethers } = require("hardhat");

async function main() {

const myERC20Token = await ethers.getContractFactory("MyERC20Token");

const contractdeployed = await myERC20Token.deploy();

await contractdeployed.deployed();

console.log("Deployed at : " , contractdeployed.address );

}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
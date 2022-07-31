// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
// const hre = require("hardhat");

// async function main() {
//   const currentTimestampInSeconds = Math.round(Date.now() / 1000);
//   const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
//   const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

//   const lockedAmount = hre.ethers.utils.parseEther("1");

//   const Lock = await hre.ethers.getContractFactory("Lock");
//   const lock = await Lock.deploy(unlockTime, { value: lockedAmount });

//   await lock.deployed();

//   console.log("Lock with 1 ETH deployed to:", lock.address);
// }

// // We recommend this pattern to be able to use async/await everywhere
// // and properly handle errors.
// main().catch((error) => {
//   console.error(error);
//   process.exitCode = 1;
// });

const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory('Vingo');
  const nftContract = await nftContractFactory.deploy(
    "Tester",
    "TESTSTS",
    "0xD149b3b88b4Ca9cb9a174a95f2EE492a80AC0EC3",
    "0x1260443F80a91eA400B055D8825D6a99ee8b81A2"
  );
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

//   txn = await nftContract.makeAnEpicNFT()
//   // Wait for it to be mined.
//   await txn.wait()
//   console.log("Minted NFT #2")
  // Call the function.
//   let txn = await nftContract.purchaseFreeOfCharge("0x1260443F80a91eA400B055D8825D6a99ee8b81A2", 10)
//   let txn1 = await nftContract.mintPublic("0x1260443F80a91eA400B055D8825D6a99ee8b81A2")
  let txn1 = await nftContract.mintPublic("0x1260443F80a91eA400B055D8825D6a99ee8b81A2")
//   let txn2 = await nftContract.buy()
  // Wait for it to be mined.
  await txn1.wait()
  console.log(txn1.toString())
  console.log("Purchased NFT #1")

};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
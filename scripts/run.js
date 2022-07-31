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
const main = async() => {
    //HRE stands for hardhat runtime environment 
    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT'); //compiles contract and creates abi etc.. under artifacts
    const nftContract = await nftContractFactory.deploy(); //deploys to local test network
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);

    let txn = await nftContract.makeAnEpicNFT()
    await txn.wait()
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

runMain()
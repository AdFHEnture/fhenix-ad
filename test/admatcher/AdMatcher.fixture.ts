import hre from "hardhat";
import { ethers } from "hardhat";
import type { AdMatcher } from "../../types";
import { createFheInstance } from "../../utils/instance";

export async function deployAdMatcherFixture() {
    const accounts = await ethers.getSigners();
    const contractOwner = accounts[0];

    const AdMatcherFactory = await ethers.getContractFactory("AdMatcher");
    const adMatcher = (await AdMatcherFactory.connect(contractOwner).deploy()) as AdMatcher;
    await adMatcher.waitForDeployment();
    const address = await adMatcher.getAddress();

    await getTokensFromFaucet();

    const instance = await createFheInstance(hre, address);

    return { adMatcher, contractOwner, instance, address };
}

export async function getTokensFromFaucet() {
    if (hre.network.name === "localfhenix") {
      const signers = await hre.ethers.getSigners();
  
      if (
        (await hre.ethers.provider.getBalance(signers[0].address)).toString() ===
        "0"
      ) {
        await hre.fhenixjs.getFunds(signers[0].address);
      }
    }
  }
  
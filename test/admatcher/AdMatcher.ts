import { shouldBehaveLikeAdMatcher } from "./AdMatcher.behavior";
import { deployAdMatcherFixture } from "./AdMatcher.fixture";
import hre from "hardhat";

describe("AdMatcher Unit tests", function () {
    before(async function () {
        const { adMatcher, contractOwner, instance, address } = await deployAdMatcherFixture();
        this.adMatcher = adMatcher;
        this.signers = { admin: contractOwner };
        this.instance = instance;
        this.address = address;
    });

    describe("AdMatcher", function () {
        shouldBehaveLikeAdMatcher();
    });
});

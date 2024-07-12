import { expect } from "chai";
import hre from "hardhat";

export function shouldBehaveLikeAdMatcher(): void {
  // it("should add ads correctly", async function () {
  //   const ad = [true, false, true, false, true, false, true, false, true, false];
  //   await this.adMatcher.connect(this.signers.admin).addAd(ad);

  //   const storedAd = await Promise.all([0, 1, 2, 3, 4, 5, 6, 7, 8, 9].map(i => this.adMatcher.adMatrix(0, i)));
  //   expect(storedAd).to.eql([true, false, true, false, true, false, true, false, true, false]);
  // });

  // it("should find the best ad based on encrypted vector", async function () {
  //   const userVector = [1, 0, 1];
  //   const encryptedUserVector = await Promise.all(userVector.map(val => this.instance.instance.encrypt_uint8(val)));

  //   // Simulate encrypted dot product and get the best ad index
  //   const bestAdIndex = await this.adMatcher.findBestAd(encryptedUserVector);
  //   const bestAdIndexDecrypted = await this.instance.instance.decrypt_uint8(bestAdIndex);

  //   expect(bestAdIndexDecrypted).to.equal(0);
  // });

  // it("should find the best ad with permissions", async function () {
  //   const userVector = [1, 0, 1];
  //   const encryptedUserVector = await Promise.all(userVector.map(val => this.instance.instance.encrypt_uint8(val)));

  //   const permission = this.instance.permission;
  //   const bestAdIndex = await this.adMatcher.findBestAdPermit(encryptedUserVector, permission);
  //   const bestAdIndexDecrypted = await this.instance.instance.decrypt_uint8(bestAdIndex);

  //   expect(bestAdIndexDecrypted).to.equal(0);
  // });

  it("should seal the output with permissions", async function () {
    const userVector = [true, false, true, false, true, false, true, false, true, false];
    const encryptedUserVector = await Promise.all(userVector.map(val => this.instance.instance.encrypt_bool(val)));

    const permission = this.instance.permission;
    const sealedOutput = await this.adMatcher.findBestAdPermitSealed(encryptedUserVector, permission);

    expect(sealedOutput).to.equal(3);
  });

  it("should seal the output with permissions by user address", async function () {
    const userVector = [true, false, true, false, true, false, true, false, true, false];
    await this.adMatcher.addUserVector(userVector);
    const encryptedUserVector = await Promise.all(userVector.map(val => this.instance.instance.encrypt_bool(val)));

    const permission = this.instance.permission;
    const sealedOutput = await this.adMatcher.findBestAdPermitSealed(encryptedUserVector, permission);

    expect(sealedOutput).to.equal(3);
  });
}

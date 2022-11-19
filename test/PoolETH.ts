import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("PoolETH", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployPoolETHFixture() {


    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const PoolETH = await ethers.getContractFactory("PoolETH");
    const pool = await PoolETH.deploy();

    return { pool, PoolETH, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Should set balances in zero", async function () {
      const { pool, owner, otherAccount } = await loadFixture(deployPoolETHFixture);

      expect(await pool.balanceOf(owner.address)).to.equal(0);
      expect(await pool.balanceOf(otherAccount.address)).to.equal(0);
    });

    it("Should set the right owner", async function () {
      const { pool, owner } = await loadFixture(deployPoolETHFixture);

      expect(await pool.owner()).to.equal(owner.address);
    });

    it("Should set rewards to zero", async function () {
      const { pool, owner, otherAccount } = await loadFixture(deployPoolETHFixture);

      expect(await pool.calculatePendingReward(owner.address)).to.equal(0);
      expect(await pool.calculatePendingReward(otherAccount.address)).to.equal(0);
    });
  });
})
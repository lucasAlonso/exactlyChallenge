const { expect } = require("chai");
const { ethers, waffle } = require("hardhat");
const { provider } = waffle;

describe("ETHPool", function () {
  beforeEach(async function () {
    const Token = await ethers.getContractFactory("EfCoin");
    token = await Token.deploy();
    await token.deployed();

    const ETHPool = await ethers.getContractFactory("ETHPool");
    eTHPool = await ETHPool.deploy(token.address);
    await eTHPool.deployed();
    token.transferOwnership(eTHPool.address);
    //const [userA, userB, team] = await ethers.getSigners();
  });

  it("Add eth to pool", async () => {
    const [team, userA, userB] = await ethers.getSigners();
    await userA.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("1.0"),
    });
    const balanceA = await token.balanceOf(userA.address);
    expect(balanceA).to.equal(ethers.utils.parseEther("1.0"));
  });

  it("first time reward", async () => {
    const [team, userA, userB] = await ethers.getSigners();
    await userA.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("100.0"),
    });
    await userB.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("200.0"),
    });
    await team.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("300.0"),
    });
    const balanceA = await token.balanceOf(userA.address);

    expect(balanceA).to.equal(ethers.utils.parseEther("200.0"));
  });

  it("first time withdraw", async () => {
    const [team, userA, userB] = await ethers.getSigners();
    await userA.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("1.0"),
    });
    await userB.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("2.0"),
    });
    await team.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("3.0"),
    });
    let balanceA = await token.balanceOf(userA.address);
    await eTHPool.connect(userA).withdraw();
    balanceA = await token.balanceOf(userA.address);
    expect(balanceA).to.equal(ethers.utils.parseEther("0.0"));
  });

  it("multiples withdraws", async () => {
    const [team, userA, userB] = await ethers.getSigners();
    await userA.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("1.0"),
    });
    await userB.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("2.0"),
    });
    await team.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("3.0"),
    });
    let balanceA = await token.balanceOf(userA.address);
    await eTHPool.connect(userA).withdraw();
    await userB.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("50.0"),
    });
    await team.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("10.0"),
    });

    let balanceB = await token.balanceOf(userB.address);
    expect(balanceB).to.equal(ethers.utils.parseEther("64.0"));
  });
});

const { expect } = require("chai");
const { ethers, waffle } = require("hardhat");
const { provider } = waffle;

describe("ETHPool Basics", function () {
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

  it("small quants fo eth", async () => {
    const [team, userA, userB] = await ethers.getSigners();
    await userA.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("0.0000001"),
    });
    await userB.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("0.0000002"),
    });
    await team.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("0.0000003"),
    });
    let balanceA = await token.balanceOf(userA.address);
    await eTHPool.connect(userA).withdraw();

    await userB.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("0.0000004"),
    });
    await team.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("0.000000002"),
    });

    let balanceB = await token.balanceOf(userB.address);
    expect(balanceB).to.equal(ethers.utils.parseEther("0.000000802"));
  });

  it("big quants fo eth", async () => {
    const [team, userA, userB] = await ethers.getSigners();
    await userA.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("250"),
    });
    await userB.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("500"),
    });
    await team.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("3000"),
    });
    let balanceA = await token.balanceOf(userA.address);
    await eTHPool.connect(userA).withdraw();

    await userB.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("5000"),
    });
    await team.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("1000"),
    });

    let balanceB = await token.balanceOf(userB.address);
    expect(balanceB).to.equal(ethers.utils.parseEther("8500"));
  });
  it("team does multiples rebases", async () => {
    const [team, userA, userB] = await ethers.getSigners();
    await userA.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("20"),
    });
    await userB.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("40"),
    });
    await team.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("60"),
    });
    let balanceA = await token.balanceOf(userA.address);
    await eTHPool.connect(userA).withdraw();

    await userB.sendTransaction({
      to: eTHPool.address,
      value: ethers.utils.parseEther("1.000000000025"),
    });
    for (let index = 0; index < 150; index++) {
      await team.sendTransaction({
        to: eTHPool.address,
        value: ethers.utils.parseEther("1"),
      });
    }

    let balanceB = await token.balanceOf(userB.address);
    expect(balanceB).to.equal(ethers.utils.parseEther("231.000000000025"));
  });
});

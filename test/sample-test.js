const { expect, assert } = require("chai");
const { ethers } = require("hardhat");

describe("NFTMarket", function () {
  var marketInstance;
  var nftInstance;
  var price = 1;
  var tokenId = 1;

  it("Should create and execute market sales", async function () {
    const Market = await ethers.getContractFactory("NFTMarket");
    const market = await Market.deploy();
    return market.deployed().then(function (instance) { //
      marketInstance = instance;
      return marketInstance.address;
    }).then(async function (address) {
      assert.notEqual(address, 0x0, 'has contract address');
      const NFT = await ethers.getContractFactory("NFT");
      const nft = await NFT.deploy(address);
      return nft.deployed();
    }).then(function (instance) {
      nftInstance = instance;
      return nftInstance.address;
    }).then(function (address) {
      assert.notEqual(address, 0x0, 'has contract address');
      return marketInstance.owner;
    }).then(function(address){
      assert.notEqual(address, 0x0, 'had owner address');
      return marketInstance.getListingPrice();
    }).then(function(listingPrice){
      assert.isTrue(listingPrice > 0, 'had minimum ether value');
    });

  });
});

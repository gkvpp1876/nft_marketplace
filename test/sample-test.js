const { expect, assert } = require("chai");
const { ethers } = require("hardhat");
const { renderToHTML } = require("next/dist/server/render");

describe("NFTMarket", function () {
  var market;
  var nft;
  var marketInstance;
  var nftInstance;
  var listingPrice = 250000000000000000;
  var auctionPrice;

  it("Should create and execute market sales", async function () {
    const Market = await ethers.getContractFactory("NFTMarket");
    market = await Market.deploy();
    return market.deployed().then(function (instance) { //
      marketInstance = instance;
      return marketInstance.address;
    }).then(async function (address) {
      // console.log('market Address', address);
      assert.notEqual(address, 0x0, 'has contract address');
      const NFT = await ethers.getContractFactory("NFT");
      nft = await NFT.deploy(address);
      return nft.deployed();
    }).then(function (instance) {
      nftInstance = instance;
      return nftInstance.address;
    }).then(function (address) {
      // console.log('NFT Address', address);
      assert.notEqual(address, 0x0, 'has contract address');
      return marketInstance.owner;
    }).then(function (address) {
      assert.notEqual(address, 0x0, 'had owner address');
      listingPrice = marketInstance.getListingPrice();
      return listingPrice;
    }).then(function (listingPrice) {
      assert.isTrue(listingPrice > 0, 'had minimum ether value');
      auctionPrice = ethers.utils.parseUnits('0.25', 'ether');
      return auctionPrice;
    }).then(function (auctionPrice) {
      // console.log(auctionPrice);
      assert.equal(auctionPrice, 250000000000000000, 'auction price of the ether should be equal to the listing price set in market contract 0.25 ether');
      return nft.createToken("https://www.mytokenlocation.com");
    }).then(function (receipt) {
      assert.equal(receipt.to, nftInstance.address, 'to address is the nft contract address');
      assert.equal(receipt.value.toNumber(), 0, 'value of the NFT is 0 when created');
      return marketInstance.createMarketItem(nftInstance.address, 1, 0, { value: listingPrice });
    }).then(assert.fail).catch(function (error) {
      assert(error.message.indexOf('revert') >= 0, 'Price must be greater than 1 wei');
      return marketInstance.createMarketItem(nftInstance.address, 1, auctionPrice, { value: listingPrice });
    }).then(async function (receipt) {
      assert.equal(receipt.to, marketInstance.address, 'NFT is transfered to market contract with base price as 0.25 ether')
      assert.equal(receipt.value, 250000000000000000, 'value of nft on market should be equal to listing price');
      // return market.balanceOf(marketInstance.address);
      // return market.owner;
      [_, buyerAddress] = await ethers.getSigners();
      // console.log(buyerAddress);
      return [_, buyerAddress];
    }).then(function (address) {
      // console.log(address[1].address);
      assert.notEqual(address[1].address, 0x0, 'had valid buyer address');
      return market.connect(address[1]).createMarketSale(nftInstance.address, 1, { value: auctionPrice });
    }).then(function (receipt) {
      console.log('to check here on the to address and from address while doing the sale and validate the transaction',receipt);
    });

  });
});

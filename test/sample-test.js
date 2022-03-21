const { expect, assert } = require("chai");
const { ethers } = require("hardhat");
const { renderToHTML } = require("next/dist/server/render");

describe("NFTMarket", function () {
  var market;
  var marketInstance;
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
      return marketInstance.createToken("https://www.mytokenlocation.com", auctionPrice, { value: listingPrice });
    }).then(async function (receipt) {
      assert.equal(receipt.to, marketInstance.address, 'to address is the nft contract address');
      assert.equal(receipt.value, 250000000000000000, 'value of the NFT is 0 when created');
      await marketInstance.createToken("https://www.mytokenlocation2.com", auctionPrice, { value: listingPrice });
      [_, buyerAddress] = await ethers.getSigners();
      return [_, buyerAddress];
    }).then(function (address) {
      assert.notEqual(address[1].address, 0x0, 'had valid buyer address');
      return market.connect(address[1]).createMarketSale(1, { value: auctionPrice });
    }).then(async function (receipt) {
      //to check this having some doubt
      // console.log(receipt);
      assert.equal(receipt.to, marketInstance.address, 'NFT is transfered to market contract with base price as 0.25 ether')
      assert.equal(receipt.value, 250000000000000000, 'value of nft on market should be equal to listing price');

      let items = await market.fetchMarketItems();
      items = await Promise.all(items.map(async i => {
        const tokenUri = await market.tokenURI(i.tokenId)
        let item = {
          price: i.price.toString(),
          tokenId: i.tokenId.toString(),
          seller: i.seller,
          owner: i.owner,
          tokenUri
        }
        return item;
      }))
      console.log(items);
    });

  });
});

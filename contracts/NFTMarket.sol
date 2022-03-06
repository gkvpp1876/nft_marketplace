//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarket is ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemSold;

    //to make the owner get paid on each transaction
    address payable owner;
    uint256 listingPrice = 0.25 ether; // currently we're using Matic token for transaction;

    constructor() {
        owner = payable(msg.sender);
    }

    struct MarketItem {
        uint256 itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    mapping(uint256 => MarketItem) private idToMarketItem; //mapping allow us to fetch the record with the itemId

    event MarketItemCreated(
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }

    /*
    This createMarketItem is to Create a NFT to be place for sale
        //nonReentrant is a modifier to prevent from the reentranct attack
        //_itemIds.increment() each item we place for sale needs an Identity and it'll be incremented each time
    */
    function createMarketItem(
        address nftContract,
        uint256 tokenId,
        uint256 price
    ) public payable nonReentrant {
        require(price > 0, "Price must be at least 1 wei");
        require(
            msg.value == listingPrice,
            "Price must be equal to listing price"
        );

        _itemIds.increment();
        uint256 itemId = _itemIds.current();

        idToMarketItem[itemId] = MarketItem(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender),
            payable(address(0)),
            price,
            false
        );

        //Transfering the ownership to the contract from the creator or the owner of the NFT
        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

        emit MarketItemCreated(
            itemId,
            nftContract,
            tokenId,
            msg.sender,
            address(0),
            price,
            false
        );
    }

    /*

    */
    function createMarketSale(address nftContrct, uint256 itemId)
        public
        payable
        nonReentrant
    {
        uint price = idToMarketItem[itemId].price;
        uint tokenId = idToMarketItem[itemId].tokenId;

        require(
            msg.value == price,
            "Please submit the asking price i order to complete the purchase"
        );

        idToMarketItem[itemId].seller.transfer(msg.value); //transfering the value of token from seller to owners address
        IERC721(nftContrct).transferFrom(address(this), msg.sender, tokenId); //transfering the token from contract to the buyer
        idToMarketItem[itemId].owner = payable(msg.sender); //setting the owner value to the sender who bought the token
        idToMarketItem[itemId].sold = true; //setting the mapping to sold
        _itemSold.increment(); //incrementing the number of tokens sold
        payable(owner).transfer(listingPrice); //paying the owner of the contract comissions of market place


    }
}

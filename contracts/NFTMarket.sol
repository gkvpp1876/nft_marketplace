//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMarket is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _itemsSold;

    //to make the owner get paid on each transaction
    //payable modifier means transaction can be processed with non-zero ether value 
    address payable owner;
    uint256 listingPrice = 0.25 ether; // currently we're using Matic token for transaction;

    constructor() ERC721("Metaverse Token", "METT"){
        owner = payable(msg.sender);
    }

    struct MarketItem {
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    mapping(uint256 => MarketItem) private idToMarketItem; //mapping allow us to fetch the record with the itemId

    event MarketItemCreated(
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }

    /* Updates the listing price of the contract */
    function updateListingPrice(uint _listingPrice) public payable {
        require(owner == msg.sender, "Only marketplace owner can update the listing price");
        listingPrice = _listingPrice;
    }

    /** Mints a token and lists it in the marketplace */
    function createToken(string memory tokenURI, uint256 price) public payable returns (uint){
        _tokenIds.increment(); //increments or create new token Id when new NFT is minted
        uint256 newTokenId = _tokenIds.current(); //getting the current token ID

        _mint(msg.sender, newTokenId); //Mints the newTokenId to the requester/sender
        _setTokenURI(newTokenId, tokenURI); //setting the tokenURI with the newTokenId identifier 
        createMarketItem(newTokenId, price);
        return newTokenId; //returning the newTokenId as we get mint the NFT we'll show in the marketplace for sale so newTokenId helps in reference or identifier
    }

    /*
    This createMarketItem is to Create a NFT to be place for sale
        //nonReentrant is a modifier to prevent from the reentranct attack
        //_itemIds.increment() each item we place for sale needs an Identity and it'll be incremented each time
    */
    function createMarketItem(
        uint256 tokenId,
        uint256 price
    ) public payable {
        require(price > 0, "Price must be at least 1 wei");
        require(
            msg.value == listingPrice,
            "Price must be equal to listing price"
        );

        idToMarketItem[tokenId] = MarketItem(
            tokenId,
            payable(msg.sender),
            payable(address(this)),
            price,
            false
        );

        //Transfering the ownership to the contract from the creator or the owner of the NFT
        _transfer(msg.sender, address(this), tokenId);

        emit MarketItemCreated(
            tokenId,
            msg.sender,
            address(this),
            price,
            false
        );
    }

    /*
    Creates the sale of a marketplace item
    Transfers ownership of the item, as well as funds between parties
    */
    function createMarketSale(uint256 tokenId)
        public
        payable
    {
        uint price = idToMarketItem[tokenId].price;
        address seller = idToMarketItem[tokenId].seller;

        require(
            msg.value == price,
            "Please submit the asking price i order to complete the purchase"
        );

        idToMarketItem[tokenId].owner = payable(msg.sender); //assigning owner as sender while buying the token
        idToMarketItem[tokenId].sold = true;
        idToMarketItem[tokenId].seller = payable(address(0));
        _itemsSold.increment(); //incrementing the number of tokens sold
        _transfer(address(this), msg.sender, tokenId);
        payable(owner).transfer(listingPrice); //paying the owner of the contract comissions of market place
        payable(seller).transfer(msg.value);
    }

    /*
    Ideally resell Token is selling back the token to the nftmarket contract
     */
    function resellToken(uint256 tokenId, uint256 price)
        public
        payable
    {
        require(idToMarketItem[tokenId].owner == msg.sender, "Only item owner can perform this operation");
        //real-time scenario needs to be observed if the tokens are generated and is being sold back to the contract what value should be allowed?
        require(
            msg.value == listingPrice,
            "Price must be equal to the listing price"
        );

        idToMarketItem[tokenId].owner = payable(address(this)); //assigning owner as contract while selling the token
        idToMarketItem[tokenId].sold = false;
        idToMarketItem[tokenId].seller = payable(msg.sender);
        idToMarketItem[tokenId].price = price;
        _itemsSold.decrement(); //decreasing the number of tokens sold

        _transfer(msg.sender, address(this), tokenId);
    }

    /*
    Returns all unsold market items
    memory: is like Computer RAM, data will be wiped off after the execution
    */
    function fetchMarketItems() public view returns (MarketItem[] memory) {
        uint itemCount = _tokenIds.current();
        uint unsoldItemCount = _tokenIds.current() - _itemsSold.current();
        uint currentIndex = 0;

        MarketItem[] memory items = new MarketItem[](unsoldItemCount);
        for (uint i = 0; i < itemCount; i++) {
            if(idToMarketItem[i + 1].owner == address(this)){
                uint currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    /**Returns only items that a user has purchased */
    //getting the tokens purchased by the user
    function fetchMyNFTs() public view returns (MarketItem[] memory) {
        uint totalItemCount = _tokenIds.current();
        uint itemCount = 0;
        uint currentIndex =0;

        for(uint i = 1; i <= totalItemCount; i++){
            if(idToMarketItem[i].owner == msg.sender){
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        for(uint i = 1; i <= totalItemCount; i++){
            MarketItem storage currentItem = idToMarketItem[i];
            items[currentIndex] = currentItem;
            currentIndex += 1;
        }
        return items;
    }

    /**Returns only items a user has listed */
    function fetchItemsListed() public view returns (MarketItem[] memory) {
        uint totalItemCount = _tokenIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;

        for(uint i = 1; i <= totalItemCount; i++){
            if(idToMarketItem[i].seller == msg.sender){
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        for(uint i = 1; i <= totalItemCount; i++){
            if(idToMarketItem[i].seller == msg.sender){
                MarketItem storage currentItem = idToMarketItem[i];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }
}

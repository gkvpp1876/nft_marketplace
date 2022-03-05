//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds; //to allow us to keep us the unique identifier for our token
    address contractAddress; //all the marketplace to do the transaction of with the contract address

    constructor(address marketplaceAddress)
        ERC721("Metaverse Tokens", "METT")
    {
        contractAddress = marketplaceAddress;
    }

    //createToken is for minting
    function createToken(string memory tokenURI) public returns (uint){
        _tokenIds.increment(); //increments or create new token Id when new NFT is minted
        uint256 newItemId = _tokenIds.current(); //getting the current token ID

        _mint(msg.sender, newItemId); //Mints the newItemId to the requester/sender
        _setTokenURI(newItemId, tokenURI); //setting the tokenURI with the newItemId identifier 
        setApprovalForAll(contractAddress, true); //Gives approval for doing the transaction of NFT by the contract address
        return newItemId; //returning the newItemId as we get mint the NFT we'll show in the marketplace for sale so newItemId helps in reference or identifier
    }
}

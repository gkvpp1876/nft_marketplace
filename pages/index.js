import { ethers } from 'ethers'
import { useEffect, useState } from 'react'
import axios from 'axios'
import Web3Model from "web3modal"
import { marketplaceAddress } from './config'
import NFTMarketplace from './artifacts/contracts/NFTMarket.sol/NFTMarket.json'

export default function Home() {
  const [nfts, setNfts] = useState([])
  const [loadingState, setLoadingState] = useState('not-loaded')

  useEffect(() => {
    loadNFTs()
  }, [])

  async function loadNFTs() {
    /** create a generic provider and query for unsold market items */
    const provider = new ethers.providers.JsonRpcProvider()
    const contract = new ethers.Contract.apply(marketplaceAddress, NFTMarketplace.abi, provider)
    const data = await contract.fetchMarketItems()

    /**
     * map over items returned from smart contract and format
     * them as well as fetch their token metadata
     */
    const items = await Promise.all(data.map(async i => {
      const tokenUri = await contract.tokenURI(i.tokenId)
      const meta = await axios.get(tokenUri)
      let price = ethers.utils.formatUnits(i.price.toString(), 'ether')
      let item = {
        price,
        tokenId: i.tokeId.toNumber(),
        seller: i.seller,
        owner: i.owner,
        image: meta.data.image,
        name: meta.data.name,
        description: meta.data.description
      }
      return item;
    }))
    setNfts(items)
    setLoadingState('Loaded')
  }

  // async function buyNft(nft) {

  // }
}

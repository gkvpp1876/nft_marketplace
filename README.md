Learnings from (check ID @Nadar_Dabit) Full Stack NFT Marketplace on Ethereum with Polygon and next.js
#Development Notes:
UI: Next.js 
    To init next.js project npx create-next-app nft_marketplace
Libraries we're using here:
1. Ethers - Ethereum library for interacting with the Ethereum Blockchain
2. Hardhat - local ethereum network for development. Easily deploy contracts, run tests and debug Solidity code
3. @nomiclabs/hardhat-waffle - Hardhat plugin for waffle framework to run smart contract unit testing
4. ethereum-waffle - Unit testing with waffle which uses ethers-js
5. chai - Chai is an assertion library
6. @nomiclabs/hardhat-ethers - Hardhat plugin for ethers.js interact with the Ethereum blockchain
7. web3modal - library to support multiple providers (wallets)
8. @openzeppelin/contracts - library for secure smart contract implemented with standards like ERC20 and ERC721, role based permissioning, and reusable solidity contracts.
9. ipfs-http-client - library for javascript IPFS RPC API (Remote Procedure Call - RPC helps in remote executing block of code, as it serves on HTTP API to serve IPFS its IPSF RPC API)
10. axios - Promise based Http request handler
11. tailwindcss@latest, postcss@latest, autoprefixer@latest Tailwind CSS - fastest CSS framework

Initialization
12. "npx tailwindcss init -p" - To intialize configuration for tailwind css
13. setting up tailwind css in the styles/globals.css
    @tailwind base;
    @tailwind components;
    @tailwind utilities;

Solidity Code
14. npx hardhat - To setup hardhat for solidity development environment
15. Setting up polygon RPC public or pricate networks, we're using polygon mumbai test network
    a. Reference to get test network on metamask and tokens from faucet https://blog.pods.finance/guide-connecting-mumbai-testnet-to-your-metamask-87978071aca8 - waiting for the tokens to get reflected in the wallet
16. 
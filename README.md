This is a [Next.js](https://nextjs.org/) project bootstrapped with [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `pages/index.js`. The page auto-updates as you edit the file.

[API routes](https://nextjs.org/docs/api-routes/introduction) can be accessed on [http://localhost:3000/api/hello](http://localhost:3000/api/hello). This endpoint can be edited in `pages/api/hello.js`.

The `pages/api` directory is mapped to `/api/*`. Files in this directory are treated as [API routes](https://nextjs.org/docs/api-routes/introduction) instead of React pages.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js/) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/deployment) for more details.

Learnings from (check ID @Nadar_Dabit) Full Stack NFT Marketplace on Ethereum with Polygon and next.js
#Development Notes:
UI: Next.js 
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

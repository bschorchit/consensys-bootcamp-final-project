# :deciduous_tree: The First Decentralized Nagoya Protocol Compliant Marketplace
#### Intro
The Nagoya Protocol is a United Nations agreement that, in very simple words, says: if a product has a natural ingredient (e.g. a flower fragrance in a shampoo), the company that manufactures the product (e.g. shampoo manufacturer) must pay a percentage of his sales (e.g. 1%) to conserve the biodiversity in the country where such natural ingredient comes from (e.g. Brazil).  
  
This protocol has been signed and ratified by over 115 countries, but, as supply chains are complex and cross borders and each biodiversity provider country can set their own specifications on how much and when companies have to pay, it's quite challenging for entreprises to implement and comply with it. Besides that, governments and other stakeholders have no way to verify the revenue made abroad by those companies and need to trust that companies are indeed paying the correct amount to the biodiversity funds.  
This project aims to draft of how would such implementation look like on the Ethereum blockchain.  
  
For that, it deploys 3 smart contracts that autonomously enforce Nagoya Protocol compliance following a simplified version of the brazilian national biodiversity law specification.   
1. `ProductToken` - The first one is a ERC-721 that allows for the creation of NFTs that represent the real life products manufactured by companies. At the moment of creation, the creator needs to specify wether the product has natural ingredients (is biodiversity based) or no.  
2. `ProductStore` - The second one is a marketplace where such products (NFTs) can be sold and bought. For every sale made, the marketplace checks if the product is biodiversity based and then, if it's, it autonomously sends 1% of the product owner's revenue to a biodiversity fund. It also takes another 1% of the product owner's revenue for the contract owner, because well... no marketplace is for free.  
3. `MultiSigBioFund` - Finally, the third one is a biodiversity fund, represented by a simple multisignature wallet that decides how to spend the funds it receives in a transparent and auditable manner.


## Prerequisites

- [Node.js](https://nodejs.org) 14.15.x
- [NPM](https://npm.org) 6.14.x
- [MetaMask](https://metamask.io/) 4.9.x
- [ganache-cli](https://github.com/trufflesuite/ganache-cli) 6.12.x `npm install -g ganache-cli`
- [Truffle](https://truffleframework.com/) 5.1.x `npm install -g truffle`

## Building & Running

1. Git clone this repo 

```bash
git clone https://github.com/bschorchit/consensys-bootcamp-final-project.git
```

2. Create a .env in the project directory that looks like this:
INFURA_API_KEY=YOUR_INFURA_KEY
MNEMONIC="YOUR_TESTNET_MNEMONIC"

2. Go to the client folder in the project directory and then:

```bash
npm install
```

3. Using a different terminal window, run a private Ethereum network with Ganache CLI on `127.0.0.1:8545`:

```bash
ganache-cli
```

Note the mnemonic printed on startup, you will need it later.

2. Using a different terminal window, go to the project directory and compile and migrate the project contracts

```bash
truffle compile && truffle migrate
```

3. In your browser open Metamask, restore accounts from the ganache-cli (using the mnemonic printed on terminal) and set newtwork to Localhost 8545

4. Now back to the first terminal window, in the client folder, start the local server and go to `localhost:3000`

```bash
npm start
```

5. Play around! 

5. a. To sell and buy products, you need to connect with the first account on Metamask (if you imported the mnemonic) and register the contract store. Once you connect with that account, such option will show up. You can get the deployed ProductStore contract address from the terminal window where you run truffle migrate.

5. b. To interact with the Biodiversity Fund interface, you need to connect with accounts[7], accounts[8] and/or accounts[9] as those are the multisignature wallet owners. Once you connect with one of those accounts, the multisig interface will show up. 


## Testing

1. Go to the project directory and run

```bash
truffle test
```

## Disclaimer: 
This dApp was made with barely any previous web development skills, so there will be bugs! Be kind and patient going through it.
Feedback and improvement tips are always welcome :)


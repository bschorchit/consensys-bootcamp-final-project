## 💡 Design Pattern Decisions
Here are listed some of design patterns applied in this project.

## Restricting Access

Modifiers are used to restrict access to functions in the smart contracts. Functions are public only when required. Some examples of these implementations:

1. The `ProductToken` contract inherits from `Open Zeppelin` `ERC-721` and `Ownable` and has the following access restrictions for its extended functions:
- `onlyOwner` modifier for `setStoreAddress` function - only the contract owner can register the contract address that will be used to sell buy and transfer the NFTs. (This requires some level of trust in the contract owner);
- `onlyProductOwner` modifier for `setProductForSale` function - only the owner of a NFT can put it for sale and set a price for it;
- 'require(msg.sender == storeAddress)' for `setProductNotForSale` function - this function is called after a purchase is done to take it off the marketplace and avoid an unwanted sale for the new owner. Only the `ProductStore` can call it. (Contract limitation: currently a seller cannot decide to not sell a product that is set for sale. - to be fixed in later versions).

2. The `ProductStore` contract is `Ownable` and has the following access restrictions for its functions:
- `onlyOwner` modifier for `setNewBiodiversityFund` function - only the contract owner can register the contract address for which part of payments are forwarded to. (This requires some level of trust in the contract owner);
- `onlyOwner` modifier for `declareEmergency` and `endEmergency` functions - only the contract owner can trigger the circuit breaker pattern;
- `checkEthBalance` function - is a public function, but doesn't take an address as parameter ensuring that one can use it only to check on their own balance in the contract.


### Circuit Breaker
The circuit breaker pattern allows the admin to pause the contract in the event that it is being abused or a bug is found and the contract needs to be upgraded. Some examples of these implementations:

`ProductStore` contract:
- `onlyInEmergency` modifier for `setNewBiodiversityFund` and `setNewProductContract` functions - contract owner must pause the contract in order to change any of the two contracts that `ProductStore` contract interacts with;
- `stopInEmergency` modifier for `buyProduct` function - if the circuit breaker is triggered by contract owner, users are no longer able to buy products in the marketplace;


### Withdrawal Pattern
This design pattern is implemented for the sellers on the `ProductStore` contract. Balances are accounted internally and funds are only transferred to users when the `withdraw` function is called. 
That is not the case, though, for the funds being sent to the `MultiSigBioFund` contract (for simplification, to avoid having to approve transactions to withdraw the funds from the store) nor to the NFT transfer `productContract.safeTransferFrom` that is called in within `buyProduct` (Can be implemented in a later version).
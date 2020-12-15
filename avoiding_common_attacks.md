## 🚧 Avoiding Common Attacks
Here are listed some of the measures taken to avoid [common attacks](https://consensys.github.io/smart-contract-best-practices/known_attacks/) on dApps.

### Reentrancy

The reentrancy attack is mitigated by performing internal work first and then calling external contracts or other functions. Some examples of these implementations in `ProductStore` contract:
- In both the `buyProduct` and  `withdraw` functions first the internal balances are calculated and then external functions or transfers are called.

## Integer Overflow and Underflow

The integer overflow and underflow is mitigated by using [*OpenZeppelin's* `SafeMath` Library](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol), which performs math operations with safety checks. `SafeMath` is used for every math operation in both `ProductToken` and `ProductStore` contracts.

## Logic Bugs

Simple programming mistakes can cause the contract to behave differently to its stated rules, especially on 'edge cases'. A total of 29 tests were written to ensure the contracts behave as expected. 
- 11 tests were written for the `ProductToken` contract.
- 7 tests were written for the `ProductStore` contract.
- 11 tests were written for the `MultiSigBioFund` contract.
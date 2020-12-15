const ProductToken = artifacts.require("ProductToken");
const ProductStore = artifacts.require("ProductStore");
const BioFund = artifacts.require("MultiSigBioFund");

contract("ProductStore", (accounts) => {
 let productToken;
 let productStore;
 let catchRevert = require("./exceptions.js").catchRevert;

 before("creating two products and setting store address.", async () => {
     productToken = await ProductToken.deployed();
     productStore = await ProductStore.deployed();
     await productToken.createProduct("Palm Oil", true, { from: accounts[1] });
     await productToken.createProduct("Cashews", true, { from: accounts[1] });
     await productToken.setStoreAddress(productStore.address);
 });

describe("Buying a product at a sale and withdraw eth balance from sale.", async () => {
 before("Set product 1 for sale, but not product 2", async () => {
  await productToken.setProductForSale(1, 1000, { from: accounts[1] });
 });

it("cannot buy a product that is not for sale", async () => {
  await catchRevert(productStore.buyProduct(2, {from: accounts[2], value: 1000}));
});

it("cannot buy a product if doesn't pay enough", async () => {
  await catchRevert(productStore.buyProduct(1, {from: accounts[3], value: 999}));
});

it("can buy a product that is for sale", async () => {
  await productStore.buyProduct(1, {from: accounts[3], value: 1000});
  expectedOwner = accounts[3];
  const owner = await productToken.ownerOf(1);
  assert.equal(owner, expectedOwner, "The product should change ownership after purchase.");
});

it("eth has been credit to seller after sale", async () => {
  expectedBalance = 800;
  const balance = await productStore.checkEthBalance({from: accounts[1]});
  assert.equal(balance, expectedBalance, "Eth should be credit to seller after purchase.");
});

it("eth has been credit to contract owner after sale", async () => {
  expectedBalance = 100;
  const balance = await productStore.checkEthBalance({from: accounts[0]});
  assert.equal(balance, expectedBalance, "Eth should be credit to contract owner after purchase.");
});

it("seller can withdraw eth in contract", async () => {
  expectedBalance = 0;
  await productStore.withdraw(800, {from: accounts[1]});
  const balance = await productStore.checkEthBalance({from: accounts[1]});
  assert.equal(balance, expectedBalance, "Eth balance should be zero after withdraw.");
});
})

 describe("Buying a product at a sale and withdraw eth balance from sale.", async () => {
  before("Set new biodiversity fund address", async () => {
  });
 
 it("a non owner cannot change the biodiversity address", async () => {
   await catchRevert(productStore.setNewBiodiversityFund(accounts[9], {from: accounts[9]}));
 });
 
});

})
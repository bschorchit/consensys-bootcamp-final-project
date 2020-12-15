const ProductToken = artifacts.require("ProductToken");

contract("ProductToken", (accounts) => {
 let productToken;
 let catchRevert = require("./exceptions.js").catchRevert;

 before("getting the contract instance", async () => {
     productToken = await ProductToken.deployed();
 });

 describe("Creating a product and retrieving its info and ownership", async () => {
    before("create a product using accounts[1]", async () => {
      await productToken.createProduct("Palm Oil", true, { from: accounts[1] });
      expectedOwner = accounts[1];
      expectedName = "Palm Oil";
      expectedBio = true;
      expectedPrice = 0;
      expectedCreator = accounts[1];
      expectedForSale = false;
    });
   
    it("can fetch the address of an owner by product Id", async () => {
      const owner = await productToken.ownerOf(1);
      assert.equal(owner, expectedOwner, "The owner of the product created should be the second account.");
    });

   it("can fetch the name of a product by product Id", async () => {
    const name = await productToken.getProductName(1);
    assert.equal(name, expectedName, "The name of the product should be the one provided by the creator.");
   });

   it("can fetch if the product comes from biodiversity by product Id", async () => {
    const bio = await productToken.isProductBio(1);
    assert.equal(bio, expectedBio, "The bio info of the product should be the one provided by the creator.");
   });

   it("can fetch the price of a product by product Id", async () => {
    const price = await productToken.getProductPrice(1);
    assert.equal(price, expectedPrice, "The price info of the product should be 0 after product creation.");
   });

   it("can fetch the creator of a product by product Id", async () => {
    const creator = await productToken.getProductCreator(1);
    assert.equal(creator, expectedCreator, "The creator of the product should be the second account.");
   });

   it("can fetch if the product is for sale by product Id", async () => {
    const forSale = await productToken.isProductForSale(1);
    assert.equal(forSale, expectedForSale, "The product should be not be for sale right after creation.");
   });

 });

describe("Setting a product for sale after creating it.", async () => {
 before("set a product for sale using accounts[1]", async () => {
   await productToken.createProduct("Palm Oil", true, { from: accounts[1] });
   await productToken.setStoreAddress(accounts[9]);
   await productToken.setProductForSale(1, 1000, { from: accounts[1] });
   expectedPrice = 1000;
   expectedForSale = true;
 });

it("the owner can set the price of a product by product Id", async () => {
 const price = await productToken.getProductPrice(1);
 assert.equal(price, expectedPrice, "The price info of the product should be 0 after product creation.");
});

it("the owner can set the product for sale by product Id", async () => {
 const forSale = await productToken.isProductForSale(1);
 assert.equal(forSale, expectedForSale, "The product should be not be for sale right after creation.");
});

it("a non-owner cannot set the product for sale", async () => {
  await catchRevert(productToken.setProductForSale(1, 1000, {from: accounts[2]}));
 });

});

describe("Setting the store address.", async () => {
 before("set the store address using accounts[0]", async () => {
   await productToken.setStoreAddress(accounts[9], { from: accounts[0] });
   expectedStoreAddress = accounts[9];
 });

it("the contract owner can set a store address", async () => {
 const storeAddress = await productToken.getStoreAddress();
 assert.equal(storeAddress, expectedStoreAddress, "The store address should be the one set by contract owner.");
});

it("a non contract owner cannot set a store address", async () => {
  await catchRevert(productToken.setStoreAddress(accounts[9], {from: accounts[2]}));
});
});
/*
describe("Creating products and retrieving them by owner.", async () => {
  before("Create products with accounts[1]", async () => {
    await productToken.createProduct("Palm Oil", true, { from: accounts[1] });
    await productToken.createProduct("Bananas", true, { from: accounts[2] });
    await productToken.createProduct("Cacao", true, { from: accounts[1] });
    await productToken.createProduct("Cashews", true, { from: accounts[1] });
    expectedAllProductsFromOwner = [1,3,4];
  });
 
 it("can retrieve only products created by a given owner", async () => {
  const AllProductsFromOwner_0 = await productToken.getAllProductsFromOwner(accounts[2]);
  assert.equal(expectedAllProductsFromOwner[0], AllProductsFromOwner_0, "All products created by an owner should be retrieved.");
  assert.equal(expectedAllProductsFromOwner[1], AllProductsFromOwner[1], "All products created by an owner should be retrieved.");
  assert.equal(expectedAllProductsFromOwner[2], AllProductsFromOwner[2], "All products created by an owner should be retrieved.");
});

 }); */
 })
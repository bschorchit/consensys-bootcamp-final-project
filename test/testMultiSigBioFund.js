const BioFund = artifacts.require("MultiSigBioFund");

contract("BioFund", (accounts) => {
 let bioFund;
 let catchRevert = require("./exceptions.js").catchRevert;

 before(async () => {
     bioFund = await BioFund.deployed();
 });

describe("Submiting a transaction, approving and executing it.", async () => {
 before("Send funds to biodiversity fund address", async () => {
    await bioFund.sendTransaction({from: accounts[6], value: 10000})
 });

it("a non owner cannot submit a transaction for approval", async () => {
    await catchRevert(bioFund.submitTransaction(accounts[8], 100, 00, {from: accounts[3]}));
});

it("owner can submit transaction", async () => {
    await bioFund.submitTransaction(accounts[9], 100, "tree planting", {from: accounts[7]});
 });

it("transaction destination is registered correctly", async () => {
    expectedTxDestination = accounts[9];
    txDestination = await bioFund.getTransactionDestination(0);
    assert.equal(txDestination, expectedTxDestination, "The transaction destination should be the one set by owner.");
 });

it("transaction value is registered correctly", async () => {
    expectedTxValue = 100;
    txValue = await bioFund.getTransactionValue(0);
    assert.equal(txValue, expectedTxValue, "The transaction value should be the one set by owner.");
 });

it("transaction status is registered correctly", async () => {
    expectedTxExecuted = false;
    txExecuted = await bioFund.isTransactionExecuted(0);
    assert.equal(txExecuted, expectedTxExecuted, "The transaction execution status should be false.");
 });

it("transaction cannot be executed without required confirmations", async () => {
    await catchRevert(bioFund.executeTransaction(7));
});

it("transaction can be confirmed", async () => {
    await bioFund.confirmTransaction(0, {from: accounts[8]});
    expectedConfirmations = true;
    const confirmations = await bioFund.isConfirmed(0);
    assert.equal(confirmations, expectedConfirmations, "The transaction should be confirmed.");
});

it("user can correctly check if she/he has confirmed", async () => {
    expectedConfirmation = true;
    const confirmations = await bioFund.hasUserConfirmed(0, {from: accounts[8]});
    assert.equal(confirmations, expectedConfirmations, "The transaction should be confirmed.");
});

it("transaction confirmation can be revoked", async () => {
    await bioFund.revokeConfirmation(0, {from: accounts[8]});
    expectedConfirmations = false;
    const confirmations = await bioFund.isConfirmed(0);
    assert.equal(confirmations, expectedConfirmations, "The transaction should no longer be confirmed.");
});

it("user can correctly check if she/he has revoked", async () => {
    expectedConfirmation = false;
    const confirmations = await bioFund.hasUserConfirmed(0, {from: accounts[8]});
    assert.equal(confirmations, expectedConfirmations, "The transaction should be confirmed.");
});


it("transaction can be executed", async () => {
    await bioFund.confirmTransaction(0, {from: accounts[8]});
    await bioFund.executeTransaction(0, {from: accounts[7]});
});
})
})

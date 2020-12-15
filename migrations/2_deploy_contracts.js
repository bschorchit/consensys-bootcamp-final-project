var MultiSigBioFund = artifacts.require("MultiSigBioFund");
var ProductToken = artifacts.require("ProductToken");
var ProductStore = artifacts.require("ProductStore");

module.exports = function(deployer, network, accounts) {
  const owners = [accounts[7], accounts[8], accounts[9]]
  deployer.deploy(MultiSigBioFund, owners, 2).then(function() {
    return deployer.deploy(ProductToken).then(function() {
      return deployer.deploy(ProductStore, ProductToken.address, MultiSigBioFund.address)
    })
  })
}
// Deploy A, then deploy B, passing in A's newly deployed address

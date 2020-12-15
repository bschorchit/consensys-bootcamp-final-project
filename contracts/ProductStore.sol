pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./ProductToken.sol";

/// @title Nagoya Protocol Compliant Marketplace
/// @author Bárbara Schorchit
/// @notice Sells tokenized biodiversity products and complies with the Nagoya Protocol by sending 1% of the sales to a biodiversity fund
contract ProductStore is Ownable {
    using SafeMath for uint256;
    ProductToken productContract;
    address payable public biodiversityFund;
    bool public stopped = false;
    mapping (address => uint) private ethBalances;

    event LogSale (uint productId, address seller, address buyer, uint price);
    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);
    
    modifier paidEnough(uint _price) { require(msg.value >= _price); _;}
    modifier checkValue(uint _productId) {
        _;   //refund them after pay for item (why it is before, _ checks for logic before func)
        uint amountToRefund = msg.value.sub(productContract.getProductPrice(_productId));
        msg.sender.transfer(amountToRefund);
    }
    modifier productForSale(uint _productId) { require(productContract.isProductForSale(_productId)); _; }
    modifier stopInEmergency { require(!stopped); _; }
    modifier onlyInEmergency { require(stopped); _; }

    /// @dev Contract constructor sets initial Product Token address and Biodiversity Fund address
    /// @param _ptaddress The Product Token contract address
    /// @param _bfaddress The Biodiversity Fund contract address
    constructor(address _ptaddress, address payable _bfaddress) public {
        productContract = ProductToken(_ptaddress);
        require(productContract.isProductToken());
        biodiversityFund = _bfaddress;
    }

    /// @dev Fallback function allows to deposit ether.
    fallback() external payable { revert(); }

    /// @notice Register the address of the contract that creates the products
    /// @dev Circuit Breaker - Emergency mode should be triggered
    /// @param _address Deployed Product Token contract address
    function setNewProductContract(address _address) public onlyOwner onlyInEmergency {
        productContract = ProductToken(_address);
    }

    /// @notice Register the address of the Multi Signature Wallet that manages the Biodiversity Fund
    /// @dev Circuit Breaker - Emergency mode should be triggered
    /// @param newBiodiversityFund Deployed Biodiversity Fund contract address
    /// @return biodiversityFund The registered address
    function setNewBiodiversityFund(address payable newBiodiversityFund) public onlyOwner onlyInEmergency returns (address) {
        biodiversityFund = newBiodiversityFund;
        return biodiversityFund;
    }

    /// @notice Buy a product in the marketplace
    /// @dev It will be stopped in case of emergency
    /// @param productId The id of the product to be purchased
    function buyProduct(uint productId) public payable stopInEmergency productForSale(productId) paidEnough(productId) checkValue(productId) {
        address seller = productContract.ownerOf(productId);
        uint price = productContract.getProductPrice(productId);
        ethBalances[owner()] = ethBalances[owner()].add((price.mul(10)).div(100)); //store's fee
        if (productContract.isProductBio(productId)) {
            ethBalances[seller] = ethBalances[seller].add((price.mul(80)).div(100));
            biodiversityFund.transfer((price.mul(10)).div(100));
        } else {
            ethBalances[seller] = ethBalances[seller].add((price.mul(90)).div(100));
        }
        productContract.setProductNotForSale(productId);
        productContract.safeTransferFrom(seller, msg.sender, productId);
        emit LogSale(productId, seller, msg.sender, price);
    }

    /// @notice Withdraw money made in sales
    /// @param withdrawAmount The amount of money to be withdraw
    /// @return The user's balance in the contract
    function withdraw(uint withdrawAmount) public returns (uint) {
        require(ethBalances[msg.sender] >= withdrawAmount);
        ethBalances[msg.sender] = ethBalances[msg.sender].sub(withdrawAmount);
        msg.sender.transfer(withdrawAmount);
        emit LogWithdrawal(msg.sender, withdrawAmount,ethBalances[msg.sender]);
        return ethBalances[msg.sender];
    }

    /// @notice Returns user's balance
    /// @return The user's balance in the contract
    function checkEthBalance() public view returns (uint) {
        return ethBalances[msg.sender];
    }

    /// @notice Circuit Breaker - Triggers emergency mode
    function declareEmergency() public onlyOwner {
        stopped = true;
    }

    /// @notice Circuit Breaker - Ends emergency mode
    function endEmergency() public onlyOwner {
        stopped = false;
    }

}
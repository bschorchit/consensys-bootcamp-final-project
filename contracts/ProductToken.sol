pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/// @title Tokenized Biodiversity Products
/// @author Bárbara Schorchit
/// @notice Create tokenized (ERC721) versions of biodiverdity products
contract ProductToken is ERC721, Ownable {

  address internal storeAddress;
  uint newProductId;

  struct Product {
    string name;
    bool bio;
    uint price;
    address creator;
    bool forSale;
  }

  mapping (uint => Product) idToProduct;

  modifier onlyProductOwner(uint _productId) { require(ownerOf(_productId) == msg.sender); _; }

  /// @dev Contract constructor calls ERC721 constructor and pass the name and symbol parameters
  constructor() ERC721("Tokenized Biodiversity Products", "TBP") public {
    newProductId = 0;
  }

  /// @notice Register the contract address for the token marketplace
  /// @param _address Deployed Product Store contract address
  function setStoreAddress(address _address) public onlyOwner {
    storeAddress = _address;
  }

  /// @notice Create a new ERC721 Tokenized Biodiversity Product 
  /// @dev Calls internal function to create product
  /// @param name Product name
  /// @param bio if the product is biodiversity based or not
  function createProduct(string memory name, bool bio) public {
    _createProduct(name, bio);
  }

  /// @notice Create a new ERC721 Tokenized Biodiversity Product 
  /// @dev Calls ERC721 function
  /// @param _name The name of the product to be created
  /// @param _bio if the product is biodiversity based or not
  function _createProduct(string memory _name, bool _bio) internal {
    newProductId = newProductId.add(1);
    idToProduct[newProductId] = Product(_name, _bio, 0, msg.sender, false);
    _safeMint(msg.sender, newProductId);
  }

  /// @notice Set a Product for Sale at the Marketplace
  /// @dev Requires a product store contract address to be registered first
  /// @param productId The Id of the product/ERC721 that will be set for sale
  /// @param price The price of the product at the marketplace
  function setProductForSale(uint productId, uint price) public onlyProductOwner(productId) {
    require(storeAddress != address(0));
    setApprovalForAll(storeAddress, true);
    idToProduct[productId].price = price;
    idToProduct[productId].forSale = true;
  }

  /// @notice Take product off the the Marketplace
  /// @dev Store contract can call it after the product is sold
  /// @param productId The Id of the product/ERC721 that will be set for sale
  function setProductNotForSale(uint productId) public {
    require(msg.sender == storeAddress);
    idToProduct[productId].forSale = false;
  }

  /// @notice Returns the name of a product
  /// @param id The Id of the product/ERC721 
  /// @return name returns the name of the product
  function getProductName (uint id) external view returns (string memory name) {
    return idToProduct[id].name;
  }

  /// @notice Return if the product is biodiversity based or not
  /// @param id The Id of the product/ERC721 
  /// @return bio returns if the product is biodiversity based or not
  function isProductBio (uint id) external view returns (bool bio) {
    return idToProduct[id].bio;
  }

  /// @notice Returns the price of a product
  /// @param id The Id of the product/ERC721 
  /// @return price returns the price of a product
  function getProductPrice (uint id) external view returns (uint price) {
    return idToProduct[id].price;
  }

  /// @notice Returns the creator of a product
  /// @param id The Id of the product/ERC721 
  /// @return creator returns the creator of a product
    function getProductCreator (uint id) external view returns (address creator) {
    return idToProduct[id].creator;
  }
  
  /// @notice Returns if a product is for sale or not
  /// @param id The Id of the product/ERC721 
  /// @return forSale returns if the product is for sale or not
    function isProductForSale (uint id) external view returns (bool forSale) {
    return idToProduct[id].forSale;
  }

  /// @notice Returns the address registered for the marketplace
  /// @return storeAddress returns the address registered for the marketplace
  function getStoreAddress () external view returns (address) {
    return storeAddress;
  }

  /// @notice Returns true
  /// @dev This function is useful to confirm if the address passed to ProductStore.sol constructor is correct
  function isProductToken() external pure returns (bool) { return true; }
}
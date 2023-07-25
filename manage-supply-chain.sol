pragma solidity ^0.8.0;

contract SupplyChain {
    // Define a struct to represent a product
    struct Product {
        uint id;
        string name;
        uint price;
        address owner;
        address[] history;
    }

    // Define an array to store the products
    Product[] public products;

    // Define an event to emit when a product is added
    event ProductAdded(uint indexed id, string name, uint price, address owner);

    // Define a function to add a new product to the array
    function addProduct(string memory _name, uint _price) public {
        uint productId = products.length;
        products.push(Product(productId, _name, _price, msg.sender, new address[](0)));
        emit ProductAdded(productId, _name, _price, msg.sender);
    }

    // Define a function to get the owner of a product
    function getOwner(uint _productId) public view returns (address) {
        return products[_productId].owner;
    }

    // Define a function to get the price of a product
    function getPrice(uint _productId) public view returns (uint) {
        return products[_productId].price;
    }

    // Define a function to transfer ownership of a product
    function transferOwnership(uint _productId, address _newOwner) public {
        // Check if the sender is the current owner of the product
        require(msg.sender == products[_productId].owner, "You are not the owner of this product.");

        // Add the current owner to the history array
        products[_productId].history.push(products[_productId].owner);

        // Set the new owner of the product
        products[_productId].owner = _newOwner;
    }

    // Define a function to get the history of ownership for a product
    function getHistory(uint _productId) public view returns (address[] memory) {
        return products[_productId].history;
    }
}
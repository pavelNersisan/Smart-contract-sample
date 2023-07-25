pragma solidity ^0.8.0;

contract Marketplace {

    struct Product {
        uint id;
        address seller;
        string name;
        string description;
        uint price;
        uint quantity;
        bool available;
    }

    mapping(uint => Product) public products;
    uint public totalProducts;

    event ProductAdded(uint indexed id, address indexed seller, string name, string description, uint price, uint quantity);
    event ProductUpdated(uint indexed id, address indexed seller, string name, string description, uint price, uint quantity);
    event ProductRemoved(uint indexed id, address indexed seller);

    function addProduct(string memory _name, string memory _description, uint _price, uint _quantity) public returns (uint) {
        uint productId = totalProducts + 1;
        products[productId] = Product(productId, msg.sender, _name, _description, _price, _quantity, true);
        totalProducts++;
        emit ProductAdded(productId, msg.sender, _name, _description, _price, _quantity);
        return productId;
    }

    function updateProduct(uint _id, string memory _name, string memory _description, uint _price, uint _quantity) public {
        Product storage product = products[_id];
        require(product.available, "The product is not available.");
        require(product.seller == msg.sender, "You are not the seller of this product.");

        product.name = _name;
        product.description = _description;
        product.price = _price;
        product.quantity = _quantity;

        emit ProductUpdated(_id, msg.sender, _name, _description, _price, _quantity);
    }

    function removeProduct(uint _id) public {
        Product storage product = products[_id];
        require(product.available, "The product is not available.");
        require(product.seller == msg.sender, "You are not the seller of this product.");

        product.available = false;
        emit ProductRemoved(_id, msg.sender);
    }

    function buyProduct(uint _id, uint _quantity) public payable {
        Product storage product = products[_id];
        require(product.available, "The product is not available.");
        require(product.quantity >= _quantity, "The product quantity is not sufficient.");

        uint totalPrice = product.price * _quantity;
        require(msg.value == totalPrice, "The payment amount is incorrect.");

        product.quantity -= _quantity;
        if (product.quantity == 0) {
            product.available = false;
        }

        payable(product.seller).transfer(totalPrice);
    }
}
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.7;

contract Data{
    
    struct User {
        string name;
        string email;
        string shippingAddress;
        
    }
    
    struct Product {
        uint productId;
        string productName;
        uint quantity;
        uint price;
    }

    struct Invoice {
        uint invoiceId;
        address userAddress;
        uint[] productIds;
        uint totalAmount;
        bool isPaid;
    }

    mapping(address => User) public users;
    mapping(uint => Product) public products;
    mapping(uint => Invoice) public invoices;

    uint public nextProductId = 1;
    uint public nextInvoiceId = 1;

    event InvoiceCreated(uint invoiceId, address indexed userAddress, uint totalAmount);

    modifier onlyRegisteredUser() {
        require(bytes(users[msg.sender].email).length > 0, "User not registered.");
        _;
    }

    function registerUser(string memory _name, string memory _email,string memory _shippingAddress) public {
        users[msg.sender] = User( _name, _email, _shippingAddress);
    }

    function addProduct(string memory _productName, uint _quantity, uint _price) public {
        products[nextProductId] = Product(nextProductId, _productName, _quantity, _price);
        nextProductId++;
    }

    function completeInvoice(uint _invoiceId) public onlyRegisteredUser {
        Invoice storage invoice = invoices[_invoiceId];
        require(invoice.userAddress == msg.sender, "You can only process your own invoices.");
        invoice.isPaid = true;
    }

    function getProductDetails(uint _productId) public view returns (string memory, uint, uint) {
        Product memory product = products[_productId];
        return (product.productName, product.quantity, product.price);
    }

    function getInvoiceDetails(uint _invoiceId) public view returns (address, uint[] memory, bool){
        Invoice memory invoice = invoices[_invoiceId];
        return(invoice.userAddress, invoice.productIds, invoice.isPaid);
    }
} 

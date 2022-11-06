// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ecommerce {
    address public manager;
    uint256 sellerNO;
    uint256 productNO;

    struct Seller {
        uint256 sellerNo;
        string name;
        string email;
        uint256 totalProducts;
        bool isRegistered;
    }

    struct Product {
        uint256 productID;
        string name;
        uint256 price;
    }

    struct ProductInfo {
        string name;
        uint256 price;
        address seller;
        bool isAvalible;
    }

    mapping(address => Seller) public sellerinfomap;
    mapping(address => Product[]) public productlist;
    mapping(address => uint256) public buyerProduct;
    mapping(uint256 => ProductInfo) public productInfolist;

    constructor() {
        manager = msg.sender;
        productNO = 7884;
    }

    modifier onlyManager() {
        require(manager == msg.sender, "You are't authorised!!");
        _;
    }

    function regiSellers(
        address seller,
        string memory _name,
        string memory _email
    ) public onlyManager {
        Seller memory tempSeller;
        tempSeller.name = _name;
        tempSeller.email = _email;
        tempSeller.isRegistered = true;
        tempSeller.sellerNo = sellerNO;
        sellerinfomap[seller] = tempSeller;
        sellerNO++;
    }

    function regiProduct(string memory productName, uint256 _price) public {
        require(
            sellerinfomap[msg.sender].isRegistered == true,
            "You aren't a registered seller."
        );
        Product memory tempProduct;
        sellerinfomap[msg.sender].totalProducts++;
        tempProduct.name = productName;
        tempProduct.price = _price;
        tempProduct.productID = productNO;
        productlist[msg.sender].push(tempProduct);

        productInfolist[productNO].name = productName;
        productInfolist[productNO].price = _price;
        productInfolist[productNO].seller = msg.sender;
        productInfolist[productNO].isAvalible = true;

        productNO++;
    }

    function buyProduct(uint256 _productId) public {
        require(manager != msg.sender, "Manager can't buy product.");
        require(
            sellerinfomap[msg.sender].isRegistered == false,
            "Seller cant't buy product."
        );
        require(
            productInfolist[_productId].isAvalible == true,
            "Product not found."
        );
        buyerProduct[msg.sender] = _productId;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Delivery {
    address internal buyer;
    address internal seller;
    address internal delivery;
    uint256 public price;

    mapping(address => string) public buyermap;
    mapping(address => string) public sellermap;
    mapping(address => string) public deliverymap;
    // uint public key =  uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,msg.sender,buyer,seller,productNO)));
    string public key =
        "81852687181624010164825950168794651337628601408253669643207114767524866923196";
    string public key1 =
        "81852687181624010164825950168794651337628601408253669643"; // seller to deliver viceversa
    string public key2 = "4651337628601408253669643207114767524866923196"; // buyer to deliver viceversa

    constructor(
        address _buyer,
        address _seller,
        address _delivery
    ) {
        buyer = _buyer;
        seller = _seller;
        delivery = _delivery;
        price = 7554;
    }

    function compare(string memory s1, string memory s2)
        internal
        pure
        returns (bool)
    {
        return
            keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));
    }

    function concatenate(string memory s1, string memory s2)
        internal
        pure
        returns (string memory)
    {
        return string(abi.encodePacked(s1, s2));
    }

    function disPrivateKey() external {
        sellermap[seller] = "8185268718162401016482595016879";
        deliverymap[delivery] = "4651337628601408253669643";
        buyermap[buyer] = "207114767524866923196";
    }

    function selltoDeliAUTH(string memory deliveryKey)
        external
        view
        returns (bool)
    {
        require(msg.sender == seller, "Only seller can access this.");
        require(
            compare(concatenate(sellermap[seller], deliveryKey), key1),
            "Delivery man's key dosen't match."
        );
        return true;
    }

    function DelitosellAUTH(string memory SellerKey)
        external
        payable
        returns (bool)
    {
        require(msg.sender == delivery, "Only delivery man can access this.");
        require(msg.value == price, "Enter the exact amount of ether. ");
        require(
            compare(concatenate(SellerKey, deliverymap[delivery]), key1),
            "Seller's key dosen't match."
        );
        payable(address(this)).transfer(msg.value);
        return true;
    }

    function buyertoDeliAUTH(string memory deliveryKey)
        internal
        view
        returns (bool)
    {
        require(msg.sender == buyer, "Only buyer can access this.");
        require(
            compare(concatenate(deliveryKey, buyermap[buyer]), key2),
            "Delivery man's key dosen't match."
        );
        return true;
    }

    function DelitobuyerAUTH(string memory BuyerKey)
        internal
        view
        returns (bool)
    {
        require(msg.sender == delivery, "Only delivery man can access this.");
        require(
            compare(concatenate(deliverymap[delivery], BuyerKey), key2),
            "Buyer's key dosen't match."
        );
        return true;
    }


    function isSuccessfull(string memory _BuyerKey,string memory _deliveryKey) public returns(bool){
        require(DelitobuyerAUTH(_BuyerKey) == buyertoDeliAUTH(_deliveryKey), "delivery isnt successfull.");
        payable(delivery).transfer(price);
        return true;

    }
}

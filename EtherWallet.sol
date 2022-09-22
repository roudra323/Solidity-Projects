// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherWallet{
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable{}

    function getBalance() public view returns(uint){
        return address(this).balance;
    }


    modifier onlyOwner(){
        require(msg.sender == owner,"Caller is not the owner!! ");
        _;
    }

    function sendBal(address payable _to,uint _bal) external onlyOwner payable{
        require(owner != _to,"You is not able to transfer in his own account! ");
        require(getBalance() >= 50 ,"Contract Balance is less than 50..");
        _to.transfer(_bal);
    }

    function withdraw(uint _amount) external onlyOwner{
        require(getBalance() >= 100,"Contract balance is less than 100..");
        owner.transfer(_amount);
    }
}

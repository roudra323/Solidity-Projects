// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Piggybank{

    event Deposit(uint amount);
    event Withdraw(uint amount);
    address public owner;

    constructor(){
        owner = msg.sender;
    }
    receive() external payable {
        emit Deposit(msg.value);
    }

    function withdraw() external  {
        require(msg.sender == owner, "Only owner can withdraw the amount!");
        emit Withdraw(address(this).balance);
        selfdestruct(payable(owner));
    }
}

//lottery project
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery{
    address public manager;
    address payable[] public participants;

    constructor(){
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value == 1 ether, "Amount of ether is less than 1");
        participants.push(payable(msg.sender));
    }

    modifier onlyOwner(){
        require(msg.sender == manager, "Requester isn't winner.");
        _;
    }

    function getBalance() public view onlyOwner returns(uint) {
        return address(this).balance;
    }

    function randomWinSelect() public onlyOwner{
        require(participants.length >= 3, "Participents are less than 3!!");
        uint x =  uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,msg.sender,participants.length))) % participants.length;
        address payable winner = participants[x];
        winner.transfer(getBalance());
        participants = new address payable[](0);
 }

}

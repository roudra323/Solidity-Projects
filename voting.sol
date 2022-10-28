// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting{
    address public manager;
    uint public numOfvoters;
    uint public totalVoters;
    uint public miniVoter;

    constructor(){
        manager = msg.sender;
        miniVoter = 10;
    }

    struct voteInfo{
        uint totalVotes;
        bool hasVoted;
        address votedTo;
    }

    mapping(address=>voteInfo) public voting;

    address[] public voters;

    function addVoter(address vAdd) public {
        require(msg.sender==manager,"You are not authorised!!");
        require(manager != vAdd,"You can't add yourself as a voter!!");
        voters.push(vAdd);
        voting[vAdd].hasVoted=false;
        voting[vAdd].totalVotes=0;
        totalVoters++;
    }

    function vote(address vAdd) public{
        require(numOfvoters>=miniVoter,"There is less than 10 voters..");
        require(voting[msg.sender].hasVoted==false,"You cant vote twice.");
        require(manager != msg.sender,"Manager can't vote.");
        voting[msg.sender].votedTo = vAdd;
        voting[msg.sender].hasVoted= true;
        voting[vAdd].totalVotes++;
    }

}

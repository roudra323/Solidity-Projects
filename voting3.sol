// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PresenterEelection {
    address public manager;

    uint256 public totalVoters;
    uint256 public miniVoter;
    uint256 totaltotalVoters;

    constructor() {
        manager = msg.sender;
        miniVoter = 3;
    }

    struct voteInfo {
        uint256 totalVotes;
        bool hasVoted;
        address votedTo;
        string name;
        bool isRegistered;
    }

    mapping(address => voteInfo) public voting;

    address[] public voters;


    function resetter() internal {
        for (uint256 i = 0; i < totalVoters; i++) {
            voting[voters[i]].hasVoted = false;
            voting[voters[i]].totalVotes = 0;
            voting[voters[i]].votedTo = address(0x0);
        }
        totaltotalVoters = 0;
    }


    function addVoter(address vAdd, string memory _name) public {
        require(msg.sender == manager, "You are not authorised!!");
        require(manager != vAdd, "You can't add yourself as a voter!!");
        require(
            voting[vAdd].isRegistered == false,
            "Manager can't add a Voter twice"
        );
        voters.push(vAdd);
        voting[vAdd].hasVoted = false;
        voting[vAdd].totalVotes = 0;
        voting[vAdd].name = _name;
        voting[vAdd].isRegistered = true;
        totalVoters++;
    }

    function vote(address vAdd) public {
        require(totalVoters >= miniVoter, "There is less than 3 voters..");
        require(voting[msg.sender].hasVoted == false, "You cant vote twice.");
        require(manager != msg.sender, "Manager can't vote.");
        require(msg.sender != vAdd, "you can not vote yourself");
        require(voting[msg.sender].isRegistered == true, "you are not voter");
        voting[msg.sender].votedTo = vAdd;
        voting[msg.sender].hasVoted = true;
        voting[vAdd].totalVotes++;
        totaltotalVoters++;
    }

    function pickPresenter() public returns (address, string memory) {
        require(msg.sender == manager, "You are not authorised!!");
        require(
            totalVoters == totaltotalVoters && totaltotalVoters > 0,
            "Everyone should vote"
        );

        uint256 largest = 0;
        address presenter;
        for (uint256 i = 0; i < totalVoters; i++) {
            if (voting[voters[i]].totalVotes > largest) {
                largest = voting[voters[i]].totalVotes;
                presenter = voters[i];
            }
        }
        resetter();
        return (presenter, voting[presenter].name);
    }
}

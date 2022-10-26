// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrowdFunding {
    mapping(address => uint256) public contributers;
    address public manager;
    uint256 public minimumContribution;
    uint256 public deadline;
    uint256 public target;
    uint256 public raisedAmount;
    uint256 public noOfContributors;

    struct Request {
        string description;
        address payable recipient;
        uint256 value;
        bool completed;
        uint256 noOfVoters;
        mapping(address => bool) voters;
    }

    mapping(uint256 => Request) public requests;
    uint256 public numRequests;

    constructor(uint256 _target, uint256 _deadline) {
        target = _target;
        deadline = block.timestamp + _deadline; // _deadline is time in second input
        minimumContribution = 100 wei;
        manager = msg.sender;
    }

    function sendEth() public payable {
        require(block.timestamp < deadline, "Deadline has passed..");
        require(
            msg.value >= minimumContribution,
            "Minimum contribution is not met!!"
        );

        if (contributers[msg.sender] == 0) {
            noOfContributors++;
        }
        contributers[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }

    function getContractbal() public view returns (uint256) {
        return address(this).balance;
    }

    function refund() public {
        require(
            block.timestamp > deadline && raisedAmount < target,
            "You are not eligible for a refund"
        );
        require(contributers[msg.sender] >= 0);
        address payable user = payable(msg.sender);
        user.transfer(contributers[msg.sender]);
        contributers[msg.sender] = 0;
    }

    modifier onlyManager() {
        require(
            msg.sender == manager,
            " Only the manager can call the function!!"
        );
        _;
    }

    function createRequests(
        string memory _description,
        address payable _recipient,
        uint256 _value
    ) public onlyManager {
        Request storage newRequest = requests[numRequests];
        numRequests++;
        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;
    }

    function voteRequest(uint256 _requestNo) public {
        require(contributers[msg.sender] > 0, "You must be a contributer!");
        Request storage thisRequest = requests[_requestNo];
        require(
            thisRequest.voters[msg.sender] == false,
            "You have already voted."
        );
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    }

    function makePayment(uint256 _requestNo) public onlyManager {
        require(raisedAmount >= target);
        Request storage thisRequest = requests[_requestNo];
        require(
            thisRequest.completed == false,
            "The request has been completed."
        );
        require(
            thisRequest.noOfVoters > noOfContributors / 2,
            "Majority dosent support!!"
        );
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EventContract{
    struct Event {
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }

    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name,uint date,uint price,uint ticketCount) external {
        require(date > block.timestamp,"You can organize event for future date");
        require(ticketCount>0,"You can organize event if you create more than 0 tickets.");

        events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextId++;
    }

    modifier rules(uint id){
        require(events[id].date != 0, "Event does not exist");
        require(events[id].date > block.timestamp, "Event has already occured");
        _;
    }

    function buyTicket(uint id,uint quantity) external rules(id) payable{
        require(msg.value >= (events[id].price*quantity), "Ethere is not enough");
        require(events[id].ticketRemain>=quantity, "Not enough tickets");
        events[id].ticketRemain-=quantity;
        tickets[msg.sender][id] += quantity;
    }

    function transferticket(uint id, uint quantity, address to) external rules(id) {
        require(tickets[msg.sender][id] >= quantity, "You don't have enough");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id] += quantity; 
    }

}


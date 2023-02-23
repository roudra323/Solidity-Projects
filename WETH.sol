//SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./ERC20.sol";

contract WETH is ERC20{
    event Deposit(address indexed account,uint amount);
    event Withdraw(address indexed account,uint amount);


    constructor() ERC20("Wrapped Ether","WETH",18){}

    fallback() external payable{
        deposit();
    }

    function deposit() public payable {
        _mint(msg.sender,msg.value);
        emit Deposit(msg.sender,msg.value);
    }


    function withdraw(uint _amount) public {
        _burn(msg.sender,_amount);
        payable(msg.sender).transfer(_amount);
        emit Deposit(msg.sender,_amount);
    }
}

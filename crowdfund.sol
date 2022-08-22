// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


contract Crowdfund {
    address payable public owner;
    uint public start;
    uint public end;
    uint public goal;
    uint public raisedAmount;

    mapping (address => uint) public funders;

    struct Request {
        address payable recipient;
        uint value;
        bool completed;
    }

    constructor (uint _targetAmount) {
        goal = _targetAmount;
        start = block.timestamp;
        end = block.timestamp + 2 days;
        owner = payable(msg.sender);
    }
    
    function sendfund() public payable{
        require(block.timestamp <=end,"crowdfunding over");
        funders[msg.sender]+=msg.value;
        raisedAmount+=msg.value;
    }

    function refund() public {
        require(block.timestamp > end && raisedAmount < goal, "You are not eligible for refund");
        require(funders[msg.sender] > 0);

        address payable user = payable(msg.sender);
        user.transfer(funders[msg.sender]);
        funders[msg.sender] = 0;
    }

    function getfund() public {
        require(msg.sender==owner,"Not owner");
        require(block.timestamp>end,"Funding period is not over");
        require(raisedAmount>=goal,"Insufficient funds");

        owner.transfer(raisedAmount);
        raisedAmount=0;
    }
}
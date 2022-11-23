// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "hardhat/console.sol";

contract Opensource{
         mapping(address => uint) public Contributors;
         address public Manager;
         uint public minContribution;
          uint public deadline;
          uint public target;
          uint public raiseAmount;
          uint public noOfContributors;
          
          struct Request{
              string description;
              address payable recepient;
              uint value;
              bool isCompleted;
              uint notOfVoters;
              mapping(address => bool) voters;

          }

          mapping(uint => Request) public requests;
           uint public numRequest;

          constructor(uint _target , uint _deadline){
              target = _target;
              deadline = block.timestamp + _deadline;
              minContribution = 100 wei;
              Manager = msg.sender;
          }


          function sendEth() public payable{
              require(block.timestamp < deadline, "Deadline is passed");
              require(msg.value >= 100 wei, "min contribution is not met");
               
              if(Contributors[msg.sender] == 0){
                  noOfContributors++;
              }

              Contributors[msg.sender] += msg.value;
              raiseAmount += msg.value;

          }

       function getContractBalance() public view returns(uint) {
           return address(this).balance;
       }

       function refund() public{
           require(block.timestamp > deadline && raiseAmount <target,"you are ineligible");
           require(Contributors[msg.sender]>0);
           address payable user= payable(msg.sender);
           user.transfer(Contributors[msg.sender]);
           Contributors[msg.sender]=0;
       }

       modifier OnlyManager(){
        require(msg.sender== Manager,"Only Manager can call the function");
        _;
       }

       function createRequest( string memory _description, address payable _receipent, uint _value)public {
           Request storage newRequest = requests[numRequest];
           numRequest++;
           newRequest.description=_description;
           newRequest.recepient =_receipent;
           newRequest.value = _value;
           newRequest.isCompleted= false;
           newRequest.notOfVoters=0;
       }

          function voteRequest(uint _requestno) public {
            require(Contributors[msg.sender]>0,"you are not contributor");
              Request storage thisRequest=requests[_requestno];
              require(thisRequest.voters[msg.sender]==false,"you voted already");
              thisRequest.voters[msg.sender]=true;
              thisRequest.notOfVoters++;
          }

          function makePayment(uint _requestno) public OnlyManager{
              require(raiseAmount>= target);
              Request storage thisRequest=requests[_requestno];
              require(thisRequest.isCompleted==false,"Already completed");
              require(thisRequest.notOfVoters>noOfContributors/2,"Majority not met");
              thisRequest.recepient.transfer(thisRequest.value);
                  thisRequest.isCompleted=true;

          }

}

 
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    // state variable : 
    // manager -> deploy , pick winner , money transfer ( contract price ) , reset 
    // player[] -> enter -> min amt to enter ... aggregated amt in contract is the winning price 
    //            -> unique person in players

    address public manager;
    address payable[] public players;

    constructor() {
        manager = msg.sender;
    }

    function alreadyEntered() view private returns(bool) {
        for(uint i=0 ; i<players.length ; i++){
            if(players[i] == payable(msg.sender)) return true;
        }
        return false;
    }

    function enterLottery() payable public {
        // false -> message
        require(msg.sender != manager , "Manager Cannot enter the lottery");
        require(alreadyEntered() == false , "player already enterd");
        require(msg.value > 2 , "min 3 wei required to enter the lotter"); // min value to enter 1 wei
        players.push(payable(msg.sender));
    } 

    function getWinner() public {
        require(msg.sender == manager , "u r not authorised");
        // require(players.length == 0 , "no players enterd the lottery");
        uint index = getRandom()%players.length;
        address contractAddress = address(this);
        players[index].transfer(contractAddress.balance);

        // reset the lottery
        players = new address payable[](0);
    }

    function getRandom() private view returns(uint){
        return uint(sha256(abi.encodePacked(block.difficulty , block.number , players)));
    }

    function getPlayers() view public returns(address payable[] memory) {
        return players;
    }

    function getTotalAmtInLottery() view public returns(uint) {
        return address(this).balance;
    }

}
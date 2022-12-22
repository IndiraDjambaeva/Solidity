//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MopedShop {
    mapping (address => bool) public buyers ;
    uint256 public price = 2 ether;   //uint256: 2000000000000000000 wei
    address public owner;
    address public shopAddress;
    bool fullyPaid; //false

    event ItemFullyPaid(uint _price, address _shopAddress);

    constructor() {
        owner = msg.sender; //address: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
        shopAddress = address(this);
    }

    function getBuyer(address _addr) public view returns(bool) {
        require(owner == msg.sender, "You are not an owner");

        return buyers[_addr];
    }

    function addBuyer(address _addr) public {
        require(owner == msg.sender, "You are not an owner!");

        buyers[_addr] = true;
    }

    function getBalance() public view returns(uint) {
        return shopAddress.balance;
    }

    function withdrawAll() public {
        require(owner == msg.sender && fullyPaid && shopAddress.balance > 0, "Rejected");

        address payable receiver = payable(msg.sender);

        receiver.transfer(shopAddress.balance);
    }

    receive() external payable {
        //address: 0x7EF2e0048f5bAeDe046f6BF797943daF4ED8CB47
        require(buyers[msg.sender] && msg.value <= price && !fullyPaid, "Rejected");

        if(shopAddress.balance == price) {
            fullyPaid = true;

            emit ItemFullyPaid(price, shopAddress);
        }

        
    
    }
    
}

//shopAddress: 0xd9145CCE52D386f254917e481eB44e9943F39138
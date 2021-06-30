// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract CarSelling  is OwnableUpgradeable {
    
    event Added(uint256 index);
    event carBuyed(uint256 carId);
    event withdrawl(uint256 amount,uint256 date);
    
    struct Product{
        address creator;
        string carName;
        uint256 sellPrice;
        uint256 launchDate;
        uint productId;
    }
    
    struct Buyer{
        address carOwner;
        uint productId;
        uint buyDate;
        uint buyPrice;
    }
    mapping(uint => Product) public inventory;
    mapping(uint =>Buyer) public soldCars;
    uint256  public carId;

    function initialize(address owner) public initializer {
        __Ownable_init();
        transferOwnership(owner);
        carId=0;
    }
    //sellPrice is in wei
    function addCarToInventory(string memory carName,uint256 sellPrice) public onlyOwner returns (bool) {
        Product memory newCar =Product({creator: msg.sender,sellPrice:sellPrice,carName: carName, productId: carId, launchDate: block.timestamp});
        inventory[carId]=newCar;
        carId +=1;
        emit Added(carId-1);
        return true;
    }
    
    function carBuyer(address buyerAddress,uint productId)public payable returns(bool) {
        require(productId<carId,"Not existed product");
        require(buyerAddress!=address(0),"Buyer Address can't be null");
        require(soldCars[productId].carOwner==address(0),"Car already sold");
        Product storage _product=inventory[productId];
        require(msg.value==_product.sellPrice,"Ammount is not correct");
        Buyer memory buyer=Buyer({carOwner:buyerAddress,productId:productId,buyDate:block.timestamp,buyPrice:msg.value});
        soldCars[productId]=buyer;
        emit carBuyed(productId);
        return true;
    }
    function withdrawFund(address payable _to,uint amount) public payable onlyOwner returns(uint){
        require(address(this).balance>=amount && amount>0,"Contract Balance 0 or less than amount specified ");
        _to.transfer(amount);
        emit withdrawl(amount,block.timestamp);
        return amount;
    }
    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }
}
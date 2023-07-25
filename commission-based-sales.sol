pragma solidity ^0.8.0;

contract SalesProgram {
    address public owner;
    mapping(address => uint256) public sales;
    mapping(address => uint256) public commissionLevels;

    constructor() {
        owner = msg.sender;
    }

    function addSale(address user, uint256 saleAmount) public {
        require(msg.sender == owner, "Only the owner can add sales.");
        sales[user] += saleAmount;
    }

    function setCommissionLevel(address user, uint256 level) public {
        require(msg.sender == owner, "Only the owner can set commission levels.");
        commissionLevels[user] = level;
    }

    function calculateCommission(address user, uint256 commissionRate) public view returns (uint256) {
        require(msg.sender == owner, "Only the owner can calculate commissions.");
        require(commissionRate > 0 && commissionRate <= 100, "Invalid commission rate.");
        uint256 commissionAmount = sales[user] * commissionRate / 100;
        uint256 commissionLevel = commissionLevels[user];
        if (commissionLevel == 1) {
            commissionAmount *= 2;
        } else if (commissionLevel == 2) {
            commissionAmount *= 3;
        } else if (commissionLevel == 3) {
            commissionAmount *= 4;
        }
        return commissionAmount;
    }

    function claimCommission(uint256 commissionAmount) public {
        require(sales[msg.sender] > 0, "No sales available.");
        require(commissionAmount > 0 && commissionAmount <= sales[msg.sender], "Invalid commission amount.");
        sales[msg.sender] -= commissionAmount;
        payable(msg.sender).transfer(commissionAmount);
    }
}

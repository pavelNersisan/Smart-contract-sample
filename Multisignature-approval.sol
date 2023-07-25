pragma solidity ^0.8.0;

contract MultiSigApproval {
    address[] public owners;
    uint public requiredApprovals;
    mapping(address => bool) public isOwner;
    mapping(address => bool) public hasApproved;
    uint public transactionCount;
    
    event TransactionCreated(uint indexed id, address indexed destination, uint value, bytes data);
    event TransactionApproved(uint indexed id, address indexed approver);
    event TransactionCancelled(uint indexed id);

    struct Transaction {
        uint id;
        address destination;
        uint value;
        bytes data;
        uint approvals;
        bool executed;
    }

    mapping(uint => Transaction) public transactions;

    constructor(address[] memory _owners, uint _requiredApprovals) {
        require(_owners.length > 0, "The list of owners must not be empty.");
        require(_requiredApprovals > 0 && _requiredApprovals <= _owners.length, "The number of required approvals must be between 1 and the number of owners.");

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "An owner address cannot be zero.");
            require(!isOwner[owner], "Duplicate owner address.");
            owners.push(owner);
            isOwner[owner] = true;
        }

        requiredApprovals = _requiredApprovals;
    }

    function createTransaction(address _destination, uint _value, bytes memory _data) public returns (uint) {
        require(isOwner[msg.sender], "You are not an owner.");
        uint transactionId = transactionCount + 1;
        transactions[transactionId] = Transaction(transactionId, _destination, _value, _data, 0, false);
        transactionCount++;
        emit TransactionCreated(transactionId, _destination, _value, _data);
        return transactionId;
    }

    function approveTransaction(uint _id) public {
        require(isOwner[msg.sender], "You are not an owner.");
        Transaction storage transaction = transactions[_id];
        require(!transaction.executed, "The transaction has already been executed.");
        require(!hasApproved[msg.sender], "You have already approved this transaction.");

        transaction.approvals++;
        hasApproved[msg.sender] = true;
        emit TransactionApproved(_id, msg.sender);

        if (transaction.approvals == requiredApprovals) {
            executeTransaction(_id);
        }
    }

    function cancelTransaction(uint _id) public {
        require(isOwner[msg.sender], "You are not an owner.");
        Transaction storage transaction = transactions[_id];
        require(!transaction.executed, "The transaction has already been executed.");

        transaction.executed = true;
        emit TransactionCancelled(_id);

        for (uint i = 0; i < owners.length; i++) {
            hasApproved[owners[i]] = false;
        }
    }

    function executeTransaction(uint _id) private {
        Transaction storage transaction = transactions[_id];
        require(!transaction.executed, "The transaction has already been executed.");

        transaction.executed = true;
        (bool success,) = transaction.destination.call{value: transaction.value}(transaction.data);
        require(success, "Transaction execution failed.");

        for (uint i = 0; i < owners.length; i++) {
            hasApproved[owners[i]] = false;
        }
    }
}
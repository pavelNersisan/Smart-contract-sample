pragma solidity ^0.8.0;

contract PeerToPeerLending {
    struct Loan {
        uint id;
        address borrower;
        uint amount;
        uint interestRate;
        uint duration;
        uint startTime;
        bool repaid;
    }

    mapping(uint => Loan) public loans;
    uint public totalLoans;

    event LoanCreated(uint indexed id, address indexed borrower, uint amount, uint interestRate, uint duration);
    event LoanRepaid(uint indexed id);

    function createLoan(uint _amount, uint _interestRate, uint _duration) public returns (uint) {
        uint loanId = totalLoans + 1;
        loans[loanId] = Loan(loanId, msg.sender, _amount, _interestRate, _duration, block.timestamp, false);
        totalLoans++;
        emit LoanCreated(loanId, msg.sender, _amount, _interestRate, _duration);
        return loanId;
    }

    function repayLoan(uint _id) public payable {
        Loan storage loan = loans[_id];
        require(!loan.repaid, "The loan has already been repaid.");
        require(msg.value == loan.amount + (loan.amount * loan.interestRate / 100), "Incorrect repayment amount.");

        loan.repaid = true;
        emit LoanRepaid(_id);

        payable(loan.borrower).transfer(msg.value);
    }
}
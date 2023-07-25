#In this smart contract, we define a Candidate struct to represent each candidate in the election. We store the candidates in an array, and use a mapping to keep track of which addresses have already voted.

We define a function to add candidates to the array, and a function to allow voters to cast their vote for a candidate. We first check if the voter has already voted and if the candidate ID is valid. If both conditions are met, we increment the vote count for the candidate and mark the voter as having voted.

We also define a function to get the winner of the election. We loop through the candidates and find the one with the most votes, then return the name of the winning candidate.

Note that this is a simple example and may not be suitable for all voting systems. Different voting systems may have different requirements and constraints, and it is important to carefully consider these when designing a smart contract.#



pragma solidity ^0.8.0;

contract VotingSystem {
    // Define a struct to represent a candidate
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    // Define an array to store the candidates
    Candidate[] public candidates;

    // Define a mapping to store the voters
    mapping(address => bool) public voters;

    // Define a function to add candidates to the array
    function addCandidate(string memory _name) public {
        candidates.push(Candidate(candidates.length, _name, 0));
    }

    // Define a function to allow voters to cast their vote
    function vote(uint _candidateId) public {
        // Check if the voter has already voted
        require(!voters[msg.sender], "You have already voted.");

        // Check if the candidate ID is valid
        require(_candidateId >= 0 && _candidateId < candidates.length, "Invalid candidate ID.");

        // Increment the vote count for the candidate
        candidates[_candidateId].voteCount++;

        // Mark the voter as having voted
        voters[msg.sender] = true;
    }

    // Define a function to get the winner of the election
    function getWinner() public view returns (string memory) {
        uint winningVoteCount = 0;
        uint winningCandidateId;

        // Loop through the candidates and find the one with the most votes
        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winningCandidateId = i;
            }
        }

        // Return the name of the winning candidate
        return candidates[winningCandidateId].name;
    }
}

pragma solidity ^0.8.0;

contract MembershipApproval {
    enum ApprovalStatus { Pending, Approved, Rejected }

    struct Member {
        uint id;
        address addr;
        ApprovalStatus status;
        uint approvalStep;
    }

    mapping(address => Member) public members;

    uint public totalMembers;

    event MemberAdded(address indexed memberAddr, uint indexed memberId);

    modifier onlyExistingMember() {
        require(members[msg.sender].id != 0, "You are not an existing member.");
        _;
    }

    function addMember(address _memberAddr) public onlyExistingMember {
        uint memberId = totalMembers + 1;
        members[_memberAddr] = Member(memberId, _memberAddr, ApprovalStatus.Pending, 1);
        totalMembers++;
        emit MemberAdded(_memberAddr, memberId);
    }

    function approveMember(address _memberAddr) public onlyExistingMember {
        Member storage member = members[_memberAddr];
        require(member.status == ApprovalStatus.Pending, "The member is not pending approval.");
        require(member.approvalStep == 1, "The member is not at the correct approval step.");

        member.approvalStep = 2;
    }

    function rejectMember(address _memberAddr) public onlyExistingMember {
        Member storage member = members[_memberAddr];
        require(member.status == ApprovalStatus.Pending, "The member is not pending approval.");
        require(member.approvalStep == 1, "The member is not at the correct approval step.");

        member.status = ApprovalStatus.Rejected;
    }

    function approveMemberFinal(address _memberAddr) public onlyExistingMember {
        Member storage member = members[_memberAddr];
        require(member.status == ApprovalStatus.Pending, "The member is not pending approval.");
        require(member.approvalStep == 2, "The member is not at the correct approval step.");

        member.status = ApprovalStatus.Approved;
    }
}
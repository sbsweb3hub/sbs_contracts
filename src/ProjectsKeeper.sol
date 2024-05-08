// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProjectsKeeper {
    address public owner;
    address public creatorContractAddr;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only an owner");
        _;
    }
    modifier onlyApproved() {
        require(
            msg.sender == owner || msg.sender == creatorContractAddr,
            "Only owner/approved!"
        );
        _;
    }

    mapping(address => uint32[]) public projects;

    function setNewOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    function addNewProject(uint32 _projectId, address _creator) external {
        projects[_creator].push(_projectId);
    }

    // установка главного адреса, чтобы можно было через него делать транзы
    function setCreatorContractAddr(
        address _creatorContractAddr
    ) public onlyOwner {
        creatorContractAddr = _creatorContractAddr;
    }

    function getArrOfCreator(
        address _creator
    ) public view returns (uint32[] memory) {
        return projects[_creator];
    }

    function deleteProject(
        uint32 _projectId,
        address _creator
    ) public onlyApproved {
        uint32[] memory arr = projects[_creator];
        uint length = arr.length;

        uint indexToDelete = indexOfProject(arr, _projectId);
        projects[_creator][indexToDelete] = projects[_creator][length - 1];
        projects[_creator].pop();
    }

    function indexOfProject(
        uint32[] memory _arrProjectIds,
        uint32 _projectId
    ) internal pure returns (uint) {
        uint length = _arrProjectIds.length;

        for (uint i = 0; i < length; i++) {
            if (_arrProjectIds[i] == _projectId) {
                return i;
            }
        }
        revert("Can't find this project");
    }
}

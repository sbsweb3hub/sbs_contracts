// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ProjectToken.sol";

contract ProjectManagerMain {
    struct CreateMain {
        ProjectToken projectContract;
        address owner;
        string projectName;
        string projectSymbol;
    }

    event ProjectCreatedMain(CreateMain project);

    uint32 public projectIdMain = 1;

    mapping(uint32 => CreateMain) getProjectMain;

    function projectsViewMain(uint32 projectId)
        public
        view
        returns (ProjectToken, address, string memory, string memory)
    {
        CreateMain memory project = getProjectMain[projectId];
        return (project.projectContract, project.owner, project.projectName, project.projectSymbol);
    }

    function createProjectMain(string memory _projectName, string memory _projectSymbol) internal returns (uint32) {
        ProjectToken tokenContract = new ProjectToken(_projectName, _projectSymbol);

        CreateMain memory project = CreateMain({
            projectContract: tokenContract,
            owner: msg.sender,
            projectName: _projectName,
            projectSymbol: _projectSymbol
        });
        //тут можно добавить пересылку токенов проекта на адрес контракта, если эти токены уже есть у проекта
        getProjectMain[projectIdMain] = project;
        projectIdMain++;
        emit ProjectCreatedMain(project);
        return projectIdMain - 1;
    }
}

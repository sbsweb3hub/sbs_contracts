// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IProjectsKeeper {
    function addNewProject(uint32 _projectId, address _creator) external;

    function deleteProject(uint32 _projectId, address _creator) external;
}
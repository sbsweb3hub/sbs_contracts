// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";

import {ProjectsKeeper} from "../src/ProjectsKeeper.sol";
import {CreateProject} from "../src/CreateProject.sol";
import {StartFunds} from "../src/StartFunds.sol";

contract CreateProjectTest is Test {
    ProjectsKeeper public projectKeeper;
    CreateProject public createProject;
    StartFunds public startFunds;

    string _projectName = "SBS launchpad";
    string _projectSymbol = "SBS";
    uint _maxTokenSupply = 1000;
    uint _minTokenSale = 100;
    uint _price = 10;
    uint _publicSale = 200;
    uint8 _amountSteps = 4;
    uint[] _timeSteps;

    function setUp() public {
        projectKeeper = new ProjectsKeeper();
        createProject = new CreateProject(address(projectKeeper));
        startFunds = new StartFunds(address(createProject));

        // Fill timeSteps
        _timeSteps = new uint[](_amountSteps);
        for (uint i = 0; i < _amountSteps; i++) {
            _timeSteps[i] = 60;
        }
    }

    function test_createProject() public {
        createProject.create(
            _projectName,
            _projectSymbol,
            _maxTokenSupply,
            _minTokenSale,
            _price,
            _publicSale,
            _amountSteps,
            _timeSteps
        );
    }

    function test_startProject() public {
        (uint32 idMain, , ) = createProject.create(
            _projectName,
            _projectSymbol,
            _maxTokenSupply,
            _minTokenSale,
            _price,
            _publicSale,
            _amountSteps,
            _timeSteps
        );
        vm.prank(address(this));
        startFunds.start(idMain);
    }
}

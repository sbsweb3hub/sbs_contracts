// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { Test, console } from 'forge-std/Test.sol';

import { ProjectsKeeper } from '../src/ProjectsKeeper.sol';
import { CreateProject } from '../src/CreateProject.sol';
import { StartFunds } from '../src/StartFunds.sol';
import { Ordering } from '../src/Ordering.sol';
import { IBlastPoints } from '../src/IBlastPoints.sol';
import { GetFundForProject } from '../src/GetFundForProject.sol';
import { Claiming } from '../src/Claiming.sol';
import { Voting } from '../src/Voting.sol';

contract CreateProjectTest is Test {
    // BlastPoints Testnet address: 0x2fc95838c71e76ec69ff817983BFf17c710F34E0
    // BlastPoints Mainnet address: 0x2536FE9ab3F511540F2f9e2eC2A805005C3Dd800
    IBlastPoints public constant blastPointsAddress = IBlastPoints(0x2fc95838c71e76ec69ff817983BFf17c710F34E0);
    ProjectsKeeper public projectKeeper;
    CreateProject public createProject;
    StartFunds public startFunds;
    Ordering public ordering;
    GetFundForProject public getFundForProject;
    Claiming public claiming;
    Voting public voting;

    address operator = makeAddr('operator');
    address founder1 = makeAddr('founder1');
    address investor1 = makeAddr('investor1');
    address investor2 = makeAddr('investor2');

    string _projectName = 'SBS launchpad';
    string _projectSymbol = 'SBS';
    uint _maxTokenSupply = 1000;
    uint _minTokenSale = 100;
    uint _price = 1 ether;
    uint _publicSale = 200;
    uint8 _amountSteps = 4;
    uint[] _timeSteps;

    function setUp() public {
        projectKeeper = new ProjectsKeeper();
        createProject = new CreateProject(address(projectKeeper));
        startFunds = new StartFunds(address(createProject));
        // BlastPoints Testnet address: 0x2fc95838c71e76ec69ff817983BFf17c710F34E0
        // BlastPoints Mainnet address: 0x2536FE9ab3F511540F2f9e2eC2A805005C3Dd800
        ordering = new Ordering(address(createProject), address(blastPointsAddress), address(operator));
        getFundForProject = new GetFundForProject(address(createProject), address(ordering));
        claiming = new Claiming(address(createProject), address(ordering));
        voting = new Voting(address(createProject), address(ordering));

        projectKeeper.setCreatorContractAddr(address(createProject));
        createProject.setAllowedAddrs(
            address(startFunds), address(claiming), address(getFundForProject), address(ordering), address(voting)
        );
        ordering.setClaimableAddrs(address(claiming), address(getFundForProject));
        // Fill timeSteps
        _timeSteps = new uint[](_amountSteps);
        for (uint i = 0; i < _amountSteps; i++) {
            _timeSteps[i] = 60 seconds;
        }
    }

    function createProjectCall() public returns (uint32 x, uint32 y, uint32 z) {
        (x, y, z) = createProject.create(
            _projectName, _projectSymbol, _maxTokenSupply, _minTokenSale, _price, _publicSale, _amountSteps, _timeSteps
        );
    }

    function test_createProject() public {
        createProjectCall();
    }

    function test_startProject() public {
        vm.startPrank(founder1, founder1);
        (uint32 id,,) = createProjectCall();
        startFunds.start(id);
        vm.stopPrank();
    }

    function test_startOrdering() public {
        vm.startPrank(founder1, founder1);
        vm.deal(founder1, 1 ether);
        (uint32 id,,) = createProjectCall();
        startFunds.start(id);
        ordering.order{ value: 1 ether }(id);
        vm.stopPrank();
    }

    function test_MoneyFromInvestor() public {
        vm.startPrank(founder1, founder1);
        (uint32 id,,) = createProjectCall();
        startFunds.start(id);
        vm.stopPrank();

        vm.startPrank(investor1, investor1);
        vm.deal(investor1, 1 ether);
        ordering.order{ value: 1 ether }(id);
        (uint invested1, uint all1) = ordering.getRecievedMoneyFromInvestor(id);
        assertEq(invested1, all1, 'err');
        vm.stopPrank();

        vm.startPrank(investor2, investor2);
        vm.deal(investor2, 1 ether);
        ordering.order{ value: 1 ether }(id);
        (uint invested2, uint all2) = ordering.getRecievedMoneyFromInvestor(id);
        assertEq(invested1 + invested2, all2, 'err');
        vm.stopPrank();
    }
}

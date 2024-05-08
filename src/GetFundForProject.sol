// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ICreateProject.sol";
import "./IOrdering.sol";

contract GetFundForProject {
    address public owner;
    bool private locked;
    uint8 public sbsFee;
    ICreateProject createProject_contract; // взаимодействие в Главным контрактом
    IOrdering ordering_contract; // взаимодействие в контрактом где деньги

    constructor(address _createProject_contract, address _ordering_contract) {
        owner = msg.sender;
        createProject_contract = ICreateProject(_createProject_contract);
        ordering_contract = IOrdering(_ordering_contract);
    }

    modifier reentrancyGuard() {
        require(!locked, "denied");
        locked = true;
        _;
        locked = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only an owner");
        _;
    }

    function setNewOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    function setSBSFee(uint8 _sbsFee) public onlyOwner {
        sbsFee = _sbsFee;
    }

    event GetAllProjectTokens(address onwerProject, uint allProjectTokens);
    event sendAllProjectTokensToSBS(address owner, uint allProjectTokens);

    // поочередное получение проектом всех траншей
    function getNextFund(uint32 _projectId) public reentrancyGuard {
        address _owner = createProject_contract.ownerOfProject(_projectId);
        require(msg.sender == _owner, "You are not an owner");
        uint8 stepIsLive = createProject_contract.witchStepAlive(_projectId);

        (
            uint tokenSupply,
            ,
            uint minTokenSale,
            ,
            uint publicSale,
            bool isProjectAlive,
            ,
            uint fundsForProject
        ) = createProject_contract.projectsViewPrice(_projectId);
        require(isProjectAlive, "Project is over!");

        (
            uint8 amountSteps,
            ,
            ,
            uint[] memory dateSteps,
            ,
            ,

        ) = createProject_contract.projectsViewSteps(_projectId);

        require(tokenSupply >= minTokenSale, "Not enough funds!");
        require(
            stepIsLive < amountSteps && stepIsLive != 0,
            "You've already got all your funds!"
        ); // уточнить эту проверку

        uint32 votingTime = 300; // 604800;
        if (stepIsLive == 1) {
            require(
                (block.timestamp < dateSteps[1] && tokenSupply == publicSale) ||
                    (block.timestamp > dateSteps[stepIsLive]),
                "Sale is still ongoing"
            ); // если паблик закончился раньше времени - можно забрать первый транш
        } else {
            require(
                (block.timestamp > dateSteps[stepIsLive] + votingTime),
                "The vote has not taken place yet"
            ); // ?? нужно прибывать ещё время голосования 7 дней
        }
        // текущий шаг ставим false следующий true
        createProject_contract.updateAfterSBSFund(_projectId, stepIsLive);

        // тут и выплата и уменьшение объема в меппинге
        uint sbsFundForProject = fundsForProject / (amountSteps - 1);
        uint sbsFeeReward = 0;
        if (sbsFee != 0) {
            sbsFeeReward = (sbsFundForProject / 100) * sbsFee;
            sbsFundForProject -= sbsFeeReward;
        }
        ordering_contract.getFundByProject(
            _projectId,
            sbsFundForProject,
            sbsFeeReward,
            msg.sender
        );
    }

    // получение проектом всех своих токенов после завершения SBSFund
    function getAllProjectTokens(uint32 _projectId) public {
        (
            uint amountSteps,
            ,
            ,
            uint[] memory dateSteps,
            ,
            ,

        ) = createProject_contract.projectsViewSteps(_projectId);

        require(
            block.timestamp > dateSteps[amountSteps],
            "Project time isn't finish!"
        );

        (
            uint tokenSupply,
            uint maxTokenSupply,
            uint minTokenSale,
            ,
            uint publicSale,
            bool isProjectAlive,
            bool isProjectGetAllTokens,

        ) = createProject_contract.projectsViewPrice(_projectId);
        require(!isProjectGetAllTokens, "Project already got tokens!");

        (ProjectToken projectContract, , , ) = createProject_contract
            .projectsViewMain(_projectId);

        uint allProjectTokens = maxTokenSupply - publicSale;

        if (msg.sender == owner) {
            require(!isProjectAlive, "Project is good!");
            createProject_contract.setGettingAllTokens(_projectId);
            projectContract.mint(owner, allProjectTokens);
            emit sendAllProjectTokensToSBS(owner, allProjectTokens);
        } else {
            address _owner = createProject_contract.ownerOfProject(_projectId);
            require(msg.sender == _owner, "You are not an owner");
            require(isProjectAlive, "Project is over!");
            require(tokenSupply >= minTokenSale, "Sale isn't good");
            createProject_contract.setGettingAllTokens(_projectId);
            projectContract.mint(msg.sender, allProjectTokens);
            // не могу закрыть так как после проекта ещё могут быть пользователи, которые не забрали свои токены
            emit GetAllProjectTokens(msg.sender, allProjectTokens);
        }
    }
}

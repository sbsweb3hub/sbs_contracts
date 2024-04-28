// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ICreateProject.sol";
import "./IOrdering.sol";

contract Voting {

    ICreateProject createProject_contract;   // взаимодействие в Главным контрактом
    IOrdering ordering_contract;   // взаимодействие в контрактом где деньги

    constructor(address _createProject_contract, address _ordering_contract) {
        createProject_contract = ICreateProject(_createProject_contract);
        ordering_contract = IOrdering(_ordering_contract);
    }

// голосование за каждый этап, начиная со 2-го, т.к. 1-й прошел после удачного сбора средств
    uint32 votingTime = 300; // 604800; // 7 days
    uint8 negativeShare = 51; // 51% против, чтобы проект перестал получать финансирование
    mapping(uint32 => mapping(uint8 => uint)) public projectStepsResultVoting; // результаты прохождения этапов, сколько голосов против, начиная с 2: (т.к. 0: паблик, 1: 1-я работа)
    mapping(uint32 => mapping(uint8 => mapping(address => bool))) public isVoting; // голосовал уже или нет

    function viewProjectResultVoting(uint32 _projectId, uint8 _step) public view returns(uint) {
    return projectStepsResultVoting[_projectId][_step];
    }
    
    function vote(uint32 _projectId) public {
        uint userOrderedTokens = ordering_contract.getUserOrderedTokens(_projectId, msg.sender);
        require(userOrderedTokens != 0, "You haven't the tokens to vote!");
        (
            uint tokenSupply, 
            , 
            , 
            , 
            , 
            bool isProjectAlive,  
            ,
            
            ) = createProject_contract.projectsViewPrice(_projectId);
        require(isProjectAlive, "Project is over!");

        uint8 stepIsLive = createProject_contract.witchStepAlive(_projectId);
        // проверка на действующий этап
        // в момент удачного ПабликСейла устанавливается stepIsLive[1] = тру = это фактичеси этап 2 в размерности amountSteps
        // но т.к. на stepIsLive[1] идет первый рабочий этап - мы тут ещё не голосуем
        // а голосуем когда наступает stepIsLive[2], поэтому нужно: stepIsLive > 1
        // изменение stepIsLive происходит в функции getNextFund(contract GetFundForProject), когда проект забирает очередной транш
        //   пабликсейл.               удачный паблик             забрали первый ранш       забрали второй транш.     забрали третий транш.   
        // stepIsLive[0] = false;  // stepIsLive[0] = false;  // stepIsLive[0] = false;  // stepIsLive[0] = false;  // stepIsLive[0] = false;  
        // stepIsLive[1] = false;  // stepIsLive[1] = true;   // stepIsLive[1] = false;  // stepIsLive[1] = false;  // stepIsLive[1] = false;   
        // stepIsLive[2] = false;  // stepIsLive[2] = false;  // stepIsLive[2] = true;   // stepIsLive[2] = false;  // stepIsLive[2] = false;  
        // stepIsLive[3] = false;  // stepIsLive[3] = false;  // stepIsLive[3] = false;  // stepIsLive[3] = true;   // stepIsLive[3] = false;  
        // stepIsLive[4] = false;  // stepIsLive[4] = false;  // stepIsLive[4] = false;  // stepIsLive[4] = false;   // stepIsLive[4] = true;  
        require(stepIsLive > 1, "Voting hasn't started yet!"); // проверить общую длину массива stepIsLive

           (
            uint amountSteps, 
            , 
            , 
            uint[] memory dateSteps, 
            ,
            , 
            
            ) = createProject_contract.projectsViewSteps(_projectId);
        require(stepIsLive < amountSteps, "All votes is done!"); 
        require(block.timestamp > dateSteps[stepIsLive], "Voting hasn't started yet!");
        require(block.timestamp <= dateSteps[stepIsLive] + votingTime, "Voting is over or not start yet!");
        require(!isVoting[_projectId][stepIsLive][msg.sender], "You've already voted!");
        isVoting[_projectId][stepIsLive][msg.sender] = true;

        uint userVotingPower = userOrderedTokens;
        projectStepsResultVoting[_projectId][stepIsLive] += userVotingPower;

        if(projectStepsResultVoting[_projectId][stepIsLive] > tokenSupply / 100 * negativeShare) {
            createProject_contract.closeProject(_projectId);
        }
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ICreateProject.sol";
import "./IOrdering.sol";

contract Claiming {

    ICreateProject createProject_contract;   // взаимодействие в Главным контрактом
    IOrdering ordering_contract;   // взаимодействие в контрактом где деньги

    constructor(address _createProject_contract, address _ordering_contract) {
        createProject_contract = ICreateProject(_createProject_contract);
        ordering_contract = IOrdering(_ordering_contract);
    }
    
    function claimTokens(uint32 _projectId) public {
        uint reward = earned(_projectId, msg.sender);
        if(reward != 0) {
          (
            ProjectToken projectContract, 
            , 
            , 
            
            ) = createProject_contract.projectsViewMain(_projectId);

          (
            uint amountSteps, 
            , 
            , 
            uint[] memory dateSteps, 
            ,
            , 
            
            ) = createProject_contract.projectsViewSteps(_projectId);
            // полное зануление только после завершения времени всего проекта
        if(block.timestamp > dateSteps[amountSteps]) {
               ordering_contract.setZeroOrderedTokens(_projectId, msg.sender);
           }
        ordering_contract.setTokensAlreadyClaimed(_projectId, msg.sender, reward);
        projectContract.mint(msg.sender, reward);
        }
    }


     function earned(uint32 _projectId, address _account) public view returns(uint) {
        uint userOrderedTokens = ordering_contract.getUserOrderedTokens(_projectId, _account);
        require(userOrderedTokens != 0, "You don't have any tokens.");
        (
            , 
            , 
            , 
            , 
            , 
            bool isProjectAlive,  
            ,
            
            ) = createProject_contract.projectsViewPrice(_projectId);
       // require(isProjectAlive, "Project is over!");

            (
            uint amountSteps, 
            , 
            uint[] memory rewardTimePerStep, 
            uint[] memory dateSteps, 
            bool[] memory isStepsPerProject,
            , 
            
            ) = createProject_contract.projectsViewSteps(_projectId);

         uint8 stepIsLive = createProject_contract.witchStepAlive(_projectId);
         // если проект не забирает первый транш то это stepIsLive > 1 не пройдет
         // либо проект потерял доступ к кошельку, либо прекратил своё существование после начала паблика
         // нужно это обдумать
         require(stepIsLive > 1 && block.timestamp >= dateSteps[1], "Still early"); // паблик удачный и врямя завершения паблика
         uint tokensAlreadyClaimed = ordering_contract.getTokensAlreadyClaimed(_projectId, _account);

         // это условие для варианта когда проект не прошел голосование, 
         // а инвестор всё ещё не забрал свои токены с предыдущих этапов
         if(isProjectAlive) {
         bool isStepAlive;
         uint rewardTime;
          for (uint i = 2; i <= amountSteps; i++) {
            isStepAlive = isStepsPerProject[i];
            // начисление токенов начинается после половины каждого этапа
              if(isStepAlive) {
                  rewardTime = dateSteps[i-1] + (dateSteps[i] - dateSteps[i-1]) / 2;
                  if(i == 2 && block.timestamp > rewardTime && block.timestamp < dateSteps[i]) {
                      return 
                      userOrderedTokens / (amountSteps - 1) / rewardTimePerStep[i - 1] // сколько токенов в милисекунду
                      * 
                      (block.timestamp - rewardTime) - tokensAlreadyClaimed;
                  } else if(i == 2 && block.timestamp < rewardTime) {
                      return 0;
                  } else if (i > 2 && block.timestamp < rewardTime) {
                      return 
                      userOrderedTokens / (amountSteps - 1) // tokensPerStep
                      * (i - 2) 
                      -
                     tokensAlreadyClaimed;
                  } else if (i > 2 && block.timestamp > rewardTime && block.timestamp < dateSteps[i]) {
                      return ((userOrderedTokens / (amountSteps - 1) * (i - 2))
                     +
                       (userOrderedTokens / (amountSteps - 1) / rewardTimePerStep[i - 1] // сколько токенов в милисекунду
                        * 
                       (block.timestamp - rewardTime))) 
                     - 
                     tokensAlreadyClaimed; 
                  } else {
                    if(stepIsLive == amountSteps) {
                        return userOrderedTokens - tokensAlreadyClaimed;
                    } else {
                        return userOrderedTokens / (amountSteps - 1) * (stepIsLive - 1) - tokensAlreadyClaimed;
                    }
                  }
              }
          }
         } else {
            return userOrderedTokens / (amountSteps - 1) * (stepIsLive - 1) - tokensAlreadyClaimed;
         }
          return 0;
     }
}
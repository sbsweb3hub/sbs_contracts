// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ICreateProject.sol";

contract StartFunds {
    ICreateProject createProject_contract; // взаимодействие в Главным контрактом

    constructor(address _createProject_contract) {
        createProject_contract = ICreateProject(_createProject_contract);
    }

    // запуск начала пабликсейла
    // формирование массива с датами каждого этапа через if

    function start(uint32 _projectId) public {
        address _owner = createProject_contract.ownerOfProject(_projectId);
        require(msg.sender == _owner, "You are not an owner");
        (
            uint8 amountSteps,
            uint256[] memory timeSteps,
            uint256[] memory rewardTimePerStep,
            uint256[] memory dateSteps,
            bool[] memory isStepsPerProject,
            ,
            bool isPublicSale
        ) = createProject_contract.projectsViewSteps(_projectId);

        require(!isPublicSale, "The funding has already been launched!");

        uint256 startTime = block.timestamp;
        uint256 localTime;
        for (uint8 i = 0; i <= amountSteps; i++) {
            if (i == 0) {
                localTime = block.timestamp;
                dateSteps[i] = startTime;
            } else if (i > 0 && i < amountSteps) {
                dateSteps[i] = localTime + timeSteps[i - 1];
                localTime = dateSteps[i];
                rewardTimePerStep[i] = timeSteps[i] / 2;
            } else {
                dateSteps[i] = localTime + timeSteps[i - 1];
            }
        }

        createProject_contract.updateSteps(
            _projectId, amountSteps, timeSteps, rewardTimePerStep, dateSteps, isStepsPerProject, startTime, true
        );
    }
}

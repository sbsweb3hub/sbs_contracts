// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ProjectManagerSteps {
    
    address public startAddr;
    address public orderingAddrStep;
    address public tokensForProjectAddrStep;

    struct CreateSteps {
        uint8 amountSteps;  //кол-во этапов(не менее 3-х: пабликсейл не учитывается, 1-3(и более) - работа)
        uint[] timeSteps; // при первой загрузке, времена в отрезках времени. 
        uint[] rewardTimePerStep;  //после старта - время, в течении которого начисляются токены
        uint[] dateSteps; // После старта - в конечных датах
        bool[] isStepsPerProject; // Какой шаг действует
        uint startTime;       // устанавливается после старта запуска начала пабликсейла - function startFunds()
        bool isPublicSale;  // идет ли пабликсейл
    }

    event ProjectCreatedSteps(CreateSteps project);
    event ProjectStartSteps(uint projectIdSteps);

    uint32 public projectIdSteps = 1;

    mapping(uint32 => CreateSteps) getProjectSteps;

    function setUsingAddrsForSteps(address _startAddr, address _orderingAddr, address _tokensMainForProjectAddr) internal {
        startAddr = _startAddr;
        orderingAddrStep = _orderingAddr;
        tokensForProjectAddrStep = _tokensMainForProjectAddr;
    }

    function projectsViewSteps(uint32 projectId) public view returns (uint8, uint[] memory, uint[] memory, uint[] memory, bool[] memory, uint, bool ) {
        CreateSteps memory project = getProjectSteps[projectId];
        return (
        project.amountSteps,
        project.timeSteps, 
        project.rewardTimePerStep,  
        project.dateSteps,
        project.isStepsPerProject,
        project.startTime,   
        project.isPublicSale
        );
    }

    function createProjectSteps(
        uint8 _amountSteps,
        uint[] memory _timeSteps
        ) internal returns (uint32) {

        require(_amountSteps >= 3 && _timeSteps.length >= 3, "Need three or more steps!");
        CreateSteps memory project = CreateSteps({
            amountSteps: _amountSteps,
		    timeSteps: _timeSteps,
            rewardTimePerStep: new uint[](_amountSteps),
		    dateSteps: new uint[](_amountSteps + 1),
            isStepsPerProject: new bool[](_amountSteps + 1),
            startTime: 0,
		    isPublicSale: false
        });
		//тут можно добавить пересылку токенов проекта на адрес контракта, если эти токены уже есть у проекта
        getProjectSteps[projectIdSteps] = project;
		projectIdSteps++;
        emit ProjectCreatedSteps(project);
        return projectIdSteps - 1; 
    } 

    function updateSteps(
        uint32 _projectIdSteps,
        uint8 _amountSteps,
        uint[] memory _timeSteps,
        uint[] memory _rewardTimePerStep,
        uint[] memory _dateSteps,
        bool[] memory _isStepsPerProject,
        uint _startTime,
        bool _isPublicSale
    ) external {
        require(msg.sender == startAddr, "Not allowed");
        getProjectSteps[_projectIdSteps] = CreateSteps({
            amountSteps: _amountSteps,
		    timeSteps: _timeSteps,
            rewardTimePerStep: _rewardTimePerStep,
		    dateSteps: _dateSteps,
            isStepsPerProject: _isStepsPerProject,
            startTime: _startTime,
		    isPublicSale: _isPublicSale
        });
   }

   function orderSteps(uint32 _projectIdSteps, bool[] memory _isStepsPerProject) external {
       require(msg.sender == orderingAddrStep, "Not allowed");
       getProjectSteps[_projectIdSteps].isStepsPerProject = _isStepsPerProject;
   }
   
   function updateAfterSBSFund(uint32 _projectIdSteps, uint8 _stepIsLive) external {
        require(msg.sender == tokensForProjectAddrStep, "Not allowed");
        getProjectSteps[_projectIdSteps].isStepsPerProject[_stepIsLive] = false;
        getProjectSteps[_projectIdSteps].isStepsPerProject[_stepIsLive + 1] = true;
        
   }
}
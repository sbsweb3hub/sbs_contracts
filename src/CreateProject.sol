 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ProjectManagerMain.sol";
import "./ProjectManagerPrice.sol";
import "./ProjectManagerSteps.sol";
import "./IProjectsKeeper.sol";
 
contract CreateProject is
     ProjectManagerMain,
     ProjectManagerPrice,
     ProjectManagerSteps
      {

    address public contractOwner;
    address public claimableAddr;
    address public getFundForProjectAddr;
    IProjectsKeeper contract_Keeper;   // взаимодействие с хранилищем номеров проектов

    constructor(address _contract_Keeper) {
        contractOwner = msg.sender;
        contract_Keeper = IProjectsKeeper(_contract_Keeper);
    }

    modifier onlyOwner() {
        require(msg.sender == contractOwner, "Only an owner");
        _;
    }

    function setNewOwner(address _newOwner) public onlyOwner {
        contractOwner = _newOwner;
    }

    function setAllowedAddrs
        (
            address _startAddr,
            address _claimableAddr, 
            address _getFundForProjectAddr, 
            address _orderingAddr, 
            address _votingAddr
        ) 
            public onlyOwner {
        claimableAddr = _claimableAddr;
        getFundForProjectAddr = _getFundForProjectAddr;
        setUsingAddrsForPrice(_orderingAddr, _votingAddr, _getFundForProjectAddr); 
        setUsingAddrsForSteps(_startAddr, _orderingAddr, _getFundForProjectAddr);
    }

    function create(
        string memory _projectName,
		string memory _projectSymbol,
        uint _maxTokenSupply,
		uint _minTokenSale,
        uint _price,
        uint _publicSale,
        uint8 _amountSteps,
        uint[] memory _timeSteps
    ) public returns (uint32, uint32, uint32) {
        require(_amountSteps == _timeSteps.length, "Incorrrect data!");
        require(_amountSteps >= 4 && _timeSteps.length >= 4, "Need three or more steps!");
        require(_publicSale <= _maxTokenSupply, "Incorrect amount public-MaxSupply");
        require(_minTokenSale <= _publicSale, "Incorrect amount min-public");

        uint32 idMain = createProjectMain(_projectName, _projectSymbol);
        uint32 idPrice = createProjectPrice(_maxTokenSupply, _minTokenSale, _price, _publicSale);
        uint32 idSteps = createProjectSteps(_amountSteps, _timeSteps);

        require(idMain == idPrice && idPrice == idSteps, "Incorrrect ids!");
  
        contract_Keeper.addNewProject(idMain, msg.sender); // добавление проекта к адресу создателя

        setApproveClaimAddresses(idMain, claimableAddr, getFundForProjectAddr);

        return(idMain, idPrice, idSteps);
    }

    function ownerOfProject(uint32 _projectId) external view returns(bool) {
        CreateMain memory project = getProjectMain[_projectId];
        if(project.owner == tx.origin) {
            return true;
        } else {
            return false;
        }
    }
 // чтобы избежать случая когда проект провел удачный Сэйл и не забрал первый транш, (что ведет к блокировке средств на смарте)
 // может быть по причине потери доступа к адресу
    function setNewOwnerOfProject(uint32 _projectId, address _newOwnerOfProject) public onlyOwner {
        getProjectMain[_projectId].owner = _newOwnerOfProject;
    }

    function isPublicSale(uint32 _projectId) external view returns(bool) {
        CreateSteps memory project = getProjectSteps[_projectId];
        if(project.isPublicSale) {
            return true;
        } else {
          return false;
        }
    }

    function witchStepAlive(uint32 _projectId) public view returns(uint8 step) {
           CreateSteps memory project = getProjectSteps[_projectId];
           for (uint8 i = 1; i <= project.amountSteps; i++) {
               if(project.isStepsPerProject[i]) {
                   return i;
               } 
           }
       }
    function setApproveClaimAddresses(uint32 _projectId, address _claimableAddr, address _getFundForProjectAddr) private {
        (
            ProjectToken projectContract, 
            address owner, 
            , 
            
            ) = projectsViewMain(_projectId);
            require(msg.sender == owner, "Not an owner!");
            projectContract.setClaimableAddrs(_claimableAddr, _getFundForProjectAddr);
    }

    function deleteProjectFromArr(uint32 _projectId) public {
        (
            , 
            address ownerProject, 
            , 
            
            ) = projectsViewMain(_projectId);
        require(msg.sender == ownerProject, "Not an owner of Project!");
        (
            , 
            , 
            , 
            , 
            , 
            bool isProjectAlive,
            ,  
            
            ) = projectsViewPrice(_projectId);
            require(isProjectAlive);
        contract_Keeper.deleteProject(_projectId, msg.sender); 

    }
}
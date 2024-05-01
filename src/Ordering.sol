// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ICreateProject.sol";
import {IBlastPoints} from "./IBlastPoints.sol";

contract Ordering {
    address public owner;
    address public claimableAddr;
    address public getFundForProjectAddr;
    ICreateProject createProject_contract; // взаимодействие в Главным контрактом

    constructor(
        address _createProject_contract,
        address _blastPointsAddress,
        address _operator
    ) {
        owner = msg.sender;
        IBlastPoints(_blastPointsAddress).configurePointsOperator(_operator);
        createProject_contract = ICreateProject(_createProject_contract);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only an owner");
        _;
    }

    function setNewOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    function setClaimableAddrs(
        address _claimableAddr,
        address _getFundForProjectAddr
    ) public onlyOwner {
        claimableAddr = _claimableAddr;
        getFundForProjectAddr = _getFundForProjectAddr;
    }

    event OrderedTokens(address buyer, uint projectId, uint amount);
    event RefundUser(address user, uint amountForRefund);
    event SBSFund(
        uint32 _projectId,
        address _onwerProject,
        uint _sbsFundForProject
    );
    event SBSFeeReward(uint32 _projectId, address owner, uint _sbsFeeReward);

    mapping(uint => mapping(address => uint)) public recievedMoneyFromInvestor; // деньги, которые покупатель зарезервировал под определенного проект
    mapping(uint => mapping(address => uint)) public orderedTokens; // оплаченные токены по адресам покупателей
    mapping(uint => mapping(address => uint)) public tokensAlreadyClaimed; //количество токенов переданных инвестору

    function getUserOrderedTokens(
        uint32 _projectId,
        address _user
    ) external view returns (uint) {
        return orderedTokens[_projectId][_user];
    }

    function setZeroOrderedTokens(uint32 _projectId, address _user) external {
        require(msg.sender == claimableAddr, "Not allowed");
        orderedTokens[_projectId][_user] = 0;
    }

    function getTokensAlreadyClaimed(
        uint32 _projectId,
        address _user
    ) external view returns (uint) {
        return tokensAlreadyClaimed[_projectId][_user];
    }

    function setTokensAlreadyClaimed(
        uint32 _projectId,
        address _user,
        uint _amount
    ) external {
        require(msg.sender == claimableAddr, "Not allowed");
        tokensAlreadyClaimed[_projectId][_user] += _amount;
    }

    // бронирование токенов за покупателем
    function order(uint32 _projectId) public payable {
        bool isPublicSale = createProject_contract.isPublicSale(_projectId);
        require(isPublicSale, "Public-sale isn't started yet!");
        (
            ,
            ,
            ,
            uint[] memory dateSteps,
            bool[] memory isStepsPerProject,
            ,

        ) = createProject_contract.projectsViewSteps(_projectId);
        require(block.timestamp <= dateSteps[1], "Too late to invest!");

        (
            uint tokenSupply,
            ,
            uint minTokenSale,
            uint price,
            uint publicSale,
            ,
            ,
            uint fundsForProject
        ) = createProject_contract.projectsViewPrice(_projectId);

        uint _amount = msg.value / price;
        uint _maxPerTx = (publicSale / 100) * 10; // 10% от максимального сейла, чтобы дать многим шанс купить
        require(_amount <= _maxPerTx, "Too much per tx"); // не больше 10% за транзакцию
        require(tokenSupply + _amount <= publicSale, "Too much");
        recievedMoneyFromInvestor[_projectId][msg.sender] += msg.value; //кол-во инвестиций от инвестора

        tokenSupply += _amount;
        orderedTokens[_projectId][msg.sender] += _amount; //кол-во резервированных токенов для инвестора

        fundsForProject += msg.value; //кол-во денег для проекта на общем контракте

        if (tokenSupply >= minTokenSale && !isStepsPerProject[1]) {
            isStepsPerProject[1] = true; // фиксируем что сейл закончился и начался первый рабочий этап
            createProject_contract.orderSteps(
                _projectId,
                isStepsPerProject // установка isStepsPerProject[1] = true
            );
        }
        createProject_contract.orderPrice(
            _projectId,
            tokenSupply,
            fundsForProject
        );
        emit OrderedTokens(msg.sender, _projectId, _amount);
    }

    // возврат средств инвесторам когда не собрали достаточно финансирования по завершении срока паблисейла
    function refundUsers(uint32 _projectId) public {
        (
            uint8 amountSteps,
            ,
            ,
            uint[] memory dateSteps,
            ,
            ,

        ) = createProject_contract.projectsViewSteps(_projectId);
        require(block.timestamp > dateSteps[1], "Public-sale is live!");

        (
            uint tokenSupply,
            ,
            uint minTokenSale,
            ,
            ,
            bool isProjectAlive,
            ,

        ) = createProject_contract.projectsViewPrice(_projectId);
        uint8 stepIsLive = createProject_contract.witchStepAlive(_projectId);
        if (stepIsLive > 1) {
            require(!isProjectAlive, "Project is live!"); // проверка для последующий этапов после удачного сейла
        } else {
            require(tokenSupply < minTokenSale, "Public-sale is good!"); // проверка при неудачном сейле после завершения сейла
        }
        //   require(orderedTokens[_projectId][msg.sender] != 0, "You didn't order tokens");

        uint amountForRefund = recievedMoneyFromInvestor[_projectId][
            msg.sender
        ];
        if (amountForRefund != 0) {
            recievedMoneyFromInvestor[_projectId][msg.sender] = 0;

            if (stepIsLive > 1) {
                amountForRefund =
                    (amountForRefund / (amountSteps - 1)) *
                    (amountSteps - stepIsLive);
            }

            (bool success, ) = msg.sender.call{value: amountForRefund}("");
            require(success, "failed");

            emit RefundUser(msg.sender, amountForRefund);
        } else {
            revert("Already got");
        }
    }

    // получение проектом очередного транша / реализуется в контракте GetFundForProject
    function getFundByProject(
        uint32 _projectId,
        uint _sbsFundForProject,
        uint _sbsFeeReward,
        address _onwerProject
    ) external {
        require(msg.sender == getFundForProjectAddr, "Not allowed");

        (bool success, ) = _onwerProject.call{value: _sbsFundForProject}("");
        require(success, "failed");

        if (_sbsFeeReward != 0) {
            (bool successFee, ) = owner.call{value: _sbsFeeReward}("");
            require(successFee, "failed");

            emit SBSFeeReward(_projectId, owner, _sbsFeeReward);
        }

        emit SBSFund(_projectId, _onwerProject, _sbsFundForProject);
    }

    fallback() external payable {}

    receive() external payable {}
}

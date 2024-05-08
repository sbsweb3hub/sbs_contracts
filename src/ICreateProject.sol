// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ProjectToken.sol";

interface ICreateProject {
    function create(
        string memory _projectName,
        string memory _projectSymbol,
        uint _maxTokenSupply,
        uint _minTokenSale,
        uint _price,
        uint _publicSale,
        uint _amountSteps,
        uint[] memory _timeSteps
    ) external returns (uint32, uint32, uint32);

    function ownerOfProject(uint32 projectId) external view returns (address);

    function isPublicSale(uint32 projectId) external view returns (bool);

    function projectsViewSteps(
        uint32 projectId
    )
        external
        view
        returns (
            uint8,
            uint[] memory,
            uint[] memory,
            uint[] memory,
            bool[] memory,
            uint,
            bool
        );

    function projectsViewPrice(
        uint32 projectId
    ) external view returns (uint, uint, uint, uint, uint, bool, bool, uint);

    function projectsViewMain(
        uint32 projectId
    )
        external
        view
        returns (ProjectToken, address, string memory, string memory);

    function updateSteps(
        uint32 _projectIdSteps,
        uint8 _amountSteps,
        uint[] memory _timeSteps,
        uint[] memory _rewardTimePerStep,
        uint[] memory _dateSteps,
        bool[] memory _isStepsPerProject,
        uint _startTime,
        bool _isPublicSale
    ) external;

    function orderSteps(
        uint32 _projectIdSteps,
        bool[] memory _isStepsPerProject
    ) external;

    function updatePrice(
        uint32 _projectIdPrice,
        uint _tokenSupply,
        uint _maxTokenSupply,
        uint _minTokenSale,
        uint _price,
        uint _publicSale,
        bool _isProjectAlive,
        uint _fundsForProject
    ) external;

    function orderPrice(
        uint32 _projectIdPrice,
        uint _tokenSupply,
        uint _fundsForProject
    ) external;

    function witchStepAlive(
        uint32 _projectId
    ) external view returns (uint8 step);

    function updateAfterSBSFund(
        uint32 _projectIdSteps,
        uint8 _stepIsLive
    ) external;

    function closeProject(uint32 _projectIdPrice) external;

    function setGettingAllTokens(uint32 _projectIdPrice) external;
}

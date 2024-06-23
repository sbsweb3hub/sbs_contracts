// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ProjectToken.sol";

interface ICreateProject {
    function create(
        string memory _projectName,
        string memory _projectSymbol,
        uint256 _maxTokenSupply,
        uint256 _minTokenSale,
        uint256 _price,
        uint256 _publicSale,
        uint256 _amountSteps,
        uint256[] memory _timeSteps
    ) external returns (uint32, uint32, uint32);

    function ownerOfProject(uint32 projectId) external view returns (address);

    function isPublicSale(uint32 projectId) external view returns (bool);

    function projectsViewSteps(uint32 projectId)
        external
        view
        returns (uint8, uint256[] memory, uint256[] memory, uint256[] memory, bool[] memory, uint256, bool);

    function projectsViewPrice(uint32 projectId)
        external
        view
        returns (uint256, uint256, uint256, uint256, uint256, bool, bool, uint256);

    function projectsViewMain(uint32 projectId)
        external
        view
        returns (ProjectToken, address, string memory, string memory);

    function updateSteps(
        uint32 _projectIdSteps,
        uint8 _amountSteps,
        uint256[] memory _timeSteps,
        uint256[] memory _rewardTimePerStep,
        uint256[] memory _dateSteps,
        bool[] memory _isStepsPerProject,
        uint256 _startTime,
        bool _isPublicSale
    ) external;

    function orderSteps(uint32 _projectIdSteps, bool[] memory _isStepsPerProject) external;

    function updatePrice(
        uint32 _projectIdPrice,
        uint256 _tokenSupply,
        uint256 _maxTokenSupply,
        uint256 _minTokenSale,
        uint256 _price,
        uint256 _publicSale,
        bool _isProjectAlive,
        uint256 _fundsForProject
    ) external;

    function orderPrice(uint32 _projectIdPrice, uint256 _tokenSupply, uint256 _fundsForProject) external;

    function witchStepAlive(uint32 _projectId) external view returns (uint8 step);

    function updateAfterSBSFund(uint32 _projectIdSteps, uint8 _stepIsLive) external;

    function closeProject(uint32 _projectIdPrice) external;

    function setGettingAllTokens(uint32 _projectIdPrice) external;
}

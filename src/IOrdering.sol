// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IOrdering {
    function getFundByProject(
        uint32 _projectId,
        uint256 _sbsFundForProject,
        uint256 _sbsFeeReward,
        address _onwerProject
    ) external;

    function getUserOrderedTokens(uint32 _projectId, address _user) external view returns (uint256);

    function setZeroOrderedTokens(uint32 _projectId, address _user) external;

    function getTokensAlreadyClaimed(uint32 _projectId, address _user) external view returns (uint256);

    function setTokensAlreadyClaimed(uint32 _projectId, address _user, uint256 _amount) external;
}

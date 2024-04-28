// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IOrdering {

    function getFundByProject(uint32 _projectId, uint _sbsFundForProject, uint _sbsFeeReward, address _onwerProject) external;

    function getUserOrderedTokens(uint32 _projectId, address _user) external view returns(uint);

    function setZeroOrderedTokens(uint32 _projectId, address _user) external;

    function getTokensAlreadyClaimed(uint32 _projectId, address _user) external view returns(uint);
    
    function setTokensAlreadyClaimed(uint32 _projectId, address _user, uint _amount) external; 

}
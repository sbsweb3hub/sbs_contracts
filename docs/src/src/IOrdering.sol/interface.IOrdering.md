# IOrdering
[Git Source](https://github.com/sbsweb3hub/sbs_contracts/blob/6b40f2679f7e03f7398df97700949af278bd88cc/src/IOrdering.sol)


## Functions
### getFundByProject


```solidity
function getFundByProject(
    uint32 _projectId,
    uint _sbsFundForProject,
    uint _sbsFeeReward,
    address _onwerProject
)
    external;
```

### getUserOrderedTokens


```solidity
function getUserOrderedTokens(uint32 _projectId, address _user) external view returns (uint);
```

### setZeroOrderedTokens


```solidity
function setZeroOrderedTokens(uint32 _projectId, address _user) external;
```

### getTokensAlreadyClaimed


```solidity
function getTokensAlreadyClaimed(uint32 _projectId, address _user) external view returns (uint);
```

### setTokensAlreadyClaimed


```solidity
function setTokensAlreadyClaimed(uint32 _projectId, address _user, uint _amount) external;
```


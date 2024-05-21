# ProjectManagerSteps
[Git Source](https://github.com/sbsweb3hub/sbs_contracts/blob/6b40f2679f7e03f7398df97700949af278bd88cc/src/ProjectManagerSteps.sol)


## State Variables
### startAddr

```solidity
address public startAddr;
```


### orderingAddrStep

```solidity
address public orderingAddrStep;
```


### tokensForProjectAddrStep

```solidity
address public tokensForProjectAddrStep;
```


### projectIdSteps

```solidity
uint32 public projectIdSteps = 1;
```


### getProjectSteps

```solidity
mapping(uint32 => CreateSteps) getProjectSteps;
```


## Functions
### setUsingAddrsForSteps


```solidity
function setUsingAddrsForSteps(address _startAddr, address _orderingAddr, address _tokensMainForProjectAddr) internal;
```

### projectsViewSteps


```solidity
function projectsViewSteps(uint32 projectId)
    public
    view
    returns (uint8, uint[] memory, uint[] memory, uint[] memory, bool[] memory, uint, bool);
```

### createProjectSteps


```solidity
function createProjectSteps(uint8 _amountSteps, uint[] memory _timeSteps) internal returns (uint32);
```

### updateSteps


```solidity
function updateSteps(
    uint32 _projectIdSteps,
    uint8 _amountSteps,
    uint[] memory _timeSteps,
    uint[] memory _rewardTimePerStep,
    uint[] memory _dateSteps,
    bool[] memory _isStepsPerProject,
    uint _startTime,
    bool _isPublicSale
)
    external;
```

### orderSteps


```solidity
function orderSteps(uint32 _projectIdSteps, bool[] memory _isStepsPerProject) external;
```

### updateAfterSBSFund


```solidity
function updateAfterSBSFund(uint32 _projectIdSteps, uint8 _stepIsLive) external;
```

## Events
### ProjectCreatedSteps

```solidity
event ProjectCreatedSteps(CreateSteps project);
```

### ProjectStartSteps

```solidity
event ProjectStartSteps(uint projectIdSteps);
```

## Structs
### CreateSteps

```solidity
struct CreateSteps {
    uint8 amountSteps;
    uint[] timeSteps;
    uint[] rewardTimePerStep;
    uint[] dateSteps;
    bool[] isStepsPerProject;
    uint startTime;
    bool isPublicSale;
}
```


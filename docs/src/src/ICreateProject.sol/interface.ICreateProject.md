# ICreateProject
[Git Source](https://github.com/sbsweb3hub/sbs_contracts/blob/6b40f2679f7e03f7398df97700949af278bd88cc/src/ICreateProject.sol)


## Functions
### create


```solidity
function create(
    string memory _projectName,
    string memory _projectSymbol,
    uint _maxTokenSupply,
    uint _minTokenSale,
    uint _price,
    uint _publicSale,
    uint _amountSteps,
    uint[] memory _timeSteps
)
    external
    returns (uint32, uint32, uint32);
```

### ownerOfProject


```solidity
function ownerOfProject(uint32 projectId) external view returns (address);
```

### isPublicSale


```solidity
function isPublicSale(uint32 projectId) external view returns (bool);
```

### projectsViewSteps


```solidity
function projectsViewSteps(uint32 projectId)
    external
    view
    returns (uint8, uint[] memory, uint[] memory, uint[] memory, bool[] memory, uint, bool);
```

### projectsViewPrice


```solidity
function projectsViewPrice(uint32 projectId) external view returns (uint, uint, uint, uint, uint, bool, bool, uint);
```

### projectsViewMain


```solidity
function projectsViewMain(uint32 projectId)
    external
    view
    returns (ProjectToken, address, string memory, string memory);
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

### updatePrice


```solidity
function updatePrice(
    uint32 _projectIdPrice,
    uint _tokenSupply,
    uint _maxTokenSupply,
    uint _minTokenSale,
    uint _price,
    uint _publicSale,
    bool _isProjectAlive,
    uint _fundsForProject
)
    external;
```

### orderPrice


```solidity
function orderPrice(uint32 _projectIdPrice, uint _tokenSupply, uint _fundsForProject) external;
```

### witchStepAlive


```solidity
function witchStepAlive(uint32 _projectId) external view returns (uint8 step);
```

### updateAfterSBSFund


```solidity
function updateAfterSBSFund(uint32 _projectIdSteps, uint8 _stepIsLive) external;
```

### closeProject


```solidity
function closeProject(uint32 _projectIdPrice) external;
```

### setGettingAllTokens


```solidity
function setGettingAllTokens(uint32 _projectIdPrice) external;
```


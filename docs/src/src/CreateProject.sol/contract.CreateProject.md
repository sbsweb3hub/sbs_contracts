# CreateProject
[Git Source](https://github.com/sbsweb3hub/sbs_contracts/blob/6b40f2679f7e03f7398df97700949af278bd88cc/src/CreateProject.sol)

**Inherits:**
[ProjectManagerMain](/src/ProjectManagerMain.sol/contract.ProjectManagerMain.md), [ProjectManagerPrice](/src/ProjectManagerPrice.sol/contract.ProjectManagerPrice.md), [ProjectManagerSteps](/src/ProjectManagerSteps.sol/contract.ProjectManagerSteps.md)


## State Variables
### contractOwner

```solidity
address public contractOwner;
```


### claimableAddr

```solidity
address public claimableAddr;
```


### getFundForProjectAddr

```solidity
address public getFundForProjectAddr;
```


### contract_Keeper

```solidity
IProjectsKeeper contract_Keeper;
```


## Functions
### constructor


```solidity
constructor(address _contract_Keeper);
```

### onlyOwner


```solidity
modifier onlyOwner();
```

### setNewOwner


```solidity
function setNewOwner(address _newOwner) public onlyOwner;
```

### setAllowedAddrs


```solidity
function setAllowedAddrs(
    address _startAddr,
    address _claimableAddr,
    address _getFundForProjectAddr,
    address _orderingAddr,
    address _votingAddr
)
    public
    onlyOwner;
```

### create


```solidity
function create(
    string memory _projectName,
    string memory _projectSymbol,
    uint _maxTokenSupply,
    uint _minTokenSale,
    uint _price,
    uint _publicSale,
    uint8 _amountSteps,
    uint[] memory _timeSteps
)
    public
    returns (uint32, uint32, uint32);
```

### ownerOfProject


```solidity
function ownerOfProject(uint32 _projectId) external view returns (address);
```

### setNewOwnerOfProject


```solidity
function setNewOwnerOfProject(uint32 _projectId, address _newOwnerOfProject) public onlyOwner;
```

### isPublicSale


```solidity
function isPublicSale(uint32 _projectId) external view returns (bool);
```

### witchStepAlive


```solidity
function witchStepAlive(uint32 _projectId) public view returns (uint8 step);
```

### setApproveClaimAddresses


```solidity
function setApproveClaimAddresses(uint32 _projectId, address _claimableAddr, address _getFundForProjectAddr) private;
```

### deleteProjectFromArr


```solidity
function deleteProjectFromArr(uint32 _projectId) public;
```


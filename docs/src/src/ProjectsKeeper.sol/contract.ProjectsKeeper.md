# ProjectsKeeper
[Git Source](https://github.com/sbsweb3hub/sbs_contracts/blob/6b40f2679f7e03f7398df97700949af278bd88cc/src/ProjectsKeeper.sol)


## State Variables
### owner

```solidity
address public owner;
```


### creatorContractAddr

```solidity
address public creatorContractAddr;
```


### projects

```solidity
mapping(address => uint32[]) public projects;
```


## Functions
### constructor


```solidity
constructor();
```

### onlyOwner


```solidity
modifier onlyOwner();
```

### onlyApproved


```solidity
modifier onlyApproved();
```

### setNewOwner


```solidity
function setNewOwner(address _newOwner) public onlyOwner;
```

### addNewProject


```solidity
function addNewProject(uint32 _projectId, address _creator) external;
```

### setCreatorContractAddr


```solidity
function setCreatorContractAddr(address _creatorContractAddr) public onlyOwner;
```

### getArrOfCreator


```solidity
function getArrOfCreator(address _creator) public view returns (uint32[] memory);
```

### deleteProject


```solidity
function deleteProject(uint32 _projectId, address _creator) public onlyApproved;
```

### indexOfProject


```solidity
function indexOfProject(uint32[] memory _arrProjectIds, uint32 _projectId) internal pure returns (uint);
```


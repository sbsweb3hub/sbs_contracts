# GetFundForProject
[Git Source](https://github.com/sbsweb3hub/sbs_contracts/blob/6b40f2679f7e03f7398df97700949af278bd88cc/src/GetFundForProject.sol)


## State Variables
### owner

```solidity
address public owner;
```


### locked

```solidity
bool private locked;
```


### sbsFee

```solidity
uint8 public sbsFee;
```


### createProject_contract

```solidity
ICreateProject createProject_contract;
```


### ordering_contract

```solidity
IOrdering ordering_contract;
```


## Functions
### constructor


```solidity
constructor(address _createProject_contract, address _ordering_contract);
```

### reentrancyGuard


```solidity
modifier reentrancyGuard();
```

### onlyOwner


```solidity
modifier onlyOwner();
```

### setNewOwner


```solidity
function setNewOwner(address _newOwner) public onlyOwner;
```

### setSBSFee


```solidity
function setSBSFee(uint8 _sbsFee) public onlyOwner;
```

### getNextFund


```solidity
function getNextFund(uint32 _projectId) public reentrancyGuard;
```

### getAllProjectTokens


```solidity
function getAllProjectTokens(uint32 _projectId) public;
```

## Events
### GetAllProjectTokens

```solidity
event GetAllProjectTokens(address onwerProject, uint allProjectTokens);
```

### sendAllProjectTokensToSBS

```solidity
event sendAllProjectTokensToSBS(address owner, uint allProjectTokens);
```


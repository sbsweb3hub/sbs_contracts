# Claiming
[Git Source](https://github.com/sbsweb3hub/sbs_contracts/blob/6b40f2679f7e03f7398df97700949af278bd88cc/src/Claiming.sol)


## State Variables
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

### claimTokens


```solidity
function claimTokens(uint32 _projectId) public;
```

### earned


```solidity
function earned(uint32 _projectId, address _account) public view returns (uint);
```


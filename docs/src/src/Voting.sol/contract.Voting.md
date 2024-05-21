# Voting
[Git Source](https://github.com/sbsweb3hub/sbs_contracts/blob/6b40f2679f7e03f7398df97700949af278bd88cc/src/Voting.sol)


## State Variables
### createProject_contract

```solidity
ICreateProject createProject_contract;
```


### ordering_contract

```solidity
IOrdering ordering_contract;
```


### votingTime

```solidity
uint32 votingTime = 300;
```


### negativeShare

```solidity
uint8 negativeShare = 51;
```


### projectStepsResultVoting

```solidity
mapping(uint32 => mapping(uint8 => uint)) public projectStepsResultVoting;
```


### isVoting

```solidity
mapping(uint32 => mapping(uint8 => mapping(address => bool))) public isVoting;
```


## Functions
### constructor


```solidity
constructor(address _createProject_contract, address _ordering_contract);
```

### viewProjectResultVoting


```solidity
function viewProjectResultVoting(uint32 _projectId, uint8 _step) public view returns (uint);
```

### vote


```solidity
function vote(uint32 _projectId) public;
```


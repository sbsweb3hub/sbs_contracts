# Ordering
[Git Source](https://github.com/sbsweb3hub/sbs_contracts/blob/6b40f2679f7e03f7398df97700949af278bd88cc/src/Ordering.sol)


## State Variables
### owner

```solidity
address public owner;
```


### operator

```solidity
address private operator;
```


### claimableAddr

```solidity
address public claimableAddr;
```


### getFundForProjectAddr

```solidity
address public getFundForProjectAddr;
```


### createProject_contract

```solidity
ICreateProject createProject_contract;
```


### recievedMoneyFromInvestor

```solidity
mapping(uint => mapping(address => uint)) public recievedMoneyFromInvestor;
```


### orderedTokens

```solidity
mapping(uint => mapping(address => uint)) public orderedTokens;
```


### tokensAlreadyClaimed

```solidity
mapping(uint => mapping(address => uint)) public tokensAlreadyClaimed;
```


## Functions
### constructor


```solidity
constructor(address _createProject_contract, address _blastPointsAddress, address _operator);
```

### onlyOwner


```solidity
modifier onlyOwner();
```

### changeBlastPointsOperator


```solidity
function changeBlastPointsOperator(address _blastPointsAddress, address _newOperator) external;
```

### setNewOwner


```solidity
function setNewOwner(address _newOwner) public onlyOwner;
```

### setClaimableAddrs


```solidity
function setClaimableAddrs(address _claimableAddr, address _getFundForProjectAddr) public onlyOwner;
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

### order


```solidity
function order(uint32 _projectId) public payable;
```

### refundUsers


```solidity
function refundUsers(uint32 _projectId) public;
```

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

### getRecievedMoneyFromInvestor


```solidity
function getRecievedMoneyFromInvestor(uint32 _projectId) public view returns (uint invested, uint all);
```

### fallback


```solidity
fallback() external payable;
```

### receive


```solidity
receive() external payable;
```

## Events
### OrderedTokens

```solidity
event OrderedTokens(address buyer, uint projectId, uint amount);
```

### RefundUser

```solidity
event RefundUser(address user, uint amountForRefund);
```

### SBSFund

```solidity
event SBSFund(uint32 _projectId, address _onwerProject, uint _sbsFundForProject);
```

### SBSFeeReward

```solidity
event SBSFeeReward(uint32 _projectId, address owner, uint _sbsFeeReward);
```


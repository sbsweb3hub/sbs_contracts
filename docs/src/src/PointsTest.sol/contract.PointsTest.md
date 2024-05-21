# PointsTest
[Git Source](https://github.com/sbsweb3hub/sbs_contracts/blob/6b40f2679f7e03f7398df97700949af278bd88cc/src/PointsTest.sol)


## State Variables
### owner

```solidity
address public owner;
```


### operator

```solidity
address private operator;
```


### balances

```solidity
mapping(address => uint) balances;
```


## Functions
### constructor


```solidity
constructor(address _operator);
```

### onlyOwner


```solidity
modifier onlyOwner();
```

### changeBlastPointsOperator


```solidity
function changeBlastPointsOperator(address _newOperator) external;
```

### withdraw


```solidity
function withdraw() public payable;
```

### fallback


```solidity
fallback() external payable;
```

### receive


```solidity
receive() external payable;
```


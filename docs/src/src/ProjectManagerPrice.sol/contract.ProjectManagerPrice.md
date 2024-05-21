# ProjectManagerPrice
[Git Source](https://github.com/sbsweb3hub/sbs_contracts/blob/6b40f2679f7e03f7398df97700949af278bd88cc/src/ProjectManagerPrice.sol)


## State Variables
### orderingAddr

```solidity
address public orderingAddr;
```


### votingAddr

```solidity
address public votingAddr;
```


### tokensMainForProjectAddr

```solidity
address public tokensMainForProjectAddr;
```


### projectIdPrice

```solidity
uint32 public projectIdPrice = 1;
```


### getProjectPrice

```solidity
mapping(uint32 => CreatePrice) getProjectPrice;
```


## Functions
### setUsingAddrsForPrice


```solidity
function setUsingAddrsForPrice(
    address _orderingAddr,
    address _votingAddr,
    address _tokensMainForProjectAddr
)
    internal;
```

### projectsViewPrice


```solidity
function projectsViewPrice(uint32 projectId) public view returns (uint, uint, uint, uint, uint, bool, bool, uint);
```

### createProjectPrice


```solidity
function createProjectPrice(
    uint _maxTokenSupply,
    uint _minTokenSale,
    uint _price,
    uint _publicSale
)
    internal
    returns (uint32);
```

### orderPrice


```solidity
function orderPrice(uint32 _projectIdPrice, uint _tokenSupply, uint _fundsForProject) external;
```

### closeProject


```solidity
function closeProject(uint32 _projectIdPrice) external;
```

### setGettingAllTokens


```solidity
function setGettingAllTokens(uint32 _projectIdPrice) external;
```

## Events
### ProjectCreatedPrice

```solidity
event ProjectCreatedPrice(CreatePrice project);
```

## Structs
### CreatePrice

```solidity
struct CreatePrice {
    uint tokenSupply;
    uint maxTokenSupply;
    uint minTokenSale;
    uint price;
    uint publicSale;
    bool isProjectAlive;
    bool isPrijectGetAllTokens;
    uint fundsForProject;
}
```


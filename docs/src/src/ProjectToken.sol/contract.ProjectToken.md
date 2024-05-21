# ProjectToken
[Git Source](https://github.com/sbsweb3hub/sbs_contracts/blob/6b40f2679f7e03f7398df97700949af278bd88cc/src/ProjectToken.sol)

**Inherits:**
ERC20


## State Variables
### owner

```solidity
address public owner;
```


### claimableAddr

```solidity
address public claimableAddr;
```


### tokensForProjectAddr

```solidity
address public tokensForProjectAddr;
```


## Functions
### constructor


```solidity
constructor(string memory name, string memory symbol) ERC20(name, symbol);
```

### onlyApproved


```solidity
modifier onlyApproved();
```

### setClaimableAddrs


```solidity
function setClaimableAddrs(address _claimableAddr, address _tokensForProjectAddr) public onlyApproved;
```

### mint


```solidity
function mint(address to, uint amount) external onlyApproved;
```


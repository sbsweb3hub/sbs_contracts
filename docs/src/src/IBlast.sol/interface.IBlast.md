# IBlast
[Git Source](https://github.com/sbsweb3hub/sbs_contracts/blob/6b40f2679f7e03f7398df97700949af278bd88cc/src/IBlast.sol)


## Functions
### configureContract


```solidity
function configureContract(address contractAddress, YieldMode _yield, GasMode gasMode, address governor) external;
```

### configure


```solidity
function configure(YieldMode _yield, GasMode gasMode, address governor) external;
```

### configureClaimableYield


```solidity
function configureClaimableYield() external;
```

### configureClaimableYieldOnBehalf


```solidity
function configureClaimableYieldOnBehalf(address contractAddress) external;
```

### configureAutomaticYield


```solidity
function configureAutomaticYield() external;
```

### configureAutomaticYieldOnBehalf


```solidity
function configureAutomaticYieldOnBehalf(address contractAddress) external;
```

### configureVoidYield


```solidity
function configureVoidYield() external;
```

### configureVoidYieldOnBehalf


```solidity
function configureVoidYieldOnBehalf(address contractAddress) external;
```

### configureClaimableGas


```solidity
function configureClaimableGas() external;
```

### configureClaimableGasOnBehalf


```solidity
function configureClaimableGasOnBehalf(address contractAddress) external;
```

### configureVoidGas


```solidity
function configureVoidGas() external;
```

### configureVoidGasOnBehalf


```solidity
function configureVoidGasOnBehalf(address contractAddress) external;
```

### configureGovernor


```solidity
function configureGovernor(address _governor) external;
```

### configureGovernorOnBehalf


```solidity
function configureGovernorOnBehalf(address _newGovernor, address contractAddress) external;
```

### claimYield


```solidity
function claimYield(address contractAddress, address recipientOfYield, uint amount) external returns (uint);
```

### claimAllYield


```solidity
function claimAllYield(address contractAddress, address recipientOfYield) external returns (uint);
```

### claimAllGas


```solidity
function claimAllGas(address contractAddress, address recipientOfGas) external returns (uint);
```

### claimGasAtMinClaimRate


```solidity
function claimGasAtMinClaimRate(
    address contractAddress,
    address recipientOfGas,
    uint minClaimRateBips
)
    external
    returns (uint);
```

### claimMaxGas


```solidity
function claimMaxGas(address contractAddress, address recipientOfGas) external returns (uint);
```

### claimGas


```solidity
function claimGas(
    address contractAddress,
    address recipientOfGas,
    uint gasToClaim,
    uint gasSecondsToConsume
)
    external
    returns (uint);
```

### readClaimableYield


```solidity
function readClaimableYield(address contractAddress) external view returns (uint);
```

### readYieldConfiguration


```solidity
function readYieldConfiguration(address contractAddress) external view returns (uint8);
```

### readGasParams


```solidity
function readGasParams(address contractAddress)
    external
    view
    returns (uint etherSeconds, uint etherBalance, uint lastUpdated, GasMode);
```


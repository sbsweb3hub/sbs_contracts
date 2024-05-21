# ProjectManagerMain
[Git Source](https://github.com/sbsweb3hub/sbs_contracts/blob/6b40f2679f7e03f7398df97700949af278bd88cc/src/ProjectManagerMain.sol)


## State Variables
### projectIdMain

```solidity
uint32 public projectIdMain = 1;
```


### getProjectMain

```solidity
mapping(uint32 => CreateMain) getProjectMain;
```


## Functions
### projectsViewMain


```solidity
function projectsViewMain(uint32 projectId) public view returns (ProjectToken, address, string memory, string memory);
```

### createProjectMain


```solidity
function createProjectMain(string memory _projectName, string memory _projectSymbol) internal returns (uint32);
```

## Events
### ProjectCreatedMain

```solidity
event ProjectCreatedMain(CreateMain project);
```

## Structs
### CreateMain

```solidity
struct CreateMain {
    ProjectToken projectContract;
    address owner;
    string projectName;
    string projectSymbol;
}
```


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ProjectToken is ERC20 {
    address public owner;
    address public claimableAddr;
    address public tokensForProjectAddr;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner = msg.sender;
    }

    modifier onlyApproved() {
        require(
            msg.sender == owner || msg.sender == claimableAddr || msg.sender == tokensForProjectAddr,
            "Only owner/approved!"
        );
        _;
    }

    function setClaimableAddrs(address _claimableAddr, address _tokensForProjectAddr) public onlyApproved {
        claimableAddr = _claimableAddr;
        tokensForProjectAddr = _tokensForProjectAddr;
    }

    function mint(address to, uint256 amount) external onlyApproved {
        _mint(to, amount);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "openzeppelin/token/ERC20/ERC20.sol";

contract TestToken is ERC20 {
    constructor(uint256 initialSupply) public ERC20("Roo", "ROO") {
        _mint(msg.sender, initialSupply);
    }
}

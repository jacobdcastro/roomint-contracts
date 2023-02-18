// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Joey.sol";

contract Roo {
    event ContractDeployed(address deployer, address contractAddress);

    uint256 public etherDeployCost;
    mapping(address => mapping(bool => uint256))
        public supportedTokenDeployCost;
    bool public deprecated;

    constructor(uint256 _etherDeployCost) {
        etherDeployCost = _etherDeployCost;
    }

    modifier verifyPayment(address tokenAddress) {
        require(msg.value >= 0.1 ether, "Not enough ETH sent");
        _;
    }

    function deployContract(
        string memory _name,
        string memory _symbol,
        bool paidInEther
    )
        public
        payable
        verifyPayment(paidInEther ? address(0) : address(1))
        returns (address)
    {
        SoloMint soloMint = new SoloMint(_name, _symbol);
        return address(soloMint);
    }
}

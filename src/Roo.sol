// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Joey.sol";
import "forge-std/console.sol";
import "openzeppelin/access/ownable.sol";
import "openzeppelin/token/ERC20/IERC20.sol";

contract Roo is Ownable {
    uint256 public etherDeployCost;
    mapping(address => uint256) public tokenDeployCost;
    bool public deprecated;
    address public vaultAddress;

    event ContractDeployed(address deployer, address contractAddress);

    constructor(
        uint256 _etherDeployCost,
        address _vaultAddress,
        address _admin
    ) {
        etherDeployCost = _etherDeployCost;
        vaultAddress = _vaultAddress;
        _transferOwnership(_admin);
    }

    function setEtherDeployCost(uint256 _etherDeployCost) external onlyOwner {
        etherDeployCost = _etherDeployCost;
    }

    function addTokenSupport(address _tokenAddress, uint256 _tokenDeployCost)
        external
        onlyOwner
    {
        tokenDeployCost[_tokenAddress] = _tokenDeployCost;
    }

    function removeTokenSupport(address _tokenAddress) external onlyOwner {
        delete tokenDeployCost[_tokenAddress];
    }

    function deployContractWithEther(string memory _name, string memory _symbol)
        public
        payable
        returns (address)
    {
        require(msg.value == etherDeployCost, "ETH amount paid is incorrect");
        Joey joey = new Joey(_name, _symbol);
        return address(joey);
    }

    function deployContractWithToken(
        string memory _name,
        string memory _symbol,
        address _tokenAddress,
        uint256 _amount
    ) public payable returns (address) {
        uint256 price = tokenDeployCost[_tokenAddress];
        require(
            price > 0,
            "Token address invalid, we may not support this token"
        );
        require(_amount == price, "Token amount paid is incorrect");

        IERC20 token = IERC20(_tokenAddress);
        token.transferFrom(msg.sender, vaultAddress, _amount);
        Joey joey = new Joey(_name, _symbol);
        return address(joey);
    }
}

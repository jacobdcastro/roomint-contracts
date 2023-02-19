// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Roo.sol";
import "../src/utils/TestToken.sol";

contract RooTest is Test {
    Roo roo;
    TestToken testToken;
    address vaultAddress = address(14);
    address strangerWallet = address(333);

    function setUp() public {
        roo = new Roo(0.02 ether, address(14), address(this));
        testToken = new TestToken(1400);
        roo.addTokenSupport(address(testToken), 100);
    }

    // admin tests (as owner)

    function testAdmin() public {
        assertTrue(roo.owner() == address(this));
    }

    function testSetEtherDeployCost() public {
        roo.setEtherDeployCost(0.14 ether);
        assertTrue(roo.etherDeployCost() == 0.14 ether);
    }

    function testAddTokenSupport() public {
        roo.addTokenSupport(address(1), 100);
        assertTrue(roo.tokenDeployCost(address(1)) == 100);
    }

    function testRemoveTokenSupport() public {
        roo.removeTokenSupport(address(testToken));
        assertTrue(roo.tokenDeployCost(address(testToken)) == 0);
    }

    function testTransferOwnership() public {
        roo.transferOwnership(strangerWallet);
        assertTrue(roo.owner() != address(this));
        assertTrue(roo.owner() == strangerWallet);
    }

    // admin tests (as non-owner)

    function testFailSetEtherDeployCost() public {
        vm.prank(strangerWallet);
        roo.setEtherDeployCost(0.14 ether);
    }

    function testFailAddTokenSupport() public {
        vm.prank(strangerWallet);
        roo.addTokenSupport(strangerWallet, 100);
    }

    function testFailRemoveTokenSupport() public {
        vm.prank(strangerWallet);
        roo.removeTokenSupport(address(testToken));
    }

    function testFailTransferOwnership() public {
        vm.prank(strangerWallet);
        roo.transferOwnership(strangerWallet);
    }

    // Ether deployment tests

    function testDeployContractWithEther() public {
        address joey = roo.deployContractWithEther{value: 0.02 ether}(
            "Joey",
            "JOEY"
        );
        assertTrue(joey != address(0));
    }

    function testCannotDeployContractNotEnoughEther() public {
        vm.expectRevert(bytes("ETH amount paid is incorrect"));
        roo.deployContractWithEther{value: 0.0011 ether}("Joey", "JOEY");
    }

    function testCannotDeployContractTooMuchEther() public {
        vm.expectRevert(bytes("ETH amount paid is incorrect"));
        roo.deployContractWithEther{value: 100 ether}("Joey", "JOEY");
    }

    // Token deployment tests

    function testTestTokenBalance() public {
        uint256 balance = testToken.balanceOf(address(this));
        assertTrue(balance == 1400);
    }

    function testDeployContractWithToken() public {
        testToken.approve(address(roo), 100);
        roo.deployContractWithToken("Joey", "JOEY", address(testToken), 100);
    }

    function testCannotDeployContractNotEnoughToken() public {
        testToken.approve(address(roo), 100);
        vm.expectRevert(bytes("Token amount paid is incorrect"));
        roo.deployContractWithToken("Joey", "JOEY", address(testToken), 1);
    }

    function testCannotDeployContractTooMuchToken() public {
        testToken.approve(address(roo), 100);
        vm.expectRevert(bytes("Token amount paid is incorrect"));
        roo.deployContractWithToken("Joey", "JOEY", address(testToken), 1000);
    }

    function testCannotDeployContractWithTokenNotSupported() public {
        testToken.approve(address(14), 100);
        vm.expectRevert(
            bytes("Token address invalid, we may not support this token")
        );
        roo.deployContractWithToken("Joey", "JOEY", address(1), 100);
    }
}

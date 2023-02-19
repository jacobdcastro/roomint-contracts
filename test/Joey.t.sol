// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Joey.sol";

// this only tests the Joey contract alone and
// NOT within the context of the Roo deployment contract
contract JoeyTest is Test {
    Joey joey;
    address public owner = 0xaFA353D34e6852ca1E49Da56f2F49e03aecEf325;

    function setUp() public {
        // simulate a user's regular EOA address for every test
        vm.startPrank(owner, owner);
        joey = new Joey("Test Joey", "JOEY");
    }

    function testInitialTokenURI() public {
        joey.createNft(owner, "fakeuri");
        assertEq(joey.tokenURI(0), "ipfs://fakeuri");
    }

    function testCreateNft() public {
        joey.createNft(owner, "fakeuri");
        assertEq(Joey(joey).balanceOf(owner), 1);
    }

    function testCreateBatchNfts() public {
        address[] memory tos = new address[](3);
        tos[0] = owner;
        tos[1] = owner;
        tos[2] = owner;
        string[] memory uris = new string[](3);
        uris[0] = "fakeuri1";
        uris[1] = "fakeuri2";
        uris[2] = "fakeuri3";
        joey.createBatchNfts(tos, uris);
        assertEq(joey.balanceOf(owner), 3);
    }

    function testSetTokenURI() public {
        joey.createNft(owner, "fakeuri");
        joey.setTokenURI(0, "newuri");
        assertEq(joey.tokenURI(0), "ipfs://newuri");
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/YourContract.sol";

contract YourContractTest is Test {
    YourContract public yourContract;

    function setUp() public {
        yourContract = new YourContract(vm.addr(1));
    }

    function testMessageOnDeployment() public view {
        uint256 i = 500;
        bytes memory iBytes = abi.encodePacked(i);

        uint256 i2 = uint256(bytes32(iBytes));

        console.log(i2);
        require(
            keccak256(bytes(yourContract.greeting())) ==
                keccak256("Building Unstoppable Apps!!!")
        );
    }

    function testSetNewMessage() public {
        yourContract.setGreeting("Learn Scaffold-ETH 2! :)");
        require(
            keccak256(bytes(yourContract.greeting())) ==
                keccak256("Learn Scaffold-ETH 2! :)")
        );
    }
}

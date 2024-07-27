//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/YourContract.sol";
import "./DeployHelpers.s.sol";

import "../contracts/HatsDiscountHook.sol";
import "../contracts/HatsMintHook.sol";

contract DeployScript is ScaffoldETHDeploy {
    error InvalidPrivateKey(string);

    function setupDeployments()
        public
        view
        returns (address owner, address hats)
    {
        uint256 id;
        assembly {
            id := chainid()
        }

        if (id == 1) {
            owner = 0xc0f0E1512D6A0A77ff7b9C172405D1B0d73565Bf;
            hats = 0x850f3384829D7bab6224D141AFeD9A559d745E3D;
        } else if (id == 10) {
            owner = 0xc0f0E1512D6A0A77ff7b9C172405D1B0d73565Bf;
            hats = 0x850f3384829D7bab6224D141AFeD9A559d745E3D;
        }
    }

    function run() external {
        uint256 deployerPrivateKey = setupLocalhostEnv();
        if (deployerPrivateKey == 0) {
            revert InvalidPrivateKey(
                "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
            );
        }
        vm.startBroadcast(deployerPrivateKey);

        // YourContract yourContract = new YourContract(
        //     vm.addr(deployerPrivateKey)
        // );
        // console.logString(
        //     string.concat(
        //         "YourContract deployed at: ",
        //         vm.toString(address(yourContract))
        //     )
        // );

        (address owner, address hats) = setupDeployments();

        // new HatsDiscountHook(owner, hats);
        new HatsMintHook(owner, hats);

        vm.stopBroadcast();

        /**
         * This function generates the file containing the contracts Abi definitions.
         * These definitions are used to derive the types needed in the custom scaffold-eth hooks, for example.
         * This function should be called last.
         */
        exportDeployments();
    }

    function test() public {}
}

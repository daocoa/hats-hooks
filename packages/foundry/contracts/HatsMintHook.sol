//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./IPublicLock.sol";
import "../lib/hats-protocol/src/Interfaces/IHats.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HatsMintHook is Ownable {
    error HatsMintHook__NotLock();
    IHats s_hats;

    mapping(address lock => uint256 hatId) hatsToMint;

    constructor(address owner, address hats) Ownable(owner) {
        s_hats = IHats(hats);
    }

    function setHatToMint(address lock, uint hatId) public onlyOwner {
        hatsToMint[lock] = hatId;
    }

    //This contract needs to be an admin of the hat to mint
    function onKeyPurchase(
        uint256 /* tokenId */,
        address /*from*/,
        address recipient,
        address /*referrer*/,
        bytes calldata /*signature*/,
        uint256 /*minKeyPrice*/,
        uint256 /*pricePaid*/
    ) external {
        if (hatsToMint[msg.sender] == 0) {
            revert HatsMintHook__NotLock();
        }

        // Optionally mint the hat to the recipient
        s_hats.mintHat(hatsToMint[msg.sender], recipient);
    }
}

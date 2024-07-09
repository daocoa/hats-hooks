//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./IPublicLock.sol";
import "../lib/hats-protocol/src/Interfaces/IHats.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HatsDiscountHook is Ownable {
    IHats s_hats;

    mapping(address lock => mapping(uint256 hatId => uint256 price)) hatRequirementsPrices;
    mapping(address lock => mapping(uint256 hatId => uint256 minBalance)) hatRequirementsMinBalance;

    constructor(address owner, address hats) Ownable(owner) {
        s_hats = IHats(hats);
    }

    function setHatRequirement(
        address lock,
        uint hatId,
        uint price,
        uint minBalanceRequiredForDiscount
    ) public onlyOwner {
        hatRequirementsPrices[lock][hatId] = price;
        hatRequirementsMinBalance[lock][hatId] = minBalanceRequiredForDiscount;
    }

    function keyPurchasePrice(
        address /* from */,
        address recipient,
        address /* referrer */,
        bytes calldata data
    ) external view returns (uint256 keyPrice) {
        address lock = msg.sender;
        uint256 hatId = uint256(bytes32(data));

        if (
            s_hats.balanceOf(recipient, hatId) >=
            hatRequirementsMinBalance[lock][hatId]
        ) {
            keyPrice = hatRequirementsPrices[lock][hatId];
        } else {
            keyPrice = IPublicLock(lock).keyPrice();
        }
    }
}

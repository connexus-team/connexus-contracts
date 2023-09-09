// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract UtilityConnexus is ERC20, Ownable {
    constructor() ERC20("ConnexusToken", "CNToken") {}

    function _mintUtility(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}

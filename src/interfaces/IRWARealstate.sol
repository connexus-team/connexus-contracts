// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


interface IRWARealstate {
    function mint(
        uint256 number,
        string memory linkdoc,
        uint256 fraction,
        address accountOrTBA
    ) external;
}

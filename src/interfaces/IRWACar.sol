// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


interface IRWACar {
     function safeMint(
        uint256 numberChassi,
        string memory doclink,
        address accountOrTBA
    ) external;

    function _mintWithTokens(address recipient) external returns (uint256);
}

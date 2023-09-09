// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

///@dev in this case the CONNEXUS already has the tba and we will define the addresses by setting the setERC6551 functions.
//The user will mint his card and receive his account ID already with his assets linked to his cardtba
interface IConnexusCard {
    function safeMint(address to) external returns (uint256);

    function getNextTokenId() external view returns (uint256);

    function setERC6551Registry(address registry) external;

    function setERC6551Implementation(address implementation) external;
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC6551Registry} from "@ERC6551/interfaces/IERC6551Registry.sol";
import {ERC721A} from "@chiru-labs/ERC721A/ERC721A.sol";

///@dev in this case the CONNEXUS already has the tba and we will define the addresses by setting the setERC6551 functions.
//The user will mint his card and receive his account ID already with his assets linked to his cardtba
contract ConnexusCard is ERC721A {
    /* solhint-disable var-name-mixedcase, private-vars-leading-underscore */

    error ConnexusCard__CallerMustBeManagement();

    IERC6551Registry private s_erc6551Registry;
    address private s_erc6551AccountImplementation;
    address private s_cncToken;
    address private s_wDrex;
    address private i_management;

    error InvalidToken();

    event TBACreated(address indexed tbaAddress);

    function _onlyManagement() private view {
        if (msg.sender != i_management) {
            revert ConnexusCard__CallerMustBeManagement();
        }
    }

    constructor(
        address cncToken,
        address wDrex,
        address erc6551AccountImplementation,
        address erc6551Registry
    ) ERC721A("ConnexusCard", "CNCard") {
        s_cncToken = cncToken;
        s_wDrex = wDrex;
        s_erc6551Registry = IERC6551Registry(erc6551Registry);
        s_erc6551AccountImplementation = erc6551AccountImplementation;
    }

    function setManager(address managment) external {
        i_management = managment;
    }

    function safeMint(address to) external returns (uint256) {
        // _onlyManagement();

        return _mintWithTokens(to);
    }

    /// @dev Sets the address of the ERC6551 registry
    function setERC6551Registry(address registry) external {
        _onlyManagement();

        s_erc6551Registry = IERC6551Registry(registry);
    }

    /// @dev Sets the address of the ERC6551 account implementation
    function setERC6551Implementation(address implementation) external {
        _onlyManagement();

        s_erc6551AccountImplementation = implementation;
    }

    function getNextTokenId() external view returns (uint256) {
        return _nextTokenId();
    }

    /// -----------------------------------------------------------------------
    /// Internal/private functions
    /// -----------------------------------------------------------------------

    function _mintWithTokens(address recipient) internal returns (uint256) {
        uint256 startTokenId = _nextTokenId();

        _safeMint(recipient, 1);

        address tba = s_erc6551Registry.createAccount(
            s_erc6551AccountImplementation,
            block.chainid,
            address(this),
            startTokenId,
            uint256(keccak256("Connexus")),
            ""
        );
        emit TBACreated(tba);

        // transfer realTokenizado from contract to cardtba
        IERC20(s_wDrex).transfer(tba, 100);

        // // transfer Connexus token from contract to cardtba
        // IERC20(s_cncToken).mint(tba, 100);

        return startTokenId;
    }
}

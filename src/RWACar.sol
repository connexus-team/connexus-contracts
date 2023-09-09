// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

///@dev
contract RWACar is ERC721URIStorage {
    /* solhint-disable private-vars-leading-underscore, var-name-mixedcase */

    error RWACar__CallerMustBeManagement();

    address private i_management;

    constructor() ERC721("RWAcarTokenization", "RWAcar") {}

    function setManagement(address management) external {
        i_management = management;
    }

    ///@dev mint RWAcar
    function safeMint(
        uint256 numberChassi,
        string memory doclink,
        address accountOrTBA
    ) public {
        if (msg.sender != i_management) {
            revert RWACar__CallerMustBeManagement();
        }

        _safeMint(accountOrTBA, numberChassi);
        _setTokenURI(numberChassi, doclink);
    }

    // function supportsInterface(
    //     bytes4 interfaceId
    // ) public pure override(ERC721URIStorage) returns (bool) {
    //     return (interfaceId == type(IERC165).interfaceId ||
    //         interfaceId == type(IERC721).interfaceId ||
    //         interfaceId == type(IERC721Metadata).interfaceId ||
    //         interfaceId == bytes4(0x49064906));
    // }
}

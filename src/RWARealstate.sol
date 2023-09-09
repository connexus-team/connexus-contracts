// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";

contract RWARealstate is ERC1155URIStorage {
    /* solhint-disable private-vars-leading-underscore, var-name-mixedcase */

    address private i_management;

    string public name = "RWArealState";
    string public symbol = "RWArS";

    constructor() ERC1155("baseURI") {
    }

     function setMangment(address management) external{
        i_management = management;
    }


    ///@dev mint RWArealState
    function mint(
        uint256 number,
        string memory linkdoc,
        uint256 fraction,
        address accountOrTBA
    ) external {
        _mint(accountOrTBA, number, fraction, "0x00");
        _setURI(number, linkdoc);
    }

    // function supportsInterface(
    //     bytes4 interfaceId
    // ) public pure override(ERC6551Account, ERC1155) returns (bool) {
    //     return (interfaceId == type(IERC165).interfaceId ||
    //         interfaceId == type(IERC1155).interfaceId ||
    //         interfaceId == type(IERC1155MetadataURI).interfaceId ||
    //         interfaceId == type(IERC6551Account).interfaceId);
    // }
}

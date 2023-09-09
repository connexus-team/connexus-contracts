// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC6551Account} from "./ERC6551/ERC6551Account.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC721, IERC165} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import {TokenCallbackHandler} from "./TokenCallbackHandler.sol";

///@dev import for interface ovverride
//import {IERC1271} from "@openzeppelin/contracts/interfaces/IERC1271.sol";
import {IERC777Recipient} from "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {IERC1155Receiver} from "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import {IERC6551Account} from "@ERC6551/interfaces/IERC6551Account.sol";
import {IERC6551Executable} from "@ERC6551/interfaces/IERC6551Executable.sol";

///@dev possibility to create cardtba with NFT bankID from another bank on our CONNEXUS platform
//or migrate your cardtba from another financial institution to our CONNEXUS platform
contract CardTBA is ERC6551Account, TokenCallbackHandler {
    /* solhint-disable var-name-mixedcase, private-vars-leading-underscore */

    function supportsInterface(
        bytes4 interfaceId
    )
        external
        pure
        override(ERC6551Account, TokenCallbackHandler)
        returns (bool)
    {
        return (interfaceId == type(IERC721Receiver).interfaceId ||
            interfaceId == type(IERC1155Receiver).interfaceId ||
            interfaceId == type(IERC777Recipient).interfaceId ||
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC20).interfaceId ||
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC6551Account).interfaceId ||
            interfaceId == type(IERC6551Executable).interfaceId);
    }
}

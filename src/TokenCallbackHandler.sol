// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

/* solhint-disable no-empty-blocks */

import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import {IERC777Recipient} from "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {IERC1155Receiver} from "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

/**
 * Token callback handler.
 *   Handles supported tokens' callbacks, allowing account receiving these tokens.
 */
contract TokenCallbackHandler is
    IERC777Recipient,
    IERC721Receiver,
    IERC1155Receiver
{
    function tokensReceived(
        address,
        address,
        address,
        uint256,
        bytes calldata,
        bytes calldata
    ) external pure override(IERC777Recipient) {}

    function onERC20Received(
        address /* from */,
        uint256 /* amount */
    ) external pure returns (bool) {
        return true;
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override(IERC721Receiver) returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes calldata
    ) external pure override(IERC1155Receiver) returns (bytes4) {
        return IERC1155Receiver.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] calldata,
        uint256[] calldata,
        bytes calldata
    ) external pure override(IERC1155Receiver) returns (bytes4) {
        return IERC1155Receiver.onERC1155BatchReceived.selector;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) external view virtual override(IERC165) returns (bool) {
        return
            interfaceId == type(IERC721Receiver).interfaceId ||
            interfaceId == type(IERC1155Receiver).interfaceId ||
            interfaceId == type(IERC777Recipient).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }
}

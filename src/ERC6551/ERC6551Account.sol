//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {IERC6551Account} from "@ERC6551/interfaces/IERC6551Account.sol";
import {IERC6551Executable} from "@ERC6551/interfaces/IERC6551Executable.sol";
import {IERC721, IERC165} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC1271} from "@openzeppelin/contracts/interfaces/IERC1271.sol";

contract ERC6551Account is IERC6551Account, IERC6551Executable {
    /* solhint-disable no-empty-blocks */

    error ERC6551Account__CallerNotOwner();
    error ERC6551Account__InvalidOperation();

    uint256 private _nonce;

    receive() external payable {}

    function execute(
        address to,//endereco da colecao de NFT
        uint256 value, //0
        bytes calldata data,//encode ApproveForAll(borrow)
        uint256 operation //0
    ) external payable override(IERC6551Executable) returns (bytes memory) {
        if (!_isValidSigner(msg.sender)) {
            revert ERC6551Account__CallerNotOwner();
        }
        if (operation != 0) {
            revert ERC6551Account__InvalidOperation();
        }

        ++_nonce;

        (bool success, bytes memory result) = to.call{value: value}(data);

        if (!success) {
            assembly {
                revert(add(result, 32), mload(result))
            }
        }

        return result;
    }

    function token()
        public
        view
        override(IERC6551Account)
        returns (uint256 chainId, address tokenContract, uint256 tokenId)
    {
        bytes memory footer = new bytes(0x60);

        assembly {
            extcodecopy(address(), add(footer, 0x20), 0x4d, 0x60)
        }

        return abi.decode(footer, (uint256, address, uint256));
    }

    function state() external view override(IERC6551Account) returns (uint256) {
        return _nonce;
    }

    function owner() public view returns (address) {
        (uint256 chainid, address tokenContract, uint256 tokenId) = token();
        if (chainid != block.chainid) return address(0);

        return IERC721(tokenContract).ownerOf(tokenId);
    }

    function isValidSigner(
        address signer,
        bytes calldata /* context */
    ) external view returns (bytes4 /* magicValue */) {
        if (_isValidSigner(signer)) {
            return IERC1271.isValidSignature.selector;
        }

        return bytes4(0);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) external view virtual returns (bool) {
        return
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC20).interfaceId ||
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC6551Account).interfaceId ||
            interfaceId == type(IERC6551Executable).interfaceId;
    }

    function _isValidSigner(address signer) private view returns (bool) {
        return signer == owner();
    }
}

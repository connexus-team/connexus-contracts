//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {IERC6551Account} from "@ERC6551/interfaces/IERC6551Account.sol";
import {IERC6551Executable} from "@ERC6551/interfaces/IERC6551Executable.sol";

interface IERC6551 is IERC6551Account, IERC6551Executable {
    function owner() external view returns (address);

    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

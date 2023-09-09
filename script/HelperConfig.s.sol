// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/** @author Omnes Blockchain team (@EWCunha, @Afonsodalvi and @G-Deps)
    @title Helper configuration contract */

/// -----------------------------------------------------------------------
/// Imports
/// ----------------------------------------------------------------------

import {Script} from "forge-std/Script.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol";

/// -----------------------------------------------------------------------
/// Contract
/// -----------------------------------------------------------------------

contract HelperConfig is Script {
    struct NewtorkConfig {
        address token;
        uint256 deployerKey;
    }

    NewtorkConfig public activeNetworkConfig;

    uint256 public constant DEFAULT_ANVIL_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getTestnetConfig();
        } else if (block.chainid == 1 || block.chainid == 137) {
            activeNetworkConfig = getMainnetConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilConfig();
        }
    }

    function getMainnetConfig() public view returns (NewtorkConfig memory) {
        return
            NewtorkConfig({
                token: address(0),
                deployerKey: vm.envUint("PRIVATE_KEY")
            });
    }

    function getTestnetConfig() public view returns (NewtorkConfig memory) {
        // vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        // ERC20Mock tokenMock = new ERC20Mock();
        // vm.stopBroadcast();

        return
            NewtorkConfig({
                token: address(0), //address(tokenMock),
                deployerKey: vm.envUint("PRIVATE_KEY")
            });
    }

    function getOrCreateAnvilConfig() public returns (NewtorkConfig memory) {
        vm.startBroadcast(vm.addr(DEFAULT_ANVIL_KEY));
        ERC20Mock tokenMock = new ERC20Mock();
        vm.stopBroadcast();

        return
            NewtorkConfig({
                token: address(tokenMock),
                deployerKey: DEFAULT_ANVIL_KEY
            });
    }
}
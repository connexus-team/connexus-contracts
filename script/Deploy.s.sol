// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/** @author hackathon team Connexus
    @title Deploy contract */

/// -----------------------------------------------------------------------
/// Imports
/// ----------------------------------------------------------------------

import {Script, console} from "forge-std/Script.sol";
import {Management} from "../src/Management.sol";
import {RWACar} from "../src/RWACar.sol";
import {RWARealstate} from "../src/RWARealstate.sol";
import {BorrowAndStake} from "../src/BorrowAndStake.sol";
import {RealTokenizado} from "../src/RealTokenizado.sol";
import {ConnexusCard} from "../src/ConnexusCard.sol";
import {CardTBA} from "../src/CardTBA.sol";
import {UtilityConnexus} from "../src/UtilityConnexus.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {ReferenceERC6551Registry} from "../src/ERC6551/ReferenceERC6551Registry.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

/// -----------------------------------------------------------------------
/// Contract
/// -----------------------------------------------------------------------

contract Deploy is Script {
    /* solhint-disable var-name-mixedcase, private-vars-leading-underscore */
    string[] public contractsToDeploy = [
        "Management",
        "RWACar",
        "RWARealstate",
        "BorrowAndStake",
        "ConnexusCard",
        "UtilityConnexus",
        "CardTBA",
        "ERC6551Registry"
    ];

    Management public management;
    Management public managementImplementation;
    RWACar public rwaCar;
    RWARealstate public rwaRealstate;
    RealTokenizado public realTokenizado;
    BorrowAndStake public borrowAndStake;
    UtilityConnexus public utilityConnexus;
    CardTBA public cardTBA;
    ConnexusCard public connexusCard;
    ReferenceERC6551Registry public erc6551Registry;

    HelperConfig public config;
    address public signer;
    address public token;

    ERC1967Proxy public managementUUPS;

    function run() public {
        config = new HelperConfig();

        (address token_, uint256 deployerKey) = config.activeNetworkConfig();

        token = token_;
        signer = vm.rememberKey(deployerKey);

        bool rwaCarDeployed = false; //
        bool rwaRealstateDeployed = false; //
        bool utilityConnexusDeployed = false; //
        bool realTokenizadoDeployed = false; //
        bool borrowAndStakeDeployed = false;
        bool managementNeedDeploy = false;
        bool cardTBADeploy = false; //
        bool connexusCardDeploy = false; //
        bool erc6551RegistryDeploy = false; //

        uint256 cnpjConnexus = 123456;
        string memory participant = "Connexus";
        address reserve = 0xAaa7cCF1627aFDeddcDc2093f078C3F173C46cA4; //connexus owner

        vm.startBroadcast(signer);
        erc6551Registry = new ReferenceERC6551Registry();
        console.log("Erc6551Registry:", address(erc6551Registry));
        erc6551RegistryDeploy = true;

        utilityConnexus = new UtilityConnexus();
        console.log("Utility Connexus:", address(utilityConnexus));

        utilityConnexusDeployed = true;

        realTokenizado = new RealTokenizado(participant, cnpjConnexus, reserve);
        console.log("RealTokenizado:", address(realTokenizado));

        realTokenizadoDeployed = true;

        rwaCar = new RWACar();
        console.log("RWAcar:", address(rwaCar));

        rwaCarDeployed = true;

        rwaRealstate = new RWARealstate();
        console.log("RWARealstate:", address(rwaRealstate));

        rwaRealstateDeployed = true;
        // } else if (
        //     keccak256(abi.encodePacked(contractsToDeploy[ii])) ==
        //     keccak256(abi.encodePacked("ERC721Crowdfund"))
        // ) {
        cardTBA = new CardTBA();
        console.log("cardTBA:", address(cardTBA));
        cardTBADeploy = true;

        borrowAndStake = new BorrowAndStake(
            address(rwaRealstate),
            address(rwaCar),
            address(realTokenizado)
        );
        console.log("BorrowStake:", address(borrowAndStake));
        borrowAndStakeDeployed = true;

        connexusCard = new ConnexusCard(
            address(utilityConnexus),
            address(realTokenizado),
            address(cardTBA),
            address(erc6551Registry)
        );
        console.log("ConnexusCard:", address(connexusCard));
        connexusCardDeploy = true;

        // } else {
        managementNeedDeploy = true;

        console.log("Deploying: Management");
        managementImplementation = new Management();
        console.log("Implementation:", address(managementImplementation));

        bytes memory managementInitialize = abi.encodeWithSelector(
            Management.initialize.selector,
            address(connexusCard),
            address(rwaCar),
            address(rwaRealstate),
            address(cardTBA),
            address(erc6551Registry)
        );
        console.log("Constructor args [1]:", address(managementImplementation));
        console.log("Constructor args [2]:", vm.toString(managementInitialize));

        managementUUPS = new ERC1967Proxy(
            address(managementImplementation),
            managementInitialize
        );
        management = Management(address(managementUUPS));
        console.log("Proxy Managment:", address(managementUUPS));

        vm.stopBroadcast();
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, Vm, console} from "forge-std/Test.sol";

/** @author hackathon team Connexus
    @title Deploy contract */

/// -----------------------------------------------------------------------
/// Imports
/// ----------------------------------------------------------------------

import {Management} from "../src/Management.sol";
import {RWACar} from "../src/RWACar.sol";
import {RWARealstate} from "../src/RWARealstate.sol";
import {BorrowAndStake} from "../src/BorrowAndStake.sol";
import {RealTokenizado} from "../src/RealTokenizado.sol";
import {ConnexusCard} from "../src/ConnexusCard.sol";
import {CardTBA} from "../src/CardTBA.sol";
import {UtilityConnexus} from "../src/UtilityConnexus.sol";
import {ReferenceERC6551Registry} from "../src/ERC6551/ReferenceERC6551Registry.sol";

import {MockERC721} from "./mocks/MockERC721.sol";
import "./mocks/MockERC6551Account.sol";

import {Deploy} from "../script/Deploy.s.sol";

contract ManagementTest is Test {
    // using stdStorage for StdStorage;

    Deploy public deployer;
    Management public management;
    RWACar public rwaCar;
    RWARealstate public rwaRealstate;
    RealTokenizado public realTokenizado;
    BorrowAndStake public borrowAndStake;
    UtilityConnexus public utilityConnexus;
    CardTBA public cardTBA;
    ConnexusCard public connexusCard;
    ReferenceERC6551Registry public erc6551Registry;
    MockERC721 public nft;

    address public signer;
    address public user;

    MockERC721 public erc721Mock;

    function setUp() external {
        deployer = new Deploy();
        deployer.run();

        management = deployer.management();
        realTokenizado = deployer.realTokenizado();
        connexusCard = deployer.connexusCard();

        signer = deployer.signer();
        user = makeAddr("user");
        vm.deal(user, 1 ether);
        deal(address(realTokenizado), address(connexusCard), 100 ether);

        erc721Mock = new MockERC721();
        erc721Mock.mint(user, 0);
    }

    // VM Cheatcodes can be found in ./lib/forge-std/src/Vm.sol
    // Or at https://github.com/foundry-rs/forge-std
    function testCreateConnexusCardSuccess() external {
        vm.prank(user, user);
        address tba = management.createConnexusCard(user);

        assertEq(CardTBA(payable(tba)).owner(), user);
    }

    function testCreateBankTBACardSuccess() external {
        vm.prank(user, user);
        address tba = management.createBankTBACard(address(erc721Mock), 0);

        assertEq(CardTBA(payable(tba)).owner(), user);
    }

    // function testImportTBAAccount() external {
    //     vm.prank(user, user);
    //     address tba = management.createBankTBACard(address(erc721Mock), 0);

    //     assertEq(CardTBA(payable(tba)).owner(), user);
    // }
}

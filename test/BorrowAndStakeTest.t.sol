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

contract BorrowAndStakeTest is Test {
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

    address public tba;

    function setUp() external {
        deployer = new Deploy();
        deployer.run();

        management = deployer.management();
        realTokenizado = deployer.realTokenizado();
        connexusCard = deployer.connexusCard();
        borrowAndStake = deployer.borrowAndStake();
        rwaCar = deployer.rwaCar();

        rwaCar.setManagement(address(management));

        signer = deployer.signer();
        user = makeAddr("user");
        vm.deal(user, 1 ether);
        deal(address(realTokenizado), address(connexusCard), 100 ether);
        deal(address(realTokenizado), address(borrowAndStake), 100 ether);

        erc721Mock = new MockERC721();
        erc721Mock.mint(user, 0);
    }

    modifier stake() {
        vm.startPrank(user, user);
        tba = management.createConnexusCard(user);
        management.tokenizeCar(payable(tba), 1111, "bla.com");
        vm.stopPrank();

        vm.prank(tba);
        rwaCar.setApprovalForAll(address(borrowAndStake), true);

        vm.prank(user);
        borrowAndStake.stakeCar(1111, payable(tba));

        _;
    }

    // VM Cheatcodes can be found in ./lib/forge-std/src/Vm.sol
    // Or at https://github.com/foundry-rs/forge-std
    function testBorrowSuccess() external stake {
        uint256 balanceBefore = realTokenizado.balanceOf(tba);

        vm.prank(user);
        borrowAndStake.borrow(
            BorrowAndStake.ValueBorrowed.MINIMUM,
            payable(tba)
        );

        uint256 balanceAfter = realTokenizado.balanceOf(tba);
        // BorrowAndStake.Borrow memory borrow = borrowAndStake.borrows(tba);
        (
            uint256 amountBorrowed,
            uint256 borrowFee,
            uint256 borrowedTimestamp
        ) = borrowAndStake.borrows(tba);

        assertEq(balanceAfter, balanceBefore + 500_000);
        assertEq(borrowFee, 150);
    }

    // function testCreateBankTBACardSuccess() external {
    //     vm.prank(user, user);
    //     address tba = management.createBankTBACard(address(erc721Mock), 0);

    //     assertEq(CardTBA(payable(tba)).owner(), user);
    // }

    // function testImportTBAAccount() external {
    //     vm.prank(user, user);
    //     address tba = management.createBankTBACard(address(erc721Mock), 0);

    //     assertEq(CardTBA(payable(tba)).owner(), user);
    // }
}

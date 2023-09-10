// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ReentrancyGuardUpgradeable} from "@openzeppelin-upgradeable/contracts/security/ReentrancyGuardUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin-upgradeable/contracts/security/PausableUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC6551Registry} from "@ERC6551/interfaces/IERC6551Registry.sol";

import {BorrowAndStake} from "./BorrowAndStake.sol";
import {OpenBankingStorage} from "./storage/OpenBankingStorage.sol";
import {IConnexusCard} from "./interfaces/IConnexusCard.sol";
import {IERC6551Account, IERC6551Executable} from "./ERC6551/ERC6551Account.sol";
import {IERC6551} from "./interfaces/IERC6551.sol";

import {IRWACar} from "./interfaces/IRWACar.sol";
import {IRWARealstate} from "./interfaces/IRWARealstate.sol";

contract Management is
    UUPSUpgradeable,
    OwnableUpgradeable, //Initializable in here
    PausableUpgradeable,
    ReentrancyGuardUpgradeable
{
    error Management__AddressNotERC721Token();
    error Management__CallerNotERC721Owner();
    error Management__AddressNotERC6551Account();
    error Management__CallerNotERC6551Owner();

    /* solhint-disable var-name-mixedcase, private-vars-leading-underscore */
    IConnexusCard private s_connexusCard;

    ///@dev tokenize RWA
    IRWACar private s_RWACar;
    IRWARealstate private s_RWArealsate;

    IERC6551Registry private s_erc6551Registry;
    address private s_cardTBAImplementation;
    mapping(address => address) private s_collectionToBank;
    mapping(address => bool) private s_bankPermission;
    mapping(address => bool) private s_managers;
    mapping(address => address) private s_usersToStorage;

    event tbaAddr(address indexed tba);

    function __nonReentrant() private nonReentrant {}

    function __whenNotPaused() private view whenNotPaused {}

    function _onlyAllowed() private view {
        if (!s_managers[msg.sender]) {
            revert();
        }
    }

    function _onlyAllowedBanks() private view {
        if (!s_bankPermission[msg.sender]) {
            revert();
        }
    }

    function initialize(
        address connexusCard,
        address rwaCar,
        address rwaRealstate,
        address cardTBAImplementation,
        address erc6551Registry
    ) external initializer {
        __ReentrancyGuard_init();
        __Pausable_init();
        __Ownable_init();

        s_managers[tx.origin] = true;
        s_RWACar = IRWACar(rwaCar);
        s_RWArealsate = IRWARealstate(rwaRealstate);
        s_connexusCard = IConnexusCard(connexusCard);
        s_cardTBAImplementation = cardTBAImplementation;
        s_erc6551Registry = IERC6551Registry(erc6551Registry);
        //s_connexusCard.setERC6551Implementation(cardTBAImplementation);
        //s_connexusCard.setERC6551Registry(erc6551Registry);
    }

    /**
     * @dev Create TBA card connexus, import and create TBA card with NFT another bank. Lastly, import full TBA.
     *
     * The functions below are for creating TBA ERC6551 accounts, where the connection would be minted an NFT and the TBA
     * created by this NFT created on the platform. The second hypothesis would be for users
     * to make their NFTs from banks and create TBAs in the connection and finally import a
     * TBA already created in another financial institution.
     */
    function createConnexusCard(address to) external returns (address) {
        _createStorageIfNeeded();
        s_connexusCard.safeMint(to);

        address tba = s_erc6551Registry.account(
                s_cardTBAImplementation,
                block.chainid,
                address(s_connexusCard),
                s_connexusCard.getNextTokenId() - 1,
                uint256(keccak256("Connexus"))
            );
            emit tbaAddr(tba);

        return
            tba;
            
    }

    function createBankTBACard(
        address collection,
        uint256 tokenId
    ) external returns (address) {
        if (!IERC721(collection).supportsInterface(type(IERC721).interfaceId)) {
            revert Management__AddressNotERC721Token();
        }

        if (IERC721(collection).ownerOf(tokenId) != msg.sender) {
            revert Management__CallerNotERC721Owner();
        }

        _createStorageIfNeeded();

        address tba = s_erc6551Registry.createAccount(
            s_cardTBAImplementation,
            block.chainid,
            collection,
            tokenId,
            uint256(keccak256("Connexus")),
            ""
        );

        emit tbaAddr(tba);

        return tba;
    }

    function importTBAAccount(address payable tba) external {
        if (
            !(IERC6551(tba).supportsInterface(
                type(IERC6551Account).interfaceId
            ) ||
                IERC6551(tba).supportsInterface(
                    type(IERC6551Executable).interfaceId
                ))
        ) {
            revert Management__AddressNotERC6551Account();
        }

        if (IERC6551(tba).owner() != msg.sender) {
            revert Management__CallerNotERC6551Owner();
        }

        _createStorageIfNeeded();
    }

    /**
     *@dev permissions
     * below all permissions
     */
    function removeCollection(address collection) external {
        _onlyAllowed();
        __nonReentrant();
        __whenNotPaused();

        s_collectionToBank[collection] = address(0);
    }

    ///@dev

    function setBankCollection(address collection) external {
        _onlyAllowedBanks();
        __nonReentrant();
        __whenNotPaused();

        s_collectionToBank[collection] = msg.sender;
    }

    ///@dev permission bank interact in plataform

    function setBankPermission(address bank, bool permission) external {
        _onlyAllowed();
        __nonReentrant();
        __whenNotPaused();

        s_bankPermission[bank] = permission;
    }

    function setManager(address manager, bool permission) external {
        _onlyAllowed();
        __nonReentrant();
        __whenNotPaused();

        s_managers[manager] = permission;
    }

    ///@dev pause and unpause

    function pause() external {
        _onlyAllowed();
        __nonReentrant();

        _pause();
    }

    function unpause() external {
        _onlyAllowed();
        __nonReentrant();

        _unpause();
    }

    /**
     * @dev tokenize your RWA on the connexus platform
     *
     * The user will be able to tokenize his assets
     * on the platform where he can borrow them at lower rates, placing them as collateral
     */

    function tokenizeCar(
        address payable tba,
        uint256 numberChassi,
        string memory doclink
    ) external {
        if (IERC6551(tba).owner() != msg.sender) {
            revert Management__CallerNotERC6551Owner();
        }

        s_RWACar.safeMint(numberChassi, doclink, tba);
    }

    function tokenizeRealState(
        address payable tba,
        uint256 number,
        string memory linkdoc,
        uint256 fraction
    ) external {
        if (IERC6551(tba).owner() != msg.sender) {
            revert Management__CallerNotERC6551Owner();
        }

        s_RWArealsate.mint(number, linkdoc, fraction, tba);
    }

    /**
     * @dev borrow and stake RWA.
     *
     * The user will select the RWA being a car or a property and entering the amount he wants to borrow.
     * Thus, we will start accounting for payment within the period established for payment of installments.
     */

    function _createStorageIfNeeded() internal {
        if (s_usersToStorage[msg.sender] == address(0)) {
            OpenBankingStorage userStorage = new OpenBankingStorage(msg.sender);
            s_usersToStorage[msg.sender] = address(userStorage);
        }
    }

    function _authorizeUpgrade(
        address /* newImplementation */
    ) internal view override(UUPSUpgradeable) {
        _onlyAllowed();
    }
}

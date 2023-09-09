// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {ICardTBA} from "../interfaces/ICardTBA.sol";
import {ICollateral} from "../interfaces/ICollateral.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract OpenBankingStorage is Ownable, ICardTBA, ICollateral {
    /* solhint-disable var-name-mixedcase, private-vars-leading-underscore */

    struct AccountInfo {
        uint256 balance;
        uint256 index;
        address bank;
        address collection;
        uint256 tokenId;
    }

    struct Score {
        uint256 totalBalance;
        uint256 currentScore;
        uint256 calculatedTimestamp;
        uint256 dueTimestamp;
    }

    address private immutable i_management;
    address[] private s_accounts;
    mapping(address => AccountInfo) private s_accountsInfo;
    Score private s_score;

    constructor(address owner_) {
        i_management = msg.sender;
        transferOwnership(owner_);
    }

    function addToken(
        address bank,
        address collection,
        uint256 tokenId
    ) external {}

    function calculateScore() view external {
        if (block.timestamp < s_score.dueTimestamp) {
            revert();
        }
    }
}

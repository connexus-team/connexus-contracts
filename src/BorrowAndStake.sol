// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import {ERC1155Receiver} from "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {IERC6551} from "./interfaces/IERC6551.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BorrowAndStake is ERC1155Receiver {
    /* solhint-disable var-name-mixedcase, private-vars-leading-underscore, func-param-name-mixedcase */

    error BorrowAndStake__CallerNotERC6551Owner();
    error BorrowAndStake__NothingStakedByCaller();

    enum ValueBorrowed {
        MINIMUM, //borrow u$ 1.000 = 5.000 wDREXtr
        MEDIUM, //borrow u$ 5.000 = 25.000 wDREXtr
        HIGH //borrow u$ 10.000 = 50.000 wDREXtr
    }
    enum Asset {
        CAR,
        REAL_STATE
    }

    struct Stake {
        Asset asset;
        uint256 tokenId;
        uint256 amount;
        uint256 timestamp;
    }

    struct Borrow {
        uint256 amountBorrowed;
        uint256 borrowFee;
        uint256 borrowedTimestamp;
    }

    IERC1155 public RWArealS;
    IERC721 public RWAcar;
    address private s_wDrex;

    //mappping staker address para o stake detalhado
    mapping(address => Stake) public stakes;

    //mapping staker to total staking time
    mapping(address => uint256) public stakingTime;

    mapping(address => Borrow) public borrows;

    // DREX has 2 decimals
    uint256 public constant MIN_VALUE = 500_000;
    uint256 public constant MEDIUM_VALUE = 2500_000;
    uint256 public constant HIGH_VALUE = 5_000_000;
    uint256 public constant CAR_BORROW_FEE = 150;
    uint256 public constant REAL_STATE_BORROW_FEE = 100;
    uint256 public constant PRECISION = 10_000;
    uint256 public constant PAY_TIME = 60 seconds; // 60 seconds for testing. Actual value is 30 days.

    constructor(address RWArealState, address _RWAcar, address drex) {
        RWArealS = IERC1155(RWArealState);
        RWAcar = IERC721(_RWAcar);
        s_wDrex = drex;
    }

    function stakeRealState(
        uint256 _tokenId,
        uint256 _amount,
        address payable _tba
    ) external {
        if (IERC6551(_tba).owner() != msg.sender) {
            revert BorrowAndStake__CallerNotERC6551Owner();
        }

        stakes[_tba] = Stake(
            Asset.REAL_STATE,
            _tokenId,
            _amount,
            block.timestamp
        );

        RWArealS.safeTransferFrom(_tba, address(this), _tokenId, _amount, "");
    }

    function stakeCar(uint256 _tokenId, address payable _tba) external {
        if (IERC6551(_tba).owner() != msg.sender) {
            revert BorrowAndStake__CallerNotERC6551Owner();
        }
        stakes[_tba] = Stake(Asset.CAR, _tokenId, 1, block.timestamp);

        RWAcar.safeTransferFrom(_tba, address(this), _tokenId);
    }

    function borrow(ValueBorrowed _value, address payable _tba) public {
        if (IERC6551(_tba).owner() != msg.sender) {
            revert BorrowAndStake__CallerNotERC6551Owner();
        }

        uint256 valueToBorrow = 0;
        if (_value == ValueBorrowed.MINIMUM) {
            valueToBorrow = MIN_VALUE;
        } else if (_value == ValueBorrowed.MEDIUM) {
            valueToBorrow = MEDIUM_VALUE;
        } else {
            valueToBorrow = HIGH_VALUE;
        }

        Stake memory _stake = getStake(_tba);

        if (_stake.timestamp == 0) {
            revert BorrowAndStake__NothingStakedByCaller();
        }
        uint256 borrowFee = _stake.asset == Asset.CAR
            ? CAR_BORROW_FEE
            : REAL_STATE_BORROW_FEE;

        borrows[_tba] = Borrow(valueToBorrow, borrowFee, block.timestamp);

        IERC20(s_wDrex).transfer(_tba, valueToBorrow);
    }

    function payBorrow(address payable _tba) public {
        if (IERC6551(_tba).owner() != msg.sender) {
            revert BorrowAndStake__CallerNotERC6551Owner();
        }

        Borrow memory borrowPay = borrows[_tba];

        uint256 multiplier = (block.timestamp - borrowPay.borrowedTimestamp) /
            PAY_TIME;
        uint256 valueToPay = (borrowPay.amountBorrowed *
            (PRECISION + borrowPay.borrowFee * multiplier)) / PRECISION;

        delete borrows[_tba];

        IERC20(s_wDrex).transferFrom(_tba, address(this), valueToPay);
    }

    function unstakeRealState(address payable _tba) public {
        if (IERC6551(_tba).owner() != msg.sender) {
            revert BorrowAndStake__CallerNotERC6551Owner();
        }

        //tirando o NFT do stake
        RWArealS.safeTransferFrom(
            address(this),
            _tba,
            stakes[_tba].tokenId,
            stakes[_tba].amount,
            ""
        );
        stakingTime[_tba] += (block.timestamp - stakes[_tba].timestamp);
        delete stakes[_tba];
    }

    function unstakeCar(address payable _tba) public {
        if (IERC6551(_tba).owner() != msg.sender) {
            revert BorrowAndStake__CallerNotERC6551Owner();
        }

        //tirando o NFT do stake
        RWAcar.safeTransferFrom(address(this), _tba, stakes[_tba].tokenId);
        stakingTime[_tba] += (block.timestamp - stakes[_tba].timestamp);
        delete stakes[_tba];
    }

    function getStake(address _tba) public view returns (Stake memory) {
        return stakes[_tba];
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override returns (bool) {
        return
            type(IERC721Receiver).interfaceId == interfaceId ||
            ERC1155Receiver.supportsInterface(interfaceId);
    }

    function onERC1155Received(
        address /* operator */,
        address /* from */,
        uint256 /* id */,
        uint256 /* value */,
        bytes calldata /* data */
    ) external override returns (bytes4) {
        return
            bytes4(
                keccak256(
                    "onERC1155Received(address,address,uint256,uint256,bytes)"
                )
            );
    }

    function onERC1155BatchReceived(
        address /* operator */,
        address /* from */,
        uint256[] calldata /* ids */,
        uint256[] calldata /* values */,
        bytes calldata /* data */
    ) external override returns (bytes4) {
        return
            bytes4(
                keccak256(
                    "onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"
                )
            );
    }

    function onERC721Received(
        address /* operator */,
        address /* from */,
        uint256 /* tokenId */,
        bytes calldata /* data */
    ) external returns (bytes4) {
        return
            bytes4(
                keccak256("onERC721Received(address,address,uint256,bytes)")
            );
    }
}

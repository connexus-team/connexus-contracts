// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DREX/RealDigital.sol";

///@dev simple implementation without many restrictions
contract RealTokenizado is RealDigital {
    uint256 public cnpj8; // First 8 digits of the institution's CNPJ
    address public reserve; // Participant institution's reserve wallet.
    string public participant; // String representing the participant's name.

    event burnBrigde(address indexed mintpublic, uint indexed amount);

    constructor(
        string memory _participant, //connexus
        uint256 _cnpj8,
        address _reserve //connexus
    ) RealDigital("RealTokenizado", "WDREXtr") {
        cnpj8 = _cnpj8;
        reserve = _reserve;
        participant = _participant;
    }

    ///@dev mint for address connexus contracts connexusCard or Boreal
    function mint(address _newReserve, uint amount, uint256 _cnpj8) public {
        _mint(_newReserve, amount);
        _cnpj8 = cnpj8;
        reserve = _newReserve;
    }

    ///@dev mint for address connexus contracts connexusCard or Boreal
    function mintBoreal(uint amount) public {
        _mint(msg.sender, amount);
        reserve = msg.sender;
    }

    ///@dev mint for address connexus contracts connexusCard or Boreal
    function mintConnexus(uint amount) public {
        _mint(msg.sender, amount);
        reserve = msg.sender;
    }

    ///@dev burn DREX in address Hyperledger Besu and mint public address
    function burnBridge(address _addrHyperledgerBurn, 
    uint amount, address _mintpublic) public {
        _burn(_addrHyperledgerBurn, amount);
         emit burnBrigde(_mintpublic,amount);
    }
}




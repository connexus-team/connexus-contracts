// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract RealDigital is ERC20, ERC20Burnable, Pausable, Ownable {
    mapping(address => uint256) public frozenBalanceOf;

    event FrozenBalance(address indexed wallet, uint256 amount);

    modifier checkFrozenBalance(address from, uint256 amount) {
        require(
            from == address(0) || balanceOf(from) - frozenBalanceOf[from] >= amount,
            "RealDigital: Insufficient liquid balance"
        );
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol)  {}

    function decimals() public view virtual override returns (uint8) {
        return 2;
    }

    function increaseFrozenBalance(address from, uint256 amount) external whenNotPaused onlyOwner {
        frozenBalanceOf[from] += amount;
        emit FrozenBalance(from, frozenBalanceOf[from]);
    }

    function decreaseFrozenBalance(address from, uint256 amount) external whenNotPaused onlyOwner {
        require(frozenBalanceOf[from] >= amount, "RealDigital: Insufficient frozen balance");
        frozenBalanceOf[from] -= amount;
        emit FrozenBalance(from, frozenBalanceOf[from]);
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override whenNotPaused returns (bool) {
        return super.transfer(recipient, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override whenNotPaused returns (bool) {
        return super.transferFrom(sender, recipient, amount);
    }

    function mint(address to, uint256 amount) external whenNotPaused onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) public override whenNotPaused onlyOwner {
        super.burn(amount);
    }

    function burnFrom(address account, uint256 amount) public override whenNotPaused onlyOwner {
        super.burnFrom(account, amount);
    }

    function move(address from, address to, uint256 amount) public whenNotPaused onlyOwner {
        _transfer(from, to, amount);
    }

    function moveAndBurn(address from, uint256 amount) public whenNotPaused onlyOwner{
        _burn(from, amount);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override checkFrozenBalance(from, amount) {
        super._beforeTokenTransfer(from, to, amount);
    }
}
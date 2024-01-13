// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor(uint256 initialSupply) ERC20("MockToken", "MTK") {
        ERC20._mint(msg.sender, initialSupply);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

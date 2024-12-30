// contracts/Choice.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ChoiceCoiin is ERC20 {
    constructor(uint256 initialSupply) ERC20("Choice Coin", "Choice") {
        _mint(msg.sender, 1000000000000000000000000000);
    }
}
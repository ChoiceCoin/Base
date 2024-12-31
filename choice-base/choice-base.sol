// contracts/Choice.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ChoiceCoin is ERC20 {
    constructor() ERC20("Choice Coin", "Choice") {
        _mint(msg.sender, 1000000000000000000000000000);
    }
}

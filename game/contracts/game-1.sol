// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleAutoReturn {
    IERC20 public choiceCoin;
    uint256 public lastBalance;

    constructor(address _choiceCoinAddress) {
        choiceCoin = IERC20(_choiceCoinAddress);
        lastBalance = choiceCoin.balanceOf(address(this));
    }

    receive() external payable {
        // Check if the balance has changed since last check, indicating a token transfer
        uint256 currentBalance = choiceCoin.balanceOf(address(this));
        if (currentBalance > lastBalance) {
            // The difference must be at least 1 token (assuming 18 decimals)
            uint256 transferAmount = currentBalance - lastBalance;
            if (transferAmount >= 1 * 10**18) {
                choiceCoin.transfer(msg.sender, 2 * 10**18);
            }
            // Update lastBalance for next check
            lastBalance = currentBalance;
        }
    }
}
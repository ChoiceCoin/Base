
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract GameContract {
    IERC20 public myToken;

    constructor(address _myTokenAddress) {
        myToken = IERC20(_myTokenAddress);
    }

    receive() external payable {}

    function playGame() external {
        require(myToken.balanceOf(address(this)) >= 1 * 10**18, "Must transfer exactly 1 MyToken");
        require(myToken.transfer(msg.sender, 2 * 10**18), "Transfer failed");
    }
}

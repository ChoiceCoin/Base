// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleGame {
    IERC20 public choiceToken;
    mapping(address => uint) public ethBalances;

    constructor(address _choiceTokenAddress) {
        choiceToken = IERC20(_choiceTokenAddress);
    }

    // Payable function to accept ETH
    function fundWithETH() public payable {
        ethBalances[msg.sender] += msg.value;
    }

    function playGame() public {
        require(choiceToken.allowance(msg.sender, address(this)) >= 1e18, "Not enough allowance for 1 Choice token");
        require(choiceToken.transferFrom(msg.sender, address(this), 1e18), "Transfer failed");
        
    }

    // Function to return the Choice token address for setting up MetaMask
    function getChoiceTokenAddress() public view returns (address) {
        return address(choiceToken);
    }
    
}

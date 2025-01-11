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
        
        // Assuming you want to check if the sender has funded with ETH too
        require(ethBalances[msg.sender] > 0, "Must fund with ETH before playing");
        
        require(choiceToken.transfer(msg.sender, 2e18), "Return transfer failed");
        // Here you might want to clear or adjust the ETH balance if you're using it for something in the game
    }

    // Function to return the Choice token address for setting up MetaMask
    function getChoiceTokenAddress() public view returns (address) {
        return address(choiceToken);
    }
    
    // Optional: If you want to allow direct ETH sending without a function call
    receive() external payable {
        ethBalances[msg.sender] += msg.value;
    }
}
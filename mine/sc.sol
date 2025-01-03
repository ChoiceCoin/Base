// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IChoiceToken {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract ChoiceRandomizer {
    address public owner;
    IChoiceToken public choiceToken;

    event RandomNumberGenerated(address indexed user, uint256 randomNumber);
    event TokensTransferred(address indexed user, uint256 amount);

    constructor(address _choiceToken) {
        choiceToken = IChoiceToken(_choiceToken);
        owner = msg.sender;
    }

    /**
     * @notice Generates a pseudorandom number between 1 and 99.
     * @param user The address of the user for randomness input.
     */
    function generateRandomNumber(address user) internal view returns (uint256) {
        // Generate pseudorandom number using block timestamp and user address
        return (uint256(keccak256(abi.encodePacked(block.timestamp, user))) % 99) + 1;
    }

    /**
     * @notice Handles receiving exactly 44 CHOICE tokens, generates a pseudorandom number, 
     * and returns that amount of tokens to the sender.
     */
    function handleChoiceTransfer() external {
        // Verify the sender sent exactly 44 CHOICE tokens
        bool success = choiceToken.transferFrom(msg.sender, address(this), 44);
        require(success, "Transfer of 44 CHOICE tokens failed");

        // Generate a pseudorandom number between 1 and 99
        uint256 randomResult = generateRandomNumber(msg.sender);

        // Send the random number of CHOICE tokens back to the sender
        bool sent = choiceToken.transfer(msg.sender, randomResult);
        require(sent, "Token transfer back to user failed");

        emit RandomNumberGenerated(msg.sender, randomResult);
        emit TokensTransferred(msg.sender, randomResult);
    }

}

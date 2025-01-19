// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract ChoiceGame is VRFConsumerBase {
    IERC20 public choiceToken;
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomness;
    address public owner;

    event RequestedRandomness(bytes32 requestId);
    event ReceivedChoice(uint256 amount);
    event SentChoice(address recipient, uint256 amount);

    constructor(
        address _choiceToken,
        address _vrfCoordinator,
        address _linkToken,
        bytes32 _keyHash,
        uint256 _fee
    ) VRFConsumerBase(_vrfCoordinator, _linkToken) {
        choiceToken = IERC20(_choiceToken);
        keyHash = _keyHash;
        fee = _fee;
        owner = msg.sender;
    }

    function playGame(uint256 X) public payable {
        require(msg.value >= 0.001 ether, "Not enough ETH for gas");
        uint256 balance = choiceToken.balanceOf(msg.sender);
        require(balance >= X, "Not enough Choice tokens");
        bool success = choiceToken.transferFrom(msg.sender, address(this), X);
        require(success, "Transfer failed");
        emit ReceivedChoice(X);
        bytes32 requestId = requestRandomness(keyHash, fee);
        emit RequestedRandomness(requestId);
    }

    function fulfillRandomness(
        bytes32 requestId,
        uint256 randomNum
    ) internal override {
        randomness = randomNum;
        uint256 Y = (randomNum % 10) + 1; // Y between 1 and 10
        uint256 Z = Y * 1e18; // Assuming Choice has 18 decimals
        require(
            choiceToken.balanceOf(address(this)) >= Z,
            "Not enough tokens in contract"
        );
        bool success = choiceToken.transfer(msg.sender, Z);
        require(success, "Transfer failed");
        emit SentChoice(msg.sender, Z);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function addChoiceTokens(uint256 amount) public onlyOwner {
        bool success = choiceToken.transferFrom(
            msg.sender,
            address(this),
            amount
        );
        require(success, "Transfer failed");
    }

    function withdrawETH() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdrawChoiceTokens(uint256 amount) public onlyOwner {
        bool success = choiceToken.transfer(msg.sender, amount);
        require(success, "Transfer failed");
    }

    receive() external payable {}
}

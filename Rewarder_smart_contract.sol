// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**

 * Here is the contract that has been deployed with Remix Ide


 * @title Rewarder
 * @dev Central contract for rewarding users, tracking brand points,
 * and simulating swaps between points and USDF.
 */
contract Rewarder is Ownable {
    // Events
    event RewardSent(address indexed user, address indexed brandToken, uint256 amount);
    event Swapped(address indexed user, address fromToken, address toToken, uint256 amountIn, uint256 amountOut);
    event ConvertedToUSDF(address indexed user, address brandToken, uint256 points, uint256 usdfAmount);

    // Registry of supported brand tokens
    mapping(address => bool) public isSupportedToken;

    // Mapping of user => brandToken => balance (for internal tracking)
    mapping(address => mapping(address => uint256)) public userPoints;

    // Exchange rates (e.g., 1 point = 0.01 USDF)
    mapping(address => uint256) public exchangeRatesToUSDF; // in wei (1e18 = 1 USDF)

    constructor() Ownable(msg.sender) {}

    // ----------------------
    // ADMIN METHODS
    // ----------------------

    function registerBrandToken(address tokenAddress, uint256 rateToUSDF) external onlyOwner {
        require(tokenAddress != address(0), "Invalid token");
        isSupportedToken[tokenAddress] = true;
        exchangeRatesToUSDF[tokenAddress] = rateToUSDF;
    }

    // ----------------------
    // USER METHODS
    // ----------------------

    /**
     * @notice Rewards a user with brand points (called by backend/brand)
     * @param recipient User's wallet address
     * @param brandToken Address of the brand's ERC20 token
     * @param amount Amount of points to mint
     */
    function reward(address recipient, address brandToken, uint256 amount) external onlyOwner {
        require(isSupportedToken[brandToken], "Unsupported brand token");
        require(IERC20(brandToken).transferFrom(msg.sender, recipient, amount), "Transfer failed");

        userPoints[recipient][brandToken] += amount;

        emit RewardSent(recipient, brandToken, amount);
    }

    /**
     * @notice Simulates conversion of brand points to USDF
     * @param brandToken The brand's token address
     * @param amount The amount of points to convert
     */
    function convertToUSDF(address brandToken, uint256 amount) external {
        require(userPoints[msg.sender][brandToken] >= amount, "Insufficient points");
        require(exchangeRatesToUSDF[brandToken] > 0, "Rate not set");

        userPoints[msg.sender][brandToken] -= amount;

        uint256 usdfValue = (amount * exchangeRatesToUSDF[brandToken]) / 1e18;

        emit ConvertedToUSDF(msg.sender, brandToken, amount, usdfValue);
    }

    /**
     * @notice Simulates a swap from one brand's points to another
     * @param fromToken Token to swap from
     * @param toToken Token to swap to
     * @param amount Amount of points to swap
     */
    function swapPoints(address fromToken, address toToken, uint256 amount) external {
        require(isSupportedToken[fromToken] && isSupportedToken[toToken], "Unsupported token");
        require(userPoints[msg.sender][fromToken] >= amount, "Insufficient points");
        require(exchangeRatesToUSDF[fromToken] > 0 && exchangeRatesToUSDF[toToken] > 0, "Missing exchange rate");

        // Step 1: Convert to USDF (intermediate value)
        uint256 usdfValue = (amount * exchangeRatesToUSDF[fromToken]) / 1e18;

        // Step 2: Convert USDF to target token
        uint256 targetAmount = (usdfValue * 1e18) / exchangeRatesToUSDF[toToken];

        userPoints[msg.sender][fromToken] -= amount;
        userPoints[msg.sender][toToken] += targetAmount;

        emit Swapped(msg.sender, fromToken, toToken, amount, targetAmount);
    }

    /**
     * @notice Returns the point balance for a given user and brand token
     */
    function getPoints(address user, address brandToken) external view returns (uint256) {
        return userPoints[user][brandToken];
    }
}

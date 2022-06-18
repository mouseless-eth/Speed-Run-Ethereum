pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  /// @notice Price of token per eth
  uint256 public constant tokensPerEth = 100;

  /// @notice Emit whenever a purchase is made
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 theAmount);

  /// @notice Custom ERC20 token
  YourToken public yourToken;

  /// @notice Constructor
  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  /// @notice Allow users to buy tokens with ETH
  function buyTokens() payable external {
    require(msg.value > 0, "You must spend some ETH");
    yourToken.transfer(msg.sender, msg.value * tokensPerEth);
    emit BuyTokens(msg.sender, msg.value, msg.value * tokensPerEth);
  }

  /// @notice drain contract and send ETH to owner
  function withdraw() external onlyOwner {
    payable(owner()).transfer(address(this).balance);
  }

  /// @notice Allow users to sell token back to vendor
  /// @param theAmount Amount of tokens to sell
  function sellTokens(uint256 theAmount) external {
    require(theAmount > 0, "You must sell some tokens");
    yourToken.transferFrom(msg.sender, address(this), theAmount);
    payable(msg.sender).transfer(theAmount / tokensPerEth);
  }
}

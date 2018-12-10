pragma solidity ^0.4.24;

interface IToken {
  function totalSupply() external view returns (uint256);
  function balanceOf(address who) external view returns (uint256);
  function transfer(address to, uint256 value) external returns (bool);
  function mint(address to, uint256 value) external returns (bool);
}

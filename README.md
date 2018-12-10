# Smart Contract Documentation

## [Pool.sol:Pool](../contracts/IToken.sol)
`Solidity version 0.4.25+commit.59dbf8f1`


 ##### function fundingEnd `0x13e7323e` 
 constant view 


___
 ##### function minFunding `0x193a4249` 
 constant view 


___
 ##### function balances `0x27e235e3` 
 constant view 


 Type | Name |
--- | --- |
| address |  |
___
 ##### function unpause `0x3f4ba83a` 
  nonpayable 
called by the owner to unpause, returns to normal state

___
 ##### function investors `0x3feb5f2b` 
 constant view 


 Type | Name |
--- | --- |
| uint256 |  |
___
 ##### function refundFunds `0x49569b82` 
  nonpayable 


___
 ##### function maxFunding `0x596b975a` 
 constant view 


___
 ##### function paused `0x5c975abb` 
 constant view 


___
 ##### function tokensale `0x704248ec` 
 constant view 


___
 ##### function renounceOwnership `0x715018a6` 
  nonpayable 
Allows the current owner to relinquish control of the contract.

___
 ##### function pause `0x8456cb59` 
  nonpayable 
called by the owner to pause, triggers stopped state

___
 ##### function withdrawTokens `0x8d8f2adb` 
  nonpayable 


___
 ##### function owner `0x8da5cb5b` 
 constant view 


___
 ##### function isOwner `0x8f32d59b` 
 constant view 


___
 ##### function minTokens `0x9d4c5451` 
 constant view 


___
 ##### function fundingStart `0xbcde18f1` 
 constant view 


___
 ##### function conditionalTransitions `0xd525aa32` 
  nonpayable 
transitions the state machine into the state it should currently be inby taking into account the current conditions and how many further transitions can occur

___
 ##### function getCurrentStateId `0xde4138de` 
 constant view 


___
 ##### function depositFunds `0xe2c41dbc` 
  payable payable


___
 ##### function getInvestorsCount `0xed21187a` 
 constant view 


___
 ##### function transferOwnership `0xf2fde38b` 
  nonpayable 
Allows the current owner to transfer control of the contract to a newOwner.

 Type | Name |
--- | --- |
| address | newOwner |
___
 ##### function totalFundsCollected `0xf58a6d60` 
 constant view 


___
 ##### function token `0xfc0c546a` 
 constant view 


___
 ##### constructor  `` 
  nonpayable 


 Type | Name |
--- | --- |
| address | _token |
| address | _tokensale |
| uint256 | _fundingStart |
| uint256 | _fundingEnd |
| uint256 | _minFunding |
| uint256 | _maxFunding |
| uint256 | _minTokens |
___
 ##### fallback  `` 
  payable payable


___
 ##### event Deposit `0xe1fffcc4923d04b559f4d29a8bfc6cda04eb5b0d3c460751c2402c5c5cc9109c` 
   


 Type | Name |
--- | --- |
| address | who |
| uint256 | amount |
___
 ##### event Withdraw `0x884edad9ce6fa2440d8a54cc123490eb96d2768479d49ff9c7366125a9424364` 
   


 Type | Name |
--- | --- |
| address | who |
| uint256 | amount |
___
 ##### event Refund `0xbb28353e4598c3b9199101a66e0989549b659a59a54d2c27fbb183f1932c8e6d` 
   


 Type | Name |
--- | --- |
| address | who |
| uint256 | amount |
___
 ##### event Pause `0x6985a02210a168e66602d3235cb6db0e70f92b3ba4d376a33c0f3d9434bff625` 
   


___
 ##### event Unpause `0x7805862f689e2f13df9f062ff482ad3ad112aca9e0847911ed832e158c525b33` 
   


___
 ##### event OwnershipTransferred `0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0` 
   


 Type | Name |
--- | --- |
| address | previousOwner |
| address | newOwner |
___
 ##### event Transition `0xc9eebb3cf39ebcc16f7db0bac8f0e44d050159a092bc2d96fb613c7b142c1264` 
   


 Type | Name |
--- | --- |
| bytes32 | stateId |
| uint256 | blockNumber |
___


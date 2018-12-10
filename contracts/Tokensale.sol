pragma solidity ^0.4.24;

import "./IToken.sol";

contract Tokensale {
    IToken token;

    function setToken(address _token)
        public
    {
        token = IToken(_token);
    }

    function() payable {
        token.mint(msg.sender, msg.value);
    }
}

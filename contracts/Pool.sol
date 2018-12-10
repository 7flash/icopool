pragma solidity ^0.4.24;

import "./StateMachine.sol";
import "./Pausable.sol";
import "./IToken.sol";

contract Pool is StateMachine, Pausable {
    bytes32 constant FUNDING = "funding";
    bytes32 constant INVESTING = "investing";
    bytes32 constant WAITING = "waiting";
    bytes32 constant DISTRIBUTION = "distribution";
    bytes32[] states = [FUNDING, INVESTING, WAITING, DISTRIBUTION];

    address public token;
    address public tokensale;
    uint256 public fundingStart;
    uint256 public fundingEnd;
    uint256 public minFunding;
    uint256 public maxFunding;
    uint256 public minTokens;

    mapping (address => uint256) public balances;

    uint256 public totalFundsCollected = 0;

    address[] public investors;

    uint256 totalTokensReceived;

    function getInvestorsCount()
        public view returns (uint256)
    {
        return investors.length;
    }

    event Deposit(address who, uint256 amount);
    event Withdraw(address who, uint256 amount);
    event Refund(address who, uint256 amount);

    constructor(
        address _token,
        address _tokensale,
        uint256 _fundingStart,
        uint256 _fundingEnd,
        uint256 _minFunding,
        uint256 _maxFunding,
        uint256 _minTokens
    )
        public
    {
        token = _token;
        tokensale = _tokensale;
        fundingStart = _fundingStart;
        fundingEnd = _fundingEnd;
        minFunding = _minFunding;
        maxFunding = _maxFunding;
        minTokens = _minTokens;

        setupStates();
    }

    function() payable {
        depositFunds();
    }

    function depositFunds()
        public payable checkAllowed whenNotPaused
    {
        if (balances[msg.sender] == 0) {
            investors.push(msg.sender);
        }

        balances[msg.sender] += msg.value;
        totalFundsCollected += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    function withdrawTokens()
        public checkAllowed whenNotPaused
    {
        uint256 fundsBalance = balances[msg.sender];
        balances[msg.sender] = 0;

        uint256 tokensBalance = ((fundsBalance*10**18 / totalFundsCollected) * totalTokensReceived) / 10**18;

        IToken(token).transfer(msg.sender, tokensBalance);

        emit Withdraw(msg.sender, tokensBalance);
    }

    function refundFunds()
        public checkAllowed whenPaused
    {
        uint256 balance = balances[msg.sender];
        balances[msg.sender] = 0;

        msg.sender.transfer(balance);

        emit Refund(msg.sender, balance);
    }

    function rememberTotalTokensReceived()
        internal
    {
        totalTokensReceived = IToken(token).balanceOf(address(this));
    }

    function softcapReachedAfterEnd(bytes32)
        internal returns (bool)
    {
        return totalFundsCollected >= minFunding && now >= fundingEnd;
    }

    function hardcapReachedBeforeEnd(bytes32)
        internal returns (bool)
    {
        return totalFundsCollected >= maxFunding && now <= fundingEnd;
    }

    function fundsTransferredToTokensale(bytes32)
        internal returns (bool)
    {
        return totalFundsCollected > 0 && address(this).balance == 0;
    }

    function tokensReceived(bytes32)
        internal returns (bool)
    {
        return IToken(token).balanceOf(address(this)) >= minTokens;
    }

    function transferFundsToTokensale()
        internal
    {
        require(tokensale.call.value(totalFundsCollected)());
    }

    function setupStates() internal {
        setStates(states);

        allowFunction(FUNDING, 0);
        allowFunction(FUNDING, this.depositFunds.selector);
        allowFunction(DISTRIBUTION, this.withdrawTokens.selector);

        addCallback(INVESTING, transferFundsToTokensale);
        addCallback(DISTRIBUTION, rememberTotalTokensReceived);

        addStartCondition(INVESTING, softcapReachedAfterEnd);
        addStartCondition(INVESTING, hardcapReachedBeforeEnd);

        addStartCondition(WAITING, fundsTransferredToTokensale);

        addStartCondition(DISTRIBUTION, tokensReceived);
    }
}

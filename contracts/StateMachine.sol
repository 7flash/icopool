pragma solidity ^0.4.24;

contract StateMachine {

    struct State {
        bytes32 nextStateId;
        mapping(bytes4 => bool) allowedFunctions;
        function() internal[] transitionCallbacks;
        function(bytes32) internal returns(bool)[] startConditions;
    }

    mapping(bytes32 => State) states;

    // The current state id
    bytes32 private currentStateId;

    event Transition(bytes32 stateId, uint256 blockNumber);

    /* This modifier performs the conditional transitions and checks that the function
     * to be executed is allowed in the current State
     */
    modifier checkAllowed {
        conditionalTransitions();
        require(states[currentStateId].allowedFunctions[msg.sig]);
        _;
    }

    ///@dev transitions the state machine into the state it should currently be in
    ///@dev by taking into account the current conditions and how many further transitions can occur
    function conditionalTransitions() public {
        bool checkNextState;
        do {
            checkNextState = false;

            bytes32 next = states[currentStateId].nextStateId;
            // If one of the next state's conditions is met, go to this state and continue

            for (uint256 i = 0; i < states[next].startConditions.length; i++) {
                if (states[next].startConditions[i](next)) {
                    goToNextState();
                    checkNextState = true;
                    break;
                }
            }
        } while (checkNextState);
    }

    function getCurrentStateId() view public returns(bytes32) {
        return currentStateId;
    }

    /// @dev Setup the state machine with the given states.
    /// @param _stateIds Array of state ids.
    function setStates(bytes32[] _stateIds) internal {
        require(_stateIds.length > 0);
        require(currentStateId == 0);

        require(_stateIds[0] != 0);

        currentStateId = _stateIds[0];

        for (uint256 i = 1; i < _stateIds.length; i++) {
            require(_stateIds[i] != 0);

            states[_stateIds[i - 1]].nextStateId = _stateIds[i];

            // Check that the state appears only once in the array
            require(states[_stateIds[i]].nextStateId == 0);
        }
    }

    /// @dev Allow a function in the given state.
    /// @param _stateId The id of the state
    /// @param _functionSelector A function selector (bytes4[keccak256(functionSignature)])
    function allowFunction(bytes32 _stateId, bytes4 _functionSelector)
        internal
    {
        states[_stateId].allowedFunctions[_functionSelector] = true;
    }

    /// @dev Goes to the next state if possible (if the next state is valid)
    function goToNextState() internal {
        bytes32 next = states[currentStateId].nextStateId;
        require(next != 0);

        currentStateId = next;
        for (uint256 i = 0; i < states[next].transitionCallbacks.length; i++) {
            states[next].transitionCallbacks[i]();
        }

        emit Transition(next, block.number);
    }

    ///@dev Add a function returning a boolean as a start condition for a state.
    /// If any condition returns true, the StateMachine will transition to the next state.
    /// If s.startConditions is empty, the StateMachine will need to enter state s through invoking
    /// the goToNextState() function.
    /// A start condition should never throw. (Otherwise, the StateMachine may fail to enter into the
    /// correct state, and succeeding start conditions may return true.)
    /// A start condition should be gas-inexpensive since every one of them is invoked in the same call to
    /// transition the state.
    ///@param _stateId The ID of the state to add the condition for
    ///@param _condition Start condition function - returns true if a start condition (for a given state ID) is met
    function addStartCondition(
        bytes32 _stateId,
        function(bytes32) internal returns(bool) _condition
    )
        internal
    {
        states[_stateId].startConditions.push(_condition);
    }

    ///@dev Add a callback function for a state. All callbacks are invoked immediately after entering the state.
    /// Callback functions should never throw. (Otherwise, the StateMachine may fail to enter a state.)
    /// Callback functions should also be gas-inexpensive as all callbacks are invoked in the same call to enter the state.
    ///@param _stateId The ID of the state to add a callback function for
    ///@param _callback The callback function to add
    function addCallback(bytes32 _stateId, function() internal _callback)
        internal
    {
        states[_stateId].transitionCallbacks.push(_callback);
    }
}

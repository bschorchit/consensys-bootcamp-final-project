pragma solidity ^0.6.0;

/// @title Multi Signature Biodiversity Fund
/// @author Bárbara Schorchit
/// @notice Based on Consensys' Bootcamp Exerise MultiSigWallet. A MultiSigWallet to manage funds from sales of biodiversity products.

contract MultiSigBioFund {
//there's a lot to improve here, but I'll do it later.

    address[] public owners;
    uint public required;
    uint public transactionCount = 0;    

    mapping (address => bool) public isOwner;
    mapping (uint => Transaction) public transactions;
    mapping (uint => mapping (address => bool)) public confirmations;

    struct Transaction {
      bool executed;
      address payable destination;
      uint value;
      string data;
    }
    
    event Deposit(address indexed sender, uint value);
    event Submission(uint indexed transactionId);
    event Confirmation(address indexed sender, uint indexed transactionId);
    event Execution(uint indexed transactionId);
    event ExecutionFailure(uint indexed transactionId);

    /// @dev Fallback function allows to deposit ether.
    fallback() external payable {
        emit Deposit(msg.sender, msg.value);
    }
    
    modifier validRequirement(uint ownerCount, uint _required) {
        if (   _required > ownerCount || _required == 0 || ownerCount == 0)
            revert();
        _;
    }
    modifier onlyOwners() { require(isOwner[msg.sender]); _; }
    modifier notExecuted(uint transactionId) { require(transactions[transactionId].executed == false); _; }

    /// @dev Contract constructor sets initial owners and required number of confirmations.
    /// @param _owners List of initial owners.
    /// @param _required Number of required confirmations.
    constructor(address[] memory _owners, uint _required) public validRequirement(_owners.length, _required) {
        for (uint i=0; i<_owners.length; i++) {
            isOwner[_owners[i]] = true;
        }
        owners = _owners;
        required = _required;
    }

    /// @dev Allows an owner to submit and confirm a transaction.
    /// @param destination Transaction target address.
    /// @param value Transaction ether value.
    /// @param data Transaction data payload.
    /// @return transactionId Returns transaction ID.
    function submitTransaction(address payable destination, uint value, string memory data) public onlyOwners returns (uint transactionId)  {
        require(destination != address(0));
        transactionId = transactionCount;
        transactionCount += 1;
        _addTransaction(transactionId, destination, value, data);
        confirmTransaction(transactionId);
    }

    /// @dev Allows an owner to confirm a transaction.
    /// @param transactionId Transaction ID.
    function confirmTransaction(uint transactionId) public onlyOwners notExecuted(transactionId) {
        confirmations[transactionId][msg.sender] = true;
        emit Confirmation(msg.sender, transactionId);
    }

    /// @dev Allows an owner to revoke a confirmation for a transaction.
    /// @param transactionId Transaction ID.
    function revokeConfirmation(uint transactionId) public onlyOwners notExecuted(transactionId) {
        require(confirmations[transactionId][msg.sender] == true);  
        confirmations[transactionId][msg.sender] = false; 
    }

    /// @dev Allows anyone to execute a confirmed transaction.
    /// @param transactionId Transaction ID.
    function executeTransaction(uint transactionId) public notExecuted(transactionId) {
        require(isConfirmed(transactionId));
        Transaction storage t = transactions[transactionId]; 
        t.executed = true;
        t.destination.transfer(t.value);
        emit Execution(transactionId);
        }

    /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
    /// @param _transactionId Transaction Id
    /// @param _destination Transaction target address.
    /// @param _value Transaction ether value.
    /// @param _data Transaction data payload.
    function _addTransaction(uint _transactionId, address payable _destination, uint _value, string memory _data) internal {
        transactions[_transactionId] = Transaction(false, _destination, _value, _data);
        emit Submission(_transactionId);
    }
    
    /// @dev Returns the confirmation status of a transaction.
    /// @param transactionId Transaction ID.
    /// @return Confirmation status.
    function isConfirmed(uint transactionId) public view returns (bool) {
        uint count = 0;
        for (uint i=0; i<owners.length; i++) {
            if (confirmations[transactionId][owners[i]])
                count += 1;
            if (count == required)
                return true;
        }
    }

    /// @notice Returns the destination of a proposed transaction
    /// @param transactionId The Id of the transaction
    /// @return destination returns the destination address of the transaction
    function getTransactionDestination (uint transactionId) external view returns (address payable destination) {
    return transactions[transactionId].destination;
  }

    /// @notice Returns the value of a proposed transaction
    /// @param id The Id of the transaction
    /// @return _value returns the value of the transaction
    function getTransactionValue (uint id) external view returns (uint _value) {
    return transactions[id].value;
  }

    /// @notice Returns if a proposed transaction is executed
    /// @param id The Id of the transaction
    /// @return executed returns if transaction is executed
    function isTransactionExecuted (uint id) external view returns (bool executed) {
    return transactions[id].executed;
  }

    /// @notice Returns if msg.sender has confirmed a proposed transaction
    /// @param id The Id of the transaction
    /// @return returns if transaction is executed
    function hasUserConfirmed (uint id) external view returns (bool) {
    return confirmations[id][msg.sender];
  }
}
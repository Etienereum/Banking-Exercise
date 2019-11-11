pragma solidity ^0.5.0;

contract SimpleBank {

    // State variables
    /* Made 'owner' the person who owns the bank.*/
    address public owner;
    
    /* I want to protect my users balance from other contracts by using 'private'*/
    mapping (address => uint) private balances;
    
    /* I created a getter function by using public, this allow contracts to be able to see if a user is enrolled.*/
    mapping (address => bool) public enrolled;
    
    // Events - publicize actions to external listeners
    /* Added an argument for this event */
    event LogEnrolled(address accountAddress);

    /* Added 2 arguments for this event, an accountAddress and an amount */
    event LogDepositMade(address accountAddress, uint amount);

    /* Add 3 arguments for this event, an accountAddress, withdrawAmount and a newBalance */
    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);

    // Functions
    /* Use the appropriate global variable to get the sender of the transaction */
    constructor() public {
        /* Set the owner to the creator of this contract */
        owner == msg.sender;
    }

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function() external payable {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    // A SPECIAL KEYWORD prevents function from editing state variables;
    // allows function to run locally/off blockchain
    function getBalance() public view returns (uint) {
        /* Get the balance of the sender of this transaction */
        address costumer = msg.sender;
        return balances[costumer];

        // return msg.sender.balance;
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    // Emit the appropriate event
    function enroll() public returns (bool){
        address costumer = msg.sender;      // enroll costumer.
        enrolled[costumer] = true;
        
        emit LogEnrolled(costumer);
    }

    // / @notice Deposit ether into bank
    // / @return The balance of the user after the deposit is made
    // Add the appropriate keyword so that this function can receive ether
    // Use the appropriate global variables to get the transaction sender and value
    // Emit the appropriate event
    // Users should be enrolled before they can make deposits
    function deposit() public payable returns (uint) {       // passing the amount to be deposited to the contract
        /* Add the amount to the user's balance, call the event associated with a deposit,
          then return the balance of the user */
        uint amount = msg.value;
        address costumer = msg.sender;                // is it better to use  local variable or just use msg.sender?
        require(enrolled[costumer] == true);          // verifing if the user is enrolled before depositing money
        balances[costumer] += amount;
        emit LogDepositMade(costumer, amount);
        
        return balances[costumer];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    // Emit the appropriate event
    function withdraw(uint withdrawAmount) public payable returns (uint) {
        /* If the sender's balance is at least the amount they want to withdraw,
           Subtract the amount from the sender's balance, and try to send that amount of ether
           to the user attempting to withdraw.
           return the user's balance.*/
        
        
        address costumer = msg.sender;
        require (withdrawAmount <= balances[costumer]);
        balances[costumer] -= withdrawAmount;
        
        emit LogWithdrawal(costumer, withdrawAmount, balances[costumer]);
        
        return balances[costumer];
    }

}

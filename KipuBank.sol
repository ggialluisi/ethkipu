// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title KipuBank
 * @notice trabalho de conclusao de EDP BR - Modulo 2: Fundamentos de Solidity
 * @notice author Gustavo P Gialluisi
 */
contract KipuBank {

    ////////////
    ///Errors///
    ////////////
    error KipuBank_BadRequest_NotTheOwner(address _sender);
    error KipuBank_BadRequest_ContractIsInactive(address _sender);
    error KipuBank_BadRequest_ExceedsDepositLimit(address _sender, uint256 _deposit_value_tried, uint256 _blocked_value_to_be, uint256 _bank_cap);
    error KipuBank_BadRequest_ExceedsWithdrawLimit(address _sender, uint256 _withdraw_value_tried, uint256 _withdraw_limit);
    error KipuBank_BadRequest_NotEnoughtBalance(address _receiver, uint256 _withdraw_value_tried, uint256 _balance);
    error KipuBank_BadRequest_InvalidReceiverAddress(address _receiver, uint256 _withdraw_value_tried, uint256 _balance);
    error KipuBank_ServerError_ErrorOnCall(address _owner, bytes _error);

    /////////////////////
    ///State variables///
    /////////////////////
    // @devs all private
    address private immutable i_owner;
    uint256 private immutable i_balanceLimit;
    uint256 private constant WITHDRAW_LIMIT = 15 ether;
    mapping(address wallet => uint256 balance) private s_balance;
    bool private s_isActive;

    ////////////
    ///Events///
    ////////////
    event KipuBank_ActiveToggled(bool isActive);
    event KipuBank_DepositSucceeded(address sender, uint256 msg_value, uint256 balance);
    event KipuBank_WithdrawSucceeded(address to, uint256 value, uint256 balance);

    ///////////////
    ///Modifiers///
    ///////////////
    modifier activeCheck() {
        if(!s_isActive) revert KipuBank_BadRequest_ContractIsInactive(msg.sender);
        _;
    }

    ///////////////
    ///Functions///
    ///////////////

    /////////////////
    ///constructor///
    /////////////////
    /**
     * @dev sets _owner for the publisher, and publishes contract as active
     * @param _bankCap_inWei sets the maximum limit of global balance of the contract, in WEI
     */
    constructor(uint256 _bankCap_inWei) {
        i_owner = msg.sender;
        s_isActive = true;
        i_balanceLimit = _bankCap_inWei;
    }

    //////////////
    ///external///
    //////////////

    // @notice external functions follows CEI blocks mode for securtity purposes

    /**
     * @notice possibility to turn off the contract, if something goes wrong
     * @dev turns isActive to !isActive
     */
    function toggleActive_ownerOnly() external {
        /// 'C'
        // @notice: only the contract owner can do this
        if(i_owner != msg.sender) revert KipuBank_BadRequest_NotTheOwner(msg.sender);

        /// 'E'
        // @notice: toggles active on or off, and emit the event
        s_isActive = !s_isActive;
        emit KipuBank_ActiveToggled(s_isActive);

        /// 'I'
        // @notice: no internal call here
    }

    /**
     * @dev deposits value in WEI for the msg.sender 
     */
    function depositForSender() external payable activeCheck {
        /// 'C'
        // @notice: check deposit limit:
        // @dev: the contract balance was already affected when this method is called
        uint256 balance_after_deposit = address(this).balance; 
        if(balance_after_deposit > i_balanceLimit) revert KipuBank_BadRequest_ExceedsDepositLimit(msg.sender, msg.value, balance_after_deposit, i_balanceLimit);

        /// 'E'
        // @notice: sets new balance for the sender, and emit the Event
        s_balance[msg.sender] += msg.value;
        emit KipuBank_DepositSucceeded(msg.sender, msg.value, s_balance[msg.sender]);
    
        /// 'I'
        // @notice: payable function deals the transfer
        // @dev: it's done before running this method
    }

    /**
     * @dev withdraw for the conected address 
     * @dev withdraw will be made for the msg.sender address 
     * @param _amountInWei value in WEI to be withdrawn
     */
    function withdrawForSender(uint256 _amountInWei) external activeCheck{
        // @notice do the withdraw for the message sender address
        withdraw(msg.sender, _amountInWei);
    }

    /**
     * @dev Withdraw for informed address. Only the contract owner can do this.
     * @param _receiver address for the withdraw
     * @param _amountInWei value in WEI to be withdrawn
     */
    function withdrawForReceiver_ownerOnly(address _receiver, uint256 _amountInWei) external activeCheck{
        /// 'C'
        // @notice: only the contract owner can withdraw for other receivers:
        if(i_owner != msg.sender) revert KipuBank_BadRequest_NotTheOwner(msg.sender);

        // @notice do the withdraw
        withdraw(_receiver, _amountInWei);
    }

    /////////////
    ///private///
    /////////////
    /**
     * @dev Withdraw private method
     * @param _receiver address for the withdraw
     * @param _amount value in WEI to be withdrawn
     */
    function withdraw(address _receiver, uint256 _amount) private {
        /// 'C'
        // @notice: check for valid address:
        if(_receiver == address(0)) revert KipuBank_BadRequest_InvalidReceiverAddress(_receiver, _amount, s_balance[_receiver]);
        // @notice: check withdraw limit:
        if(_amount > WITHDRAW_LIMIT) revert KipuBank_BadRequest_ExceedsWithdrawLimit(_receiver, _amount, WITHDRAW_LIMIT);
        // @notice: check if _receiver has balance:
        if(_amount > s_balance[_receiver]) revert KipuBank_BadRequest_NotEnoughtBalance(_receiver, _amount, s_balance[_receiver]);

        /// 'E'
        // @notice: set the EFECTS: new balance for the owner, and emit the event
        s_balance[_receiver] -= _amount;
        emit KipuBank_WithdrawSucceeded(_receiver, _amount, s_balance[_receiver]);

        /// 'I'
        // @notice: do the transfer with the call method
        (bool success, bytes memory _error) = _receiver.call{value: _amount}("");
        if(!success) revert KipuBank_ServerError_ErrorOnCall(_receiver, _error);
    }

    /////////////////
    ///view & pure///
    /////////////////

    //////////////////
    ///open methods///
    //////////////////

    /**
     * @notice Is this contract active? 
     * @dev Returns state variable s_isActive
     */
    function isContractActive() external view returns(bool) {
        return s_isActive;
    }
 
    /**
     * @notice Returns the current available value to be deposited 
     */
    function currentDepositLimit() external view returns(uint256) {
        return i_balanceLimit - address(this).balance;
    }

    /**
     * @notice Returns the balance limit set on this contract 
     */
    function bankCap() external view returns(uint256) {
        return i_balanceLimit;
    }

    /**
     * @notice Returns the balance of the informed address 
     * @dev Returns the balance of the informed wallet 
     */
    function balance(address wallet) external view returns(uint256) {
        return s_balance[wallet];
    }

}
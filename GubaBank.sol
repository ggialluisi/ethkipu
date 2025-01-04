// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

////////////
///Errors///
////////////
error GubaBank_BadRequest_NotTheOwner(address _sender);
error GubaBank_BadRequest_ContractIsInactive(address _sender);
error GubaBank_BadRequest_NotEnoughtDepositLimit(address _sender, uint _deposit_value_tried);
error GubaBank_BadRequest_NotEnoughtBalance(address _owner, uint _withdraw_value_tried, uint _balance);

error GubaBank_ServerError_ErrorOnCall(address _owner, bytes _error);

contract GubaBank {

    ///////////////////////
    ///Type declarations///
    ///////////////////////

    /////////////////////
    ///State variables///
    /////////////////////
    address private immutable i_owner;
    bool private s_isActive;
    mapping(address => uint) public s_balance;
    uint public immutable i_balanceLimit;

    ////////////
    ///Events///
    ////////////
    event GubaBank_ActiveToggled(bool isActive);
    event GubaBank_DepositSucceded(address sender, uint value, uint balance);
    event GubaBank_WithdrawSucceded(address to, uint value, uint balance);
    event GubaBank_TransactionRolledBack(bytes _error);

    ///////////////
    ///Modifiers///
    ///////////////
    modifier onlyOwner() {
        if(i_owner != msg.sender) revert GubaBank_BadRequest_NotTheOwner(msg.sender);
        _;
    }

    modifier depositCheck() {
        if(!s_isActive) revert GubaBank_BadRequest_ContractIsInactive(msg.sender);
        if(msg.value + address(this).balance > i_balanceLimit) revert GubaBank_BadRequest_NotEnoughtDepositLimit(msg.sender, msg.value);
        _;
    }

    modifier activeCheck() {
        if(!s_isActive) revert GubaBank_BadRequest_ContractIsInactive(msg.sender);
        _;
    }

    ///////////////
    ///Functions///
    ///////////////

    /////////////////
    ///constructor///
    /////////////////
    constructor(uint _bankCap) {
        s_isActive = false;
        i_owner = msg.sender;
        i_balanceLimit = _bankCap;
    }

    ///////////////////////
    ///receive function ///     -> permite receber eth no seu contrato
    ///fallback function///     -> permite receber eth no seu contrato -> roda só 
    ///////////////////////

    //////////////
    ///external///
    //////////////
    function toggleActive() external onlyOwner {
        s_isActive = !s_isActive;
        emit GubaBank_ActiveToggled(s_isActive);
    }

    function depositForSender() external payable depositCheck {
        // 'C'
        // balance limit was checked on the modifier

        // 'E'
        // set the EFECTS, set new balance for the sender, and emit the Event
        s_balance[msg.sender] += msg.value;
        emit GubaBank_DepositSucceded(msg.sender, msg.value, s_balance[msg.sender]);
    
        // 'I'
        // payable function deals the transfer
    }

    function withdraw(address payable _owner, uint _value) external activeCheck{
        // 'C'
        // withdrawCheck verifies if contract is turned on,
        // need to check if _owner has balance:
        if(s_balance[_owner] < _value) revert GubaBank_BadRequest_NotEnoughtBalance(msg.sender, _value, s_balance[_owner]);

        // 'E'
        //set the EFECTS: new balance for the owner, and emit the event
        s_balance[_owner] -= _value;
        emit GubaBank_WithdrawSucceded(_owner, _value, s_balance[_owner]);

        // 'I'
        // do the transfer with the call method
        (bool success, bytes memory _error) = _owner.call{value: _value}("");
        if(!success) {
            doRollback(_owner, _value, _error);
            revert GubaBank_ServerError_ErrorOnCall(_owner, _error);
        }
    }

    ////////////
    ///public///
    ////////////

    //////////////
    ///internal///
    //////////////

    /////////////
    ///private///
    /////////////
    function doRollback(address _owner, uint _value, bytes memory _error) private {
        s_balance[_owner] += _value;       
        emit GubaBank_TransactionRolledBack(_error);
    }

    /////////////////
    ///view & pure///
    /////////////////
    function isContractActive() external view returns(bool) {
        return s_isActive;
    }
 
    function currentDepositLimit() external view returns(uint) {
        return i_balanceLimit - address(this).balance;
    }

    function totalBalance() external view returns(uint) {
        return address(this).balance;
    }

    function bankCap() external view returns(uint) {
        return i_balanceLimit;
    }
}
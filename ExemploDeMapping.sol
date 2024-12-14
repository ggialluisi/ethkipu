//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract ExemploDeMapping {
    mapping(address => uint) public s_balances;
    mapping(address => mapping(address => uint256 value)) public s_saldo;

    function updateBalance(uint _newBalance) public {
        s_balances[msg.sender] = _newBalance;
    }

    function getBalance(address _user) public view returns (uint) {
        return s_balances[_user];
    }
    
    function deleteMapping(address _user) public {
        delete s_balances[_user];
    }
}

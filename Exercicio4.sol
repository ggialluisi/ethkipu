// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

error Exercicio4_NotTheOwner();

/// @title Concepts: variable uint with public visibility
/// @author Gustavo Gialluisi
contract ChangeCounterConstructor {
    address public s_owner;
    string private storedInfo;
    uint public countChanges = 0;

    constructor(string memory _storedInfo){
        storedInfo = _storedInfo;
        s_owner = msg.sender;
    }

    /**
    * Store `myInfo`
    * Increase the counter which manage how many times storedInfo is updated
    * @dev stores the string in the state variable `storedInfo` and update the counter
    * @param myInfo the new string to store
    */
    function setInfo(string memory myInfo) external {
        if(msg.sender != s_owner) revert Exercicio4_NotTheOwner();
        
        storedInfo = myInfo;
        countChanges++;
    }

    /**
    * Return the stored string
    * @dev retrieves the string of the state variable `storedInfo`
    * @return the stored string
    */
    function getInfo() external view returns (string memory ) {
        return storedInfo;
    }
}
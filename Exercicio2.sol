// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
 
/// @title Concepts: variable uint with public visibility
/// @author Gustavo Gialluisi
contract ChangeCounter {
    string private storedInfo;
    uint public countChanges = 0;

    /**
    * Store `myInfo`
    * Increase the counter which manage how many times storedInfo is updated
    * @dev stores the string in the state variable `storedInfo` and update the counter
    * @param myInfo the new string to store
    */
    function setInfo(string memory myInfo) external {
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
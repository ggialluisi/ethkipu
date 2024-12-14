// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

error Exercicio6Guba_NotTheOwner(address caller, address owner);

/// @title Concepts: variable uint with public visibility
/// @author Gustavo Gialluisi
contract Exercicio6Guba {
    address public s_owner;
    string[] public storedInfo;
    uint public countChanges = 0;

    event Exercicio6Guba_InfoAdded(string newInfo);
    event Exercicio6Guba_InfoUpdated(uint256 index, string newInfo);

    constructor(){
        s_owner = msg.sender;
    }

    modifier onlyOwner() {
        if(s_owner != msg.sender) revert Exercicio6Guba_NotTheOwner(msg.sender, s_owner);
        _;
    }

    /**
    * Store `myInfo`
    * Increase the counter which manage how many times storedInfo is updated
    * @dev stores the string in the state variable `storedInfo` and update the counter
    * @param myInfo the new string to store
    */
    function addInfo(string memory myInfo) external onlyOwner{
        storedInfo.push(myInfo);
        countChanges++;
        emit Exercicio6Guba_InfoAdded(myInfo);
    }

    function updateInfo(uint256 index, string memory newInfo) external onlyOwner{
        storedInfo[index] = newInfo;
        countChanges++;
        emit Exercicio6Guba_InfoUpdated(index, newInfo);
    }

    /**
    * Return the stored string
    * @dev retrieves the string of the state variable `storedInfo`
    * @return the stored string
    */
    function getIndexInfo(uint256 index) external view returns (string memory) {
        return storedInfo[index];
    }

    function getLastInfo() external view returns (string memory) {
        return storedInfo[storedInfo.length - 1];
    }

    function getCompleteArray() external view returns (string[] memory) {
        return storedInfo;
    }

}
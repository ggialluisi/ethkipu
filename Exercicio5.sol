// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

error Exercicio5Guba_NotTheOwner(address caller, address owner);

/// @title Concepts: variable uint with public visibility
/// @author Gustavo Gialluisi
contract Exercicio5Guba {
    address public s_owner;
    string private storedInfo;
    uint public countChanges = 0;

    event Exercicio5Guba_InfoSet(string newInfo);

    constructor(string memory _storedInfo){
        storedInfo = _storedInfo;
        s_owner = msg.sender;
    }

    modifier onlyOwner() {
        if(s_owner != msg.sender) revert Exercicio5Guba_NotTheOwner(msg.sender, s_owner);
        _;
    }

    /**
    * Store `myInfo`
    * Increase the counter which manage how many times storedInfo is updated
    * @dev stores the string in the state variable `storedInfo` and update the counter
    * @param myInfo the new string to store
    */
    function setInfo(string memory myInfo) external onlyOwner{
        storedInfo = myInfo;
        countChanges++;

        emit Exercicio5Guba_InfoSet(myInfo);
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
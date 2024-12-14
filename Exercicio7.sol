// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

error Exercicio7Guba_NotTheOwner(address caller, address owner);
error Exercicio7Guba_Forbidden(address caller);

/// @title Concepts: variable uint with public visibility
/// @author Gustavo Gialluisi
contract Exercicio7Guba {
    address public s_owner;
    string[] public storedInfo;
    uint public countChanges = 0;

    mapping(address => bool) public s_whitelist;

    event Exercicio7Guba_InfoAdded(string newInfo);
    event Exercicio7Guba_InfoUpdated(uint256 index, string newInfo);
    event Exercicio7Guba_WhitelistAdded(address client, bool canDoIt);
    event Exercicio7Guba_WhitelistDeleted(address client);


    modifier onlyOwner() {
        if(s_owner != msg.sender) revert Exercicio7Guba_NotTheOwner(msg.sender, s_owner);
        _;
    }

    modifier onlyWhitelist() {
        if(!s_whitelist[msg.sender]) revert Exercicio7Guba_Forbidden(msg.sender);
        _;
    }

    constructor(){
        s_owner = msg.sender;
        // addWhitelistItem(s_owner, true);
        s_whitelist[s_owner] = true;
    }

    /**
    * Store `myInfo`
    * Increase the counter which manage how many times storedInfo is updated
    * @dev stores the string in the state variable `storedInfo` and update the counter
    * @param myInfo the new string to store
    */
    function addInfo(string memory myInfo) external onlyWhitelist{
        storedInfo.push(myInfo);
        countChanges++;
        emit Exercicio7Guba_InfoAdded(myInfo);
    }

    function updateInfo(uint256 index, string memory newInfo) external onlyWhitelist{
        storedInfo[index] = newInfo;
        countChanges++;
        emit Exercicio7Guba_InfoUpdated(index, newInfo);
    }

    function addWhitelistItem(address client, bool canDoIt) external onlyOwner{
        s_whitelist[client] = canDoIt;
    }

    function deleteWhitelistItem(address client) external onlyOwner{
        delete s_whitelist[client];
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
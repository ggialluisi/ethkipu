// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Exercicio1 {
    string private s_storedInfo;

    function setInfo(string calldata _info) external {
        s_storedInfo = _info;
    }

    function getInfo() external view returns(string memory _return) {
        _return = s_storedInfo;
    }
}
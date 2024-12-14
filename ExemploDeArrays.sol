// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract ExemploDeArrays{
    uint[5] public arrayEstatico;
    uint[] public arrayDinamico; //mais caro ... pode causar DDOS (deny of service...)

    event ExemploDeArrays_RemoventoIndice(uint256 ultimo);

    function addValue(uint256 _value) external {
        arrayDinamico.push(_value);
    }

    function removeValue() external {
        uint256 ultimo = arrayDinamico[arrayDinamico.length - 1];

        arrayDinamico.pop(); //remove o ultimo item

        emit ExemploDeArrays_RemoventoIndice(ultimo);
    }

}
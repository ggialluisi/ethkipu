/// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract ExemploDeStruct {

    struct Pessoa {
        string nome;
        uint idade;
        bool ativo;
    }
    // Instancia de un struct
    Pessoa public s_pessoa;
    Pessoa[] public s_pessoas;
    mapping(address wallet => Pessoa) public s_mappingPessoa;

    // Inicializar una instancia del struct
    function criarPessoa(string memory _nome, uint _idade) public {
        s_pessoa = Pessoa({
            nome: _nome,
            idade: _idade,
            ativo: true
        });
    }

    // Actualizar un campo específico del struct
    function atualizarIdade(uint _idade) public {
        s_pessoa.idade = _idade;
    }
}
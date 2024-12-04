// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/////////////
///Imports///
/////////////

////////////
///Errors///
////////////

///////////////////////////
///Interfaces, Libraries///
///////////////////////////

contract PrimeiroSC {


    ///////////////////////
    ///Type declarations///
    ///////////////////////

    /////////////////////
    ///State variables///
    /////////////////////
    /*
    default de tipos:

    int: 0

    boas praticas: iniciar variaves state com 's_'
    */
    uint256 internal s_uint; // uint >> só positivo
    int256 private s_int; // int >> só positivo
    address public s_contractOwner; // address => Endereço Ethereum (pode ser contrato, wallet) -- variavel publica >> aparece no explorer sem funcao de view -- isso não funciona pra array
    bytes32 s_exemploHash; // resultado de um hash
    bool s_bool; // bool normal...
    string s_str; // string e solidity nao se dao bem: gasta muito gas para ler e gravar
    bytes s_textoBytes; // maneira mais 'barata' de usar string, pode usar função de hash que pode voltar para o original    

    ////////////
    ///Events///
    ////////////

    ///////////////
    ///Modifiers///
    ///////////////

    ///////////////
    ///Functions///
    ///////////////

    /////////////////
    ///constructor///
    /////////////////
    constructor() {
        // função que roda só no deploy
        s_contractOwner = msg.sender; // msg.sender variavel global nativa do solidity (quem fez o deploy)
        // msg.value -> valor enviado
    }

    ///////////////////////
    ///receive function ///
    ///fallback function///
    ///////////////////////

    //////////////
    ///external///
    //////////////
    function externalFunction() external {
        // solo accesible desde fuera del contrato
        //external -> mais barata!!
    }
    function externalPayableFunction() external payable {
        // 'payable' permite que ETH seja enviado como VALUE ao executar o contrato.
        // valor passado é armazenado como balance
    }
    function withdraw(address payable _owner) external {
        (bool success, bytes memory _error) = _owner.call{value: address(this).balance}("");
        if(!success) revert("");

        /*
        funcoes nativas  padrão de transferencia de balance:

        send()
        transfer()
        call()    <-- sempre usa call! pra transferir tudo
        */
    }

    ////////////
    ///public///
    ////////////
    function publicFunction() public {
        // acessa de dentro e de fora
    }

    //////////////
    ///internal///
    //////////////
    function internalFunction() internal {
        // função acessada pelo proprio contrato, e por todos os que herdarem dele
    }

    /////////////
    ///private///
    /////////////
    function privateFunction() private {
        // função acessada só pelo proprio contrato
    }

    /////////////////
    ///view & pure///
    /////////////////
    function externalViewFunction() external view returns(uint256 _exemplo) {
        _exemplo = s_uint;
    }
 
    function externalViewFunctionDois() external view returns(uint256) {
        return s_uint;
    }

    function externalViewBalance() external view returns(uint256) {
        return address(this).balance;
    }

    function externalPureFunction(uint256 _um, uint256 _dois) external pure returns(uint256 _exemplo) {
        // função pure: não escreve e nem lê nenhuma variavel de estado, apenas lida com os parametros
        _exemplo = _um * _dois;
    }

}
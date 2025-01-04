// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/////////////
///Imports///
/////////////

////////////
///Errors///
////////////
error PrimeiroSC_NaoPermitido();  // o nome do erro é a mensagem que vai aparecer. Boa pratica: usar o nome do contrato no custom error ...

///////////////////////////
///Interfaces, Libraries///
///////////////////////////

contract PrimeiroSC {


    ///////////////////////
    ///Type declarations///
    ///////////////////////
    enum OrdemDeChamada{
        aluno_zero, // 0
        aluno_um,   // 1
        aluno_dois  // 2
    }
    function exemploEnum(OrdemDeChamada _ordem) external{
        status = _ordem;
    }

    /////////////////////
    ///State variables///
    /////////////////////
    /*
    default de tipos:

    int: 0

    boas praticas: iniciar variaves state com 's_'
    */
    OrdemDeChamada status;
    uint256 public s_uint; // uint >> só positivo
    int256 private s_int; // int >> só positivo
    address public s_contractOwner; // address => Endereço Ethereum (pode ser contrato, wallet) -- variavel publica >> aparece no explorer sem funcao de view -- isso não funciona pra array
    bytes32 s_exemploHash; // resultado de um hash
    bool s_bool; // bool normal...
    string s_str; // string e solidity nao se dao bem: gasta muito gas para ler e gravar
    bytes s_textoBytes; // maneira mais 'barata' de usar string, pode usar função de hash que pode voltar para o original    

    address public immutable i_owner; // precisa ser definida no constructor - não é armazenada no storage
    uint256 public constant ADM_ONE = 1; // precisa ser definida na declaração - não é armazenada no storage

    ////////////
    ///Events///
    ////////////

    ///////////////
    ///Modifiers///
    ///////////////

    ///////////////
    ///Functions///
    ///////////////
    function condicional(uint256 _numero) external pure returns (string memory){
        if(_numero == 77){
            return "Good Luck";
        } else if(_numero == 13){
            return "Bad Luck";
        }
        return "opa";
    }

    function loops(uint256 _numero) external returns (string memory){
        
        for(uint256 i; i <= _numero; ++i){  // no FOR, ++i é mais barato que i++ ou as outras formas...
            // evitar sempre usar for... pode explodir o limite de gas, e travar esse contrato...

            // s_uint++;
            // ++s_uint;
            // s_uint += 1;
            s_uint = s_uint + 1;  // essa é a forma mais barata de incrementar
        }
        return "vamoo";
    }

    function requireChecks(uint256 _value) external {
        require(_value < 100 ether, "msg de erro"); // 1 ether = 10^18 
    }

    function revertChecks(uint256 _value) external {
        if(_value >= 100 ether) revert PrimeiroSC_NaoPermitido(); // 1 ether = 10^18  -> revert
    }

    function whileBreak(uint256 _numero) external pure returns (string memory){
        uint256 i = 0;
        while(i <= _numero){
            if(i == 70){
                break;
            }
            // do processamento ...
            i = i + 1;  // essa é a forma mais barata de incrementar
        }
        return "vamoo";
    }

    /////////////////
    ///constructor///
    /////////////////
    constructor(address _owner) {
        // função que roda só no deploy
        s_contractOwner = msg.sender; // msg.sender variavel global nativa do solidity (quem fez o deploy)
        i_owner = _owner;
        // msg.value -> valor enviado
    }

    ///////////////////////
    ///receive function ///     -> permite receber eth no seu contrato
    ///fallback function///     -> permite receber eth no seu contrato -> roda só 
    ///////////////////////
    receive() external payable {

    }

    //////////////
    ///external///
    //////////////
    function externalFunction() external {
        // solo accesible desde fuera del contrato
        //external -> mais barata!!
    }
    function depositForSender() external payable {
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
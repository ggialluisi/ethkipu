// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

contract Modulo {
    ///ERROR
    error Modulo_CallerNotAllowed(address caller, address owner);
    error Modulo_AmountTooLow(uint256 amount, uint256 allowedAmount);
    error Modulo_NotEnoughBalance( uint256 amount, uint256 contractBalance);

    ///Custom Types
    struct Operadores{
        address operador;
        bool isAllowed;
    }

    Operadores op;

    ///@notice variaveis de estado
    uint256 s_inteiroPositivo;
    int256 s_inteiro;
    address s_user;
    bool s_NaoPermitido;
    string s_textoDinamico;
    bytes s_bytesDinamico;
    bytes32 s_bytesEstatico;

    ///@notice variavel imutavel
    address immutable i_owner;
    ///@notice variavel constante
    uint256 constant ONE_ETHER = 1*10**18;

    ///@notice storage
    address[] public s_depositantes;
    mapping(address carteira => uint256 saldo) public s_saldo;

    event Modulo_DepositoFeitoEUsuarioRegistrado(address depositante, uint256 valor);
    event Modulo_TextoDinamicoAtualizado(string message);
    event Modulo_UsuarioRemovido(address user);
    event Modulo_SaldoDoUsuarioDeletado(address user);

    constructor(){
        i_owner = msg.sender;
    }

    modifier onlyOwner(){
        if(msg.sender != i_owner) revert Modulo_CallerNotAllowed(msg.sender, i_owner);
        _;
    }

    modifier onlyOperators(){
        if(op.operador != msg.sender || op.isAllowed == false) revert Modulo_CallerNotAllowed(msg.sender, op.operador);
        _;
    }

    receive() external payable { 

    }
    fallback() external payable { 

    }

    function deposit() external payable {
        s_saldo[msg.sender] = msg.value;
        s_depositantes.push(msg.sender);

        emit Modulo_DepositoFeitoEUsuarioRegistrado(msg.sender, msg.value);
    }

    function withdraw(address _receiver, uint256 _amount) external onlyOperators{
        require(_receiver != address(0), "Endereco Invalido"); // CHECAR ISSO NO TCC !!!
        require(_amount >= ONE_ETHER, Modulo_AmountTooLow(_amount, ONE_ETHER));  // require é mais caro que if() ....
        if(_amount > address(this).balance) revert Modulo_NotEnoughBalance(_amount, address(this).balance);

        (bool success, ) = _receiver.call{value: _amount}("");
        if(!success) revert();
    }

    /**
        *@notice function to update the value of s_textoDinamico storage variable
        *@param _message the message that will be stored
        *@dev this function should be called by anyone
    */
    function setMessage(string memory _message) external {
        s_textoDinamico = _message;

        emit Modulo_TextoDinamicoAtualizado(_message);
    }

    function deleteArrayValue(address _user) external onlyOwner{
        uint256 tamanhoDoArray = s_depositantes.length;
        for(uint256 i; i < tamanhoDoArray; ++i){
            if(s_depositantes[i] == _user){
                s_depositantes[i] = s_depositantes[tamanhoDoArray - 1];
                s_depositantes.pop();

                emit Modulo_UsuarioRemovido(_user);
                return;
            }
        }
    }

    function deleteMapping(address _user) external onlyOwner{
        delete s_saldo[_user];

        emit Modulo_SaldoDoUsuarioDeletado(_user);
    }

    function resetStruct() external onlyOwner{
        delete op;
    }
}

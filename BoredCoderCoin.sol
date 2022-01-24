pragma solidity ^0.8.0;

contract BoredCoderCoin{

    string public name  ;
    string public symbol;
    uint256 public totalSupply;
    uint8 public decimals;

    //indexed keyword to filter in trnsaction log
    event Transfer(address indexed _from,address indexed _to,uint256 _amount);
    event Approval(address indexed _from,address indexed  _to,uint256 _amount);

    //data structure to keep track of which account got what balance
    mapping (address=>uint256) public balanceOf;

     //data structure to keep track of which account got issued how much coin
    mapping (address=>mapping (address=>uint256)) public allowance;

    constructor() public {
        name = "Bored Coder's Coin" ;
        symbol= "&";
        totalSupply = 10000;
        decimals = 18;
        balanceOf[msg.sender] = totalSupply;
    }

    modifier validBalance{
        require(balanceOf[msg.sender] >= 0 , "invalid amount");
        _;
    }

    function transfer(address _to, uint256 _amount) public validBalance returns(bool){

        balanceOf[msg.sender] -= _amount;
        balanceOf[_to] += _amount;
        emit Transfer(msg.sender,_to,_amount);
        return true;


    }

    function approve (address _to,uint256 _amount)public returns(bool){
        allowance[msg.sender][_to] = _amount;
        emit Approval(msg.sender,_to,_amount);
        return true;
    }

    modifier allowedBalance(uint256 _amount){
         require(_amount <= balanceOf[msg.sender], "invalid amount");
        _;

    }

    modifier allowedAllowance(uint256 _amount,address _to){
          require( _amount <= allowance[msg.sender][_to] , "invalid amount");
        _;


    }

    function transferFrom(address _from, address _to , uint256 _amount) public allowedBalance(uint256 _amount) allowedAllowance(uint256 _amount ,address _to) returns(bool){

        balanceOf[msg.sender] -= _amount;
        balanceOf[_to] += _amount;
        allowance[msg.sender][_to]  -= _amount;
        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    

}

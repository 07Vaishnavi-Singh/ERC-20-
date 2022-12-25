// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;


abstract contract ERC20 {  

function name() public view virtual returns( string memory );
function symbol() public view virtual returns( string memory );
function decimals() public view virtual returns (uint8);
function totalSupply() public view  virtual returns (uint256);

function balanceOf(address _owner) public view virtual  returns (uint256 balance);
function transfer(address _to, uint256 _value) public virtual  returns (bool success);
function transferFrom(address _from, address _to, uint256 _value) public virtual  returns (bool success);
function approve(address _spender, uint256 _value) public  virtual returns (bool success);
function allowance(address _owner, address _spender) public view virtual returns (uint256 remaining);
// refer to the events in solidity 
event Transfer(address indexed _from, address indexed _to, uint256 _value);
event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}


// new contract for ownership 
contract Ownership{

address public contractOwner ; // who deploys the contract 
address public newOwner; // who will claim new ownership 

event transferOwnership (address indexed _from , address indexed _to );

constructor(){
    contractOwner= msg.sender ;
}

function changeOwner(address _to) public{
require(msg.sender == contractOwner , "Only contract Onwer can change the new Owner ");
newOwner = _to;
}

function acceptOwnership() public {
    require(msg.sender == newOwner , "Only new Owner can accept the ownership ");
    emit transferOwnership (contractOwner , newOwner );
    contractOwner = newOwner ;
    newOwner = address(0);

} 

}
 contract myERC20Token0 is ERC20 , Ownership{

string public _name ;
string public _symbol;
uint8 public _decimals;
uint public _totalSupply;
address public _minter;

mapping ( address => uint256 ) public tokenBalances;
mapping (address => mapping(address => uint256)) public allowed ; 



constructor ( address minter_){
    _name = "ANJU";
    _symbol = "ANJ";
    _decimals = 10;
    _totalSupply= 100000;
    _minter = minter_;
    tokenBalances[_minter] = _totalSupply ;

}



function name() public view override returns(  string memory){
return _name;
}

function symbol() public view override returns (   string memory ){
    return _symbol;
}

function decimals() public view override returns (uint8){
    return _decimals;
}

function totalSupply() public view  override returns (uint256){
    return _totalSupply;
}

function balanceOf(address _owner) public view override  returns (uint256 balance){
    return tokenBalances[_owner];
}

function transfer(address _to, uint256 _value) public override  returns (bool success){
require( tokenBalances[msg.sender] >= _value, "Insufficient Balance " );
tokenBalances[msg.sender]-= _value;
tokenBalances[_to]+=_value ;
emit Transfer (msg.sender , _to , _value );
}


function transferFrom(address _from, address _to, uint256 _value) public override  returns (bool success){
 uint allowedBalance = allowed[_from][msg.sender];
 require(allowedBalance >= _value, "It is not allowed to send this much value " );
tokenBalances[_from]-=_value;
tokenBalances[_to]+=_value;

emit Transfer(_from , _to,_value);


}



function approve(address _spender, uint256 _value) public override returns (bool success){

require(tokenBalances[msg.sender] >= _value , "Insufficient Balance ");
allowed[msg.sender][_spender]= _value ;
emit Approval(msg.sender,_spender, _value);
return true;

}

function allowance(address _owner, address _spender) public view override returns (uint256 remaining){
    return allowed[_owner ][_spender];
}


}
pragma solidity >=0.4.21 <0.7.0;

import "./Ownable.sol";
import "./ERC20.sol";

//ERC20 token mintable by a specified authority to handle payment on the Community Platform
//Owner is the Token Manager, not the authority (authority is belongingAddress)!
contract CommunityToken is Ownable, ERC20 {
    
    //// VARIABLES //////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    string public symbol;

    string public  name;
    
    uint decimals;
    
    uint256 reasonForPayment;
    
    mapping (address => bool) blocked;
    mapping (address => address) blockedTo;
    
    
      event ReasonForPayment(
    address indexed from,
    address indexed to,
    uint256 value,
    uint256 ReasonForPayment,
    string name
  );
    
    
    address belongingAddress;

    //// FUNCTIONS //////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    constructor(uint _value, address pBelongingAddress, string memory pSymbol, string memory pName) public {

        symbol = pSymbol;

        name = pName;
        
        decimals = 18;
        
        belongingAddress = pBelongingAddress;
        
        _mint( belongingAddress, _value * 10**uint(decimals));
    }
    
    
    
    
    // To mint further tokens
    function mint(address _from, uint256 _value) public onlyBelongingAddress {
        
        _mint( _from, _value * 10**uint(decimals));
    }
    
    //anyone who ones a token from that address can demand conversion into fiat currency at all time
    function exchangeToFiat(uint256 value) public whenNotBlocked(msg.sender) returns (bool) {
    
        // require(to == belongingAddress); // user has to pay money back to authority 
         
             require(super.transfer(belongingAddress, value) == true);
             
                 emit ReasonForPayment(msg.sender, belongingAddress, value, reasonForPayment, name); //To verify off chain payment, authorities have to use the reasonForPayment and unique name of token on the off chain transaction receipt (e.g. Paypal transasction, credit card paymnet, bank transfer)
                 reasonForPayment++;
            
         
    }
    
    
     function transferFrom(address from, address to, uint256 value) public whenNotBlocked(to) returns (bool) {
        
        return super.transferFrom(from, to, value);
    }
    
        function transfer(address to, uint256 value) public whenNotBlocked(to) returns (bool) {
        return super.transfer(to, value);
    }
    
    
        function decreaseAllowance(address spender, uint256 substract) public whenNotBlocked(msg.sender) returns (bool) {
        return super.decreaseAllowance(spender, substract); //user can not decrease Allowance when currently doing a trip
    }
    
    
    //apporve during a trip is ok since user cannot transfer until current blocking is over 
    
    
    
    
    //Blocks user transactions to all other addresses except the recipient when user started a trip until trip end and payment succeeded
    function blockPayments(address _fromAddress, address _allowedCounterParty) public onlyOwner
    {
        blocked[_fromAddress] = true;
        blockedTo[_fromAddress] = _allowedCounterParty;
    }
    
    //TokenManager contract will be owner of this contract and ublocks users once payment was made successfully
    function unBlockPayments(address _fromAddress) public onlyOwner
    {
         blocked[_fromAddress] = false;
    }
    
    
         
     modifier onlyBelongingAddress()
    {
        require (belongingAddress == msg.sender);
        _;
    }
    
        //when a user is bloocked, he/she can only make payments to the specified to address
        modifier whenNotBlocked(address to)
    {
        require (blocked[msg.sender] == false || blockedTo[msg.sender] == to);
        _;
    }
  
   
    
    
    
}
    
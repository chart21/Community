pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;
import "./CommunityToken.sol";
import "./Ownable.sol";
//TokenManager Contract that handles the Multi-Token Payment system on the Community Platform
contract TokenManager is Ownable
{
 
     mapping(address => CommunityToken) authorityTokens; //all tokens on the platform get saved here
     uint numberOfTokens; //keeps track of the number of tokens, 0 is not used -> displays one more token then there actually is!
     mapping (uint256 => address) addressOfTokens; //address of each Tokenauthority
     mapping (address => uint256) indexOfTokens; //0 is not used to check addresses that dont have tokens
     
     mapping(string => bool) nameCheck; //names have to be unique to generate unique payment recipts
     
     mapping (address => debt) userDebt; //debt of users
     
     struct debt{
         uint256 amount;
         address to;
     }
     
    
      constructor() public
    {
        numberOfTokens = 1; //token at index 0 is not used -> displays one more token then there actually is!
    }
    
    
        //gets emmited if user had not enough balance during payment
      event userFailedPayment(
    address indexed from,
    address indexed to,
    uint256 leftOverValue
  );
  

  function hasDebt(address a) public view returns (uint256)
  {
      return userDebt[a].amount;
  }
  
  //requires allowance set to be true first but should be the case anyway after unsucsessful trip (maybe allowance could be too low now?) -> everyone can demand to payBackDebt, not only user him/herself
  function payBackDebt(address a) public returns (bool)
  {
     
   return handleLeftOverPayment(userDebt[a].amount, a, userDebt[a].to);   //if it fails stillt the maximum amount is transfered and the debt gets updated 
  }
    
    
    //creates a new CommunityToken
     function createNewToken(address a, string memory description) public onlyOwner
    {
    require(indexOfTokens[a] == 0); //you cant override a token to ensure balances are still recorded
    require(nameCheck[description] == false); //names have to be unique to generate unique payment recipts
      authorityTokens[a] = new CommunityToken(100,a, description,description); //creates a new ERC20 Token at the given address
      //emit successful event or return true
      addressOfTokens[numberOfTokens] = a;
      indexOfTokens[a] = numberOfTokens;
      numberOfTokens++;
      nameCheck[description] = true;
    }
    

    //user balance is the aggregated balance of all token he/she owns
    function getTotalBalanceOfUser(address userAddress) public view returns (uint256)
    {
        uint256 balance = 0;
        for(uint i = 1; i < numberOfTokens-1; i++)
        {
            address a = getAddressOfTokenByIndex(i);
            balance += authorityTokens[a].balanceOf(userAddress);
        }
        return balance;
    }
    
    
    //blocks payment of users to every address except the specified counterParty to ensure users pay a started trip
    function blockOtherPaymentsOfUser(address userAddress, address counterParty) public onlyOwner
    {
          for(uint i = 1; i < numberOfTokens-1; i++)
        {
            address a = getAddressOfTokenByIndex(i);
            authorityTokens[a].blockPayments(userAddress, counterParty);
        }
    }
    
    
    //after successful payment users can freely access their tokens again
        function unblockOtherPaymentsOfUser(address userAddress) public onlyOwner
    {
          for(uint i = 1; i < numberOfTokens-1; i++)
        {
            address a = getAddressOfTokenByIndex(i);
            authorityTokens[a].unBlockPayments(userAddress);
        }
    }
    
    //gets aggregated allowance for each token on the platform
    function getTotalAllowanceOfUser(address userAddress) public view returns (uint256)
    {
          uint256 allowance = 0;
        for(uint i = 1; i < numberOfTokens-1; i++)
        {
            address a = getAddressOfTokenByIndex(i);
            allowance += authorityTokens[a].allowance(userAddress, address(this));
        }
        return allowance;
    }
    
    
    /**
   modifier totalAllowanceFirst()
    {
        require (getTotalBalanceOfUser() == getTotalAllowanceOfUser());
        _;
    }
    */
    
    function getHasTotalAllowance(address userAddress) public view returns (bool)
    {
      return (getTotalBalanceOfUser(userAddress) == getTotalAllowanceOfUser(userAddress)) ;
    }
    
    
        function getNumberofTokens() public view returns (uint256)
    {
        return numberOfTokens -1;
    }
    
     function getAddressOfToken(address belongingAuthority) public view returns (address)
    {
        return address(authorityTokens[belongingAuthority]);
    }
    
    function getAddressOfTokenByIndex(uint index) public view returns(address)
    {
        return addressOfTokens[index];
    }
    
    //handles Payment with token priorization
    function handlePayment(uint256 numberOfBlocks, uint256 price, address _from, address _to) public onlyOwner returns (bool)
    {
        uint256 totalPrice = numberOfBlocks * price;
        if(indexOfTokens[_to] != 0) //check if to address has a token, if yes prefer that token always
        {
            
            if( authorityTokens[_to].balanceOf(_from) < totalPrice) //pay max possible amount of prefered token then pay leftover
            {
                totalPrice -= authorityTokens[_to].balanceOf(_from);
                authorityTokens[_to].transferFrom(_from,_to, authorityTokens[_to].balanceOf(_from)); //if balance of that token is not enough, still pay maximum possible amount with that token
                
                return handleLeftOverPayment(totalPrice, _from, _to);
                
            }
            else
            {
               
                return authorityTokens[_to].transferFrom(_from,_to,totalPrice); //safety check if enough, best case scenario, if user has enough tokens from authority address, he directly pays the price
            }
            
         
        }
        else //in case to address has no token
        {
             return handleLeftOverPayment(totalPrice, _from, _to);
        }
        
    }
    
    
    //handles payment after token priorization, in the future the for loop should not go through indexes but sort by highest market cap to prioritize that token
      function handleLeftOverPayment(uint256 totalPrice, address _from, address _to) internal returns(bool)
    {
        uint256 leftoverPrice = totalPrice;
         for(uint i = 1; i < numberOfTokens-1; i++) //start at 1 because index 0 can never be taken
        {
            address a = getAddressOfTokenByIndex(i);
            if( authorityTokens[a].balanceOf(_from) < leftoverPrice)
            {
                 leftoverPrice -= authorityTokens[a].balanceOf(_from);
                authorityTokens[a].transferFrom(_from,_to, authorityTokens[a].balanceOf(_from)); //if balance of that token is not enough, still pay maximum possible amount with that token
            }
            else
            {
                 userDebt[_from].amount = 0; //by getting here the payment should be successful and debt can be removed if it was present (if there was debt present there cannot be a started trip anyway)
                 return authorityTokens[a].transferFrom(_from,_to,leftoverPrice); //safety check if enough, best case scenario, if user has enough tokens from authority address, he directly pays the price
            }
            
          
        }
        if(leftoverPrice > 0)
        {
            emit userFailedPayment(_from, _to, leftoverPrice);
            userDebt[_from] = debt(leftoverPrice,_to); //users cannot have multiple debt because having debt blocks all payment resulting functions
             return false; //user failed to pay price with all of his tokens, might be good to block user and unblock him only by authority
        }
        else{
            return true; //should not happen at this point
        }
       
        
    }
    
    
    
    
    

}
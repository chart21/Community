import "./Ownable.sol";
import "./DebtToken.sol";
import "./CommunityToken2.sol";
pragma solidity >=0.4.22 <0.6.0;

contract BalanceManager is Ownable
{
    DebtToken debtToken;
    CommunityToken2 communityToken;
    
    address belongingAddress; 
    
    constructor(address pBelongingAddress) public
    {
        //communityToken = new CommunityToken2(pBelongingAddress);
        //debtToken = new DebtToken(pBelongingAddress);
        
    }
    
    
    
}
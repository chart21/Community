pragma solidity >=0.4.21 <0.7.0;

import "./Ownable.sol";
import "./IERC20.sol";
import "./SafeMath.sol";

//Owner is the Token Manager, not the authority!
contract CommunityToken2 is Ownable, IERC20 {
    using SafeMath for uint256;

  mapping (address => uint256) private _balances;
  
  address belongingAddress;

  mapping (address => mapping (address => uint256)) private _allowed;

  uint256 private _totalSupply;



constructor(address pBelongingAddress) public
{
    require(pBelongingAddress != address(0));
    belongingAddress = pBelongingAddress;
}
  /**
  * @dev Total number of debt shared by all parties (except belonging Authority)
  */
  function totalSupply() public view returns (uint256) {
    return _totalSupply-balanceOf(belongingAddress);
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param owner The address to query the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address owner) public view returns (uint256) {
    return _balances[owner];
  }
 

   /**
   * @dev Transfer tokens from one address to another -> managed by owner
   * @param from address The address which you want to send tokens from
   * @param to address The address which you want to transfer to
   * @param value uint256 the amount of tokens to be transferred
   */
  function transferFrom(
    address from,
    address to,
    uint256 value
  )
    public onlyOwner
    returns (bool)
  {
       
    require(value <= _balances[from]);
    require(to != address(0));

    _balances[from] = _balances[from].sub(value);
    _balances[to] = _balances[to].add(value);
    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
    emit Transfer(from, to, value);
    return true;
  }
  
   


 

  /**
   * @dev Internal function that mints an amount of the token and assigns it to
   * the belongingAddress. This encapsulates the modification of balances such that the
   * proper events are emitted.
   
   * @param amount The amount that will be created.
   */
  function mint(uint256 amount) public {
      require(msg.sender == owner() || msg.sender == belongingAddress);
   // require(account != 0);
    _totalSupply = _totalSupply.add(amount);
    _balances[belongingAddress] = _balances[belongingAddress].add(amount);
    emit Transfer(address(0), belongingAddress, amount);
  }

 
}
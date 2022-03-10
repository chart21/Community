pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;
contract Event
{
    mapping (string => bool) istaken;
    event Balance(
       int64 value
    );
    
    function changeBalanceE(int64 pBalance) public payable {
        
        emit Balance(pBalance);
    }
    
    function getDefAddress() public returns (address)
    {
        address def;
        return address(0);
    }
    
    function newName(string memory name) public returns (bool)
    {
        require(istaken[name] == false);
        istaken[name] = true;
       return true;
    }
    
    
    function getBlockTime() public view returns (uint)
    {
        return block.timestamp;
    }
    
    
}
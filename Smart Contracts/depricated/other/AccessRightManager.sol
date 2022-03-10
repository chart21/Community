pragma solidity >=0.4.22 <0.6.0;
contract AccessRightsManagement{

mapping (address => string) hasIdentity;
mapping (string => User) usermap;
identityRequests[] identityQueue;
//mapping (address => string) requestIdentity;
 
 struct identityRequests
 {
    address userAddress;
    string userString;
    string message;
 }
 
 struct User {
        bool[5] isAdmin;
        int8[4] hasAccessRight;
        bytes32 role;
        string description;
            }

    constructor() public
    {
        usermap["test"].role = "bla"; //Should define atleast 1 administrator
        
    }
    
    modifier onlyUser(string memory userkey) {
        
        require(keccak256(abi.encode(hasIdentity[msg.sender])) == keccak256(abi.encode(userkey)));
        _;
    }
    
    function welcome(string memory userkey) public view returns (bool recognised)  
    {
        if( usermap[userkey].role.length != 0)
            return true;
         else
         {
            return false;
         }
      }
      
      function proceedWelcome(string memory userkey, string memory notice) public returns (bool worked)  
      {
          if( usermap[userkey].role.length != 0)
          {
           identityRequests memory user;
            user.userAddress = msg.sender;
            user.userString = userkey;
            user.message = notice;
            identityQueue[identityQueue.length] = user;
            usermap[userkey].role = "requestingIdentity";
            return true;
          }
          return false;
      }
            
            
    function showAccessRights(string memory userkey) public view onlyUser(userkey) returns (int8[4] memory accessrights, bytes32 role)
    {
        return (usermap[userkey].hasAccessRight, usermap[userkey].role); 
    }
    
      function getAdminRights(string memory userkey) public view onlyUser(userkey) returns (bool[5] memory isAdmin)
    {
        return (usermap[userkey].isAdmin);
    }
    
    
    function newAccessRight(string memory userkey, uint256 accesstype) public onlyUser(userkey) returns(int8 accessstatus)
    {
        int8 accessstatusl = usermap[userkey].hasAccessRight[accesstype];
        if(accessstatusl == 0)
        usermap[userkey].hasAccessRight[accesstype] = 1; //0 means -1 and so on
        return accessstatusl;
    }
    
    function handleRequest(string memory adminkey, string memory userkey, uint256 accesstype, bool answer) public onlyUser(adminkey) returns(bool allowed)
    {
        if(usermap[adminkey].isAdmin[accesstype] == true)
        {
            if(usermap[userkey].hasAccessRight[accesstype] != 2)
            {
                if(answer)
                usermap[userkey].hasAccessRight[accesstype] = 2;
                else
                usermap[userkey].hasAccessRight[accesstype] = 0;
                return true;
            }
        }
        return false;
    }
    
    function getCreationRequest(string memory adminkey) public view onlyUser(adminkey) returns(string memory message)
    {
        if(usermap[adminkey].isAdmin[4])
            return identityQueue[0].message; //If not exists, string will be empty
        
     }
     
     function handleCreationRequest(string memory adminkey, bool answer, bytes32 role, string memory description, int8[4] memory initialAccessRights, bool[5] memory initialAdminRights) public onlyUser(adminkey)
     {
         require(usermap[adminkey].isAdmin[4]);
         if(answer)
             {
                hasIdentity[identityQueue[0].userAddress] = identityQueue[0].userString;
                usermap[identityQueue[0].userString].role = role;
                usermap[identityQueue[0].userString].description = description;
                usermap[identityQueue[0].userString].isAdmin = initialAdminRights;
                usermap[identityQueue[0].userString].hasAccessRight = initialAccessRights;
             }
            identityRequests memory noRequest;
            identityQueue[0] = noRequest;  
     }
     
    
}

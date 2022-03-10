pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;
contract AccessRightsManagement{

mapping (address => string) public hasIdentity;
mapping (string => User) usermap;
identityRequests[] public identityQueue;
//mapping (address => string) requestIdentity;
string[][4] public accessQueue;
mapping (uint8 => string[50]) accessmap;
uint8 counter;


//string[50] test;
 
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
        bool exists;
            }

    constructor() public
    {
        hasIdentity[msg.sender] = "test"; //Atleast 1 administrator should be defined in constructor
        usermap["test"].role = "admin"; 
        usermap["test"].description = "Global Administrator, keeps track of everything";
        usermap["test"].isAdmin[0] = true;
        usermap["test"].isAdmin[1] = true;
        usermap["test"].isAdmin[2] = true;
        usermap["test"].isAdmin[3] = true;
        usermap["test"].isAdmin[4] = true;
        usermap["test"].hasAccessRight[0] = 2;
        usermap["test"].hasAccessRight[1] = 2;
        usermap["test"].hasAccessRight[2] = 2;
        usermap["test"].hasAccessRight[3] = 2;
        usermap["test"].exists = true;
        }
    
    modifier onlyUser(string memory userkey) {
        
        require(keccak256(abi.encode(hasIdentity[msg.sender])) == keccak256(abi.encode(userkey)));
        _;
    }
    
    function welcome(string memory userkey) public view returns (bool recognised)  
    {
        if(usermap[userkey].exists)
        {
            return true;
            
        }
         else
         {
            return false;
         }
         
      }
      
      function proceedWelcome(string memory userkey, string memory notice) public returns (bool worked)  
      {
          if(!usermap[userkey].exists)
          {
          identityRequests memory user;
            user.userAddress = msg.sender;
            user.userString = userkey;
            user.message = notice;
          //  uint256 a = identityQueue.length;
           identityQueue.push(user);
         // identityQueue[identityQueue.length] = user;
            usermap[userkey].exists = true;
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
    
    
    function newAccessRight(string memory userkey, uint8 accesstype) public onlyUser(userkey) returns(int8 accessstatus)
    {
        /**
        int8 accessstatusl = usermap[userkey].hasAccessRight[accesstype];
        if(accessstatusl == 0)
        usermap[userkey].hasAccessRight[accesstype] = 1; //0 means -1 and so on
        return accessstatusl;
        */
        int8 accessstatusbefore = usermap[userkey].hasAccessRight[accesstype];
        if(accessstatusbefore == 0)
        {
        usermap[userkey].hasAccessRight[accesstype] = 1; //0 means -1 and so on
        //uint length = accessQueue[accesstype].length;
        //accessQueue[accesstype][length-1] = userkey; 
        //accessmap[accesstype] = string[] memory;
        //uint length = accessmap[accesstype].length-1;
        accessmap[0][counter] = userkey;
        counter++;
        //test[test.length] = userkey;
        }
        return accessstatusbefore;
    }
    
    function handleRequest(string memory adminkey, uint8 listcount, uint8 accesstype, bool answer) public onlyUser(adminkey) returns(bool allowed)
    {
        string memory userkey =  accessmap[accesstype][listcount];
        
        if(usermap[adminkey].isAdmin[accesstype] == true)
        {
            
            if(usermap[userkey].hasAccessRight[accesstype] != 2)
            {
               
                if(answer == true)
                usermap[userkey].hasAccessRight[accesstype] = 2;
                else
                usermap[userkey].hasAccessRight[accesstype] = 0;
                
                
                for(uint i = listcount+1; i<counter; i++)
            {
                accessmap[accesstype][i-1] = accessmap[accesstype][i];
            }
            
            //accessQueue[accesstype][listcount][accessQueue[accesstype][listcount].length-1] = noRequest;  
           delete accessmap[accesstype][counter-1];
           // accessmap[accesstype].length--;
           counter--;
         }
             
                return true;
                
            }
        return false;
    }
    
    function getCreationRequest(string memory adminkey) public view onlyUser(adminkey) returns(string memory message)
    {
        if(usermap[adminkey].isAdmin[4])
        {
            if(identityQueue.length > 0)
        return identityQueue[0].message; //If not exists, string will be empty
        else
        return "";
            }
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
            //identityRequests memory noRequest;
            for(uint i = 1; i<identityQueue.length; i++)
            {
                identityQueue[i-1] = identityQueue[i];
            }
            //identityQueue[identityQueue.length-1] = noRequest;  
            delete identityQueue[identityQueue.length-1];
            identityQueue.length--;
     }
     
       function stringToBytes32(string memory source) public pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
        assembly {
        result := mload(add(source, 32))
        }
    }
    
    function bytes32ToString(bytes32 x) public pure returns (string memory) {
    bytes memory bytesString = new bytes(32);
    uint charCount = 0;
    for (uint j = 0; j < 32; j++) {
        byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
        if (char != 0) {
            bytesString[charCount] = char;
            charCount++;
        }
    }
    bytes memory bytesStringTrimmed = new bytes(charCount);
    for (uint v = 0; v < charCount; v++) {
        bytesStringTrimmed[v] = bytesString[v];
    }
    return string(bytesStringTrimmed);
}
     
     
     // Test Methods
     function proceedWelcomeView() public view returns(string memory)
     {
      
         return identityQueue[0].userString; //Problem if empty
        
     }
       function getUser(string memory name) public view returns(User memory)
     {
      
         return usermap[name]; //Problem if empty
        
     }
          function getQueue() public view returns(identityRequests[] memory)
     {
      
         return identityQueue; //Problem if empty
        
     }
    
}

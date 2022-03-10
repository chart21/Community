pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

import "./CommunityToken.sol";
contract Community
{
    mapping (uint64 => offer[10000]) endTimeMap; //only Date, 0 means no endTime
   mapping (uint64 => uint256) public mapindex; //all indices of end time map, = length
    
     mapping (address => bool) verifiers; //have the right to verify users as car owners or verified drivers
     
     mapping(address => bool) authorities; //have the right to vote in and out authorities, have their own tokens
     
//     mapping(address => bool) firstTimeAdded; //checks if authority if added for the first time to not create multiple tokens for one address
     
     
   // mapping(address => CommunityToken) authorityTokens; -> too muc gas
     uint numberOfTokens; //keeps track of the number of tokens, 0 is not used
     CommunityToken[200] tokens;
     mapping (uint => address) addressOfTokens; //address of each Tokenauthority
     mapping (address => uint) indexOfTokens; //0 is not used to check addresses that dont have tokens
     
     
     
    
    
    //int64[] indices;
    
    mapping (address => user) public usermap; //can rent or subrent objects
    
    
    
    uint256 currentID; //used to generate Ids 
    
    
    
    
    //Voting and On-Chain Governance Section
    
  vote proposal; //Voting proposal, only one at one time
  address lastProposed; //Authorities can not propose more than one time in a row to prevent spamming
  uint256 authorityCounter; //How many autohrities are in the network?
  
  
   struct vote
    {
        address proposedAuthority;
        uint256 PositiveVotesReceived;
        uint256 NegativeVotesRecived;
        string description; //a description of the votedAddress
        mapping (address => bool) hasVoted; //has the authority at that address already voted?
        
    }
     
     modifier onlyAuthorities()
    {
        require (authorities[msg.sender] == true);
        _;
    }
  
   //Used for adding and dropping authorities
    function proposeAuthority(address proposedAddress, string memory description) public onlyAuthorities
    {
        address defAddress;
        if(proposal.proposedAuthority == defAddress && msg.sender != lastProposed) //only possible if last Vote is already over and Proposer is different from last time (prevents spamming)
        {
            vote memory temp;
            proposal = temp;
            proposal.proposedAuthority = proposedAddress;
            proposal.description = description;
            lastProposed = msg.sender;
        }
    }
    
    
    
    //Voting and Evaluation, at exactly 50% Voting is in Favor of authority 
      function voteAuthority(bool voteDecision) public onlyAuthorities
    {
        require(proposal.hasVoted[msg.sender] == false);
            if(voteDecision == true)
            {
                proposal.PositiveVotesReceived++;
           
            }
           else
            {
                proposal.NegativeVotesRecived++;
                }
                
                evaluateVotes();
        
    }
    
    
    //Evaluation, at exactly 50% Voting is in Favor of authority 
    function evaluateVotes() public
    {
         if(proposal.PositiveVotesReceived*2 >= authorityCounter) //Vote is over, authority gets added (or stays if it was already an autohrity)
            {
               if(authorities[proposal.proposedAuthority] == false)
                         {
                             authorities[proposal.proposedAuthority] = true;
                             authorityCounter++;
                             
                       //      authorityTokens[proposal.proposedAuthority] = new CommunityToken(100, proposal.proposedAuthority, proposal.description, proposal.description); //generates new CommunityToken for that authority
                       //  tokens[numberOfTokens] = new CommunityToken(100, proposal.proposedAuthority, proposal.description, proposal.description); //generates new CommunityToken for that authority
                         }
               vote memory newvote;
               proposal = newvote;
            }
            
            
             if(proposal.NegativeVotesRecived*2 > authorityCounter) //Vote is over, authority gets removed (or cant join if it wasnt already an autohrity)
                 {
                         if(authorities[proposal.proposedAuthority] == true)
                         {
                             authorities[proposal.proposedAuthority] = false;
                             authorityCounter--;
                             //*********Needs to pay back all leftover tokens*************
                         }
                vote memory newvote;
               proposal = newvote;
                 }
    }
    
    
    function createNewToken(uint index) public
    {
        tokens[index] = new CommunityToken(100, proposal.proposedAuthority, proposal.description, proposal.description); //generates new CommunityToken for that authority
    }
    
    
    
    //Every authority has the right to step back, as total number of authories changes, current vote has to be reavluated
    function removeSelfFromAuthority() public onlyAuthorities
    {
         authorities[msg.sender] = false;
        authorityCounter--;
        evaluateVotes();
    }
    
    
    
    
   
   //Verifier Section
 
   modifier onlyVerifiers()
    {
        require (verifiers[msg.sender] == true);
        _;
    }
 
 //authorities can declare new verifiers (can be used on self)
 function newVerifier(address nVerifier) public onlyAuthorities()
 {
     verifiers[nVerifier] = true;
 }
 
 
  //authorities can declare new verifiers (can be used on self)
  function removeVerifier(address nVerifier) public onlyAuthorities()
 {
     verifiers[nVerifier] = false;
 }
 
 
 //Verifiers can verify owners
 function verifiyCarOwner(address userAddress) public onlyVerifiers()
 {
     usermap[userAddress].verifiedCarOwner = true;
 }
 
 
  //Verifiers can verify Renters
 function verifyDriver(address userAddress, uint8 objectType) public onlyVerifiers()
 {
     usermap[userAddress].verifiedDriver[objectType] = true;
 }
 
 
   modifier onlyVerifiedDriver(uint8 objectType) {
        require (usermap[msg.sender].verifiedDriver[objectType] == true);
        _;
    }
    
    modifier onlyVerifiedCarOwner() {
        require (usermap[msg.sender].verifiedCarOwner == true);
        _;
    }
    
  
  
  
  
  
  
    struct offer //offer cant be reserved while its started
 {
    address carOwnerAddress; 
    uint64 startTime;
    uint64 endDate; //repeat to let the client know
    uint32 endTime; //hours - was added by 1000 to ensure 0000 is not possible
    uint64 latpickupLocation;
    uint64 longpickupLocation;
    
    
    
    uint64[10] latPolygons;
    uint64[10] longPolygons;
    
   // uint32 dropoffRange; //DropoffRange, depricated
   //uint64 latdropofflocation; //center of polygons, depricated
    //uint64 longdropOffLocation; //center of polygons, depricated
    
    
    
    address reservedAdress; //Address of the reserved Trip, if address == owner means that trip got deleted
    bool reserved; //Is a trip reserved?
    uint256 reservedBlockNumber; //BlockNumber when a trip got reserved
    uint256 maxReservedAmount; //max amount of reservation time allowed in blocknumbers
    
    
    
    uint256 started; //Block number of start time, 0 by default -> acts as a bool check
    uint256 userDemandsEnd; //Block number of end demand
  
  
    
    
    
    uint256 index; //index in the mapping
    uint256 id; //Uid of the trip
    uint256 price; //price in tokens per block (5 secs)
    
    
    uint8 objectType; //car, charging station, ...
    
    
    string model; //further information like BMW i3, Emmy Vesper, can be also used to present a more accurat pciture to the user in the app
    
   
    
    
 }
 
 struct user
 {
      uint balance; //needs to be changed to tokens
      
      bool reserved; //did the user reserve a trip?
      
      
      bool started; //did the user start a trip?
      
      
      bool[5] verifiedDriver; //is the user allowed to drive this kind of object?
      bool verifiedCarOwner; //is the user subrent his/her own a car?
      
      
      uint8 rating; //Review Rating for that user from 1-5 on Client side
      uint256 ratingCount; //how often has this user been rated? Used to calculate rating
      
      
      mapping(address => bool) hasRatingRight; //checks if user has the right to give a 1-5 star rating for a trip (1 right for each ended trip)
      
   
      
      
      
 }
 
 
 
 
 

 
 //Initializes first authority when contract is created
 constructor(string memory description) public {
        authorities[msg.sender] = true;
        verifiers[msg.sender] = true;
      //  authorityTokens[msg.sender] = new CommunityToken(100, msg.sender, description, description); //generates new CommunityToken for that authority
        
    }
    
    
 
 
 
 
 //ReservationSection
 
     //Checks if object can be reservated by anyone right now, true is it can get reservated
    function getIsReservable(uint64 endTime, uint256 index) public view returns (bool)
    {
        if(endTimeMap[endTime][index].reserved == false)
        return true;
        if(block.number - endTimeMap[endTime][index].reservedBlockNumber > endTimeMap[endTime][index].maxReservedAmount)
        return true;
        
        
        return false;
        
    }
 
 
 
  
  
  //Object needs to be freem user needs to be verifired and cant have other reservations
   function reserveTrip(uint64 endTime, uint256 index) public onlyVerifiedDriver( endTimeMap[endTime][index].objectType)
    {
       
        require(usermap[msg.sender].reserved  == false);
         //***************else: emit already reserved Trip event***************
        
        
        
        require(getIsReservable(endTime, index) == true);
         //***************else: emit already reserved by somone else event ***************
        
        
        require(usermap[msg.sender].balance > 1000); //require minimum balance *************change ERC20*****************
          
          
          
            usermap[msg.sender].reserved = true;
          
             
            
            
            endTimeMap[endTime][index].reserved = true;
            endTimeMap[endTime][index].reservedAdress = msg.sender;
            endTimeMap[endTime][index].reservedBlockNumber = block.number;
          //***************emit Reservation successful event***************
    }
    
    
    
    
    
    //canceling trip is only possible if user reserved the trip but did not start it yet
    function cancelReserve(uint64 endTime, uint256 index) public
    {
        if(endTimeMap[endTime][index].reservedAdress == msg.sender && endTimeMap[endTime][index].started == 0)
        {
            endTimeMap[endTime][index].reserved = false;
            usermap[msg.sender].reserved = false;
             //***************emit Reservation cancel successful event***************
        }
        
        
         //***************emit Reservation cancel not successful event***************
    }
    
    
    
    
    










//start and end Trip section    








    
    
    function startTrip(uint64 endTime, uint256 index) public
    {
        require(endTimeMap[endTime][index].reservedAdress == msg.sender && endTimeMap[endTime][index].started == 0);
        require(usermap[msg.sender].started == false); //user can only have 1 started trip
             require(usermap[msg.sender].balance > 1000); //require minimum balance *************change ERC20*****************
        
        //emit tripStart(tripAddress, tripKey, msg.sender, block.number);
            endTimeMap[endTime][index].started = block.number;
            usermap[msg.sender].started = true;
            
        
    }
    
    
    
    
    
    //only callable by Renter
    function demandEndTrip(uint64 endTime, uint256 index) public
    {
         require(endTimeMap[endTime][index].reservedAdress == msg.sender && endTimeMap[endTime][index].started != 0);
         require(usermap[msg.sender].started == true); //safety check, shouldnt be neccessarry to check
        require(endTimeMap[endTime][index].userDemandsEnd == 0);
         endTimeMap[endTime][index].userDemandsEnd = block.number;
    }
    
    //only callable by Renter
      function userForcesEndTrip(uint64 endTime, uint256 index) public
    {
         require(endTimeMap[endTime][index].reservedAdress == msg.sender && endTimeMap[endTime][index].started != 0);
         require(usermap[msg.sender].started == true); //safety check, shouldnt be neccessarry to check
           require(block.number > endTimeMap[endTime][index].userDemandsEnd+3); //authorit has 3 blocks time to answer to endDemand request
         
         
         contractEndsTrip(endTime, index);
         
         
         
    }
    
    
   
    
    
    
    //only callable by carOwner if user wants to end the trip
    function confirmEndTrip(uint64 endTime, uint256 index) public
    {
         require(endTimeMap[endTime][index].carOwnerAddress == msg.sender && endTimeMap[endTime][index].started != 0);
           require(endTimeMap[endTime][index].userDemandsEnd != 0);
         contractEndsTrip(endTime, index);
        
    }
    
    
     //On long rentals car owner can call this function to ensure sufficient balance from the user
    function doubtBalanceEnd(uint64 endTime, uint256 index) public
    {  
        require(endTimeMap[endTime][index].carOwnerAddress == msg.sender && endTimeMap[endTime][index].started != 0);
        //**************ERC20*********** if balance is not sufficient, renter can end contract
        
        
        
        contractEndsTrip(endTime, index);
        
        
        //Alternative: automatically end trips after certain amount and require user to rebook trips
        
    }
    
    
    
    
    
    function contractEndsTrip (uint64 endTime, uint256 index) private
    {
        
        //*****************************ERC20Payment, out of money(?)**************************************
             usermap[msg.sender].started = false;  
             usermap[msg.sender].hasRatingRight[endTimeMap[endTime][index].carOwnerAddress] = true;
            address def;
            endTimeMap[endTime][index].reservedAdress = def;
            endTimeMap[endTime][index].reserved = false;
            endTimeMap[endTime][index].started = 0;
            endTimeMap[endTime][index].userDemandsEnd = 0;
            
    }
    
    
    
    //User has a rating right for each ended trip
    function rateTrip(address ownerAddress, uint8 rating) public
    {
        require(usermap[msg.sender].hasRatingRight[ownerAddress] == true);
        require(rating > 0);
        require(rating < 6);
        usermap[ownerAddress].rating += rating;
        usermap[ownerAddress].ratingCount++;
        usermap[msg.sender].hasRatingRight[ownerAddress] = false;
        
        
    }
    
    
    
    
    
    
    
    
    
    
    /** old methods
    
    
     //Every block customer loses 100*price of device balance, cancel reservse and start trips
     //rentalAuthority has to accept the endTrip (valid location, Engine turned off)
    function endTrip(uint64 endTime, uint256 index) public
    {
        require(endTimeMap[endTime][index].reservedAdress == msg.sender && endTimeMap[endTime][index].started != 0);
         require(usermap[msg.sender].started == true); //safety check, shouldnt be neccessarry to check
        
        
            //emit tripStart(tripAddress, tripKey, msg.sender, block.number);
            
            
            
           usermap[msg.sender].balance -= (block.number - endTimeMap[endTime][index].started)*100*endTimeMap[endTime][index].price; //********************Replace with ERC20******************
            usermap[msg.sender].balance += (block.number - endTimeMap[endTime][index].started)*100*endTimeMap[endTime][index].price; //********************Replace with ERC20******************
            
            
            usermap[msg.sender].started = false;  
            address def;
            endTimeMap[endTime][index].reservedAdress = def;
            endTimeMap[endTime][index].reserved = false;
            endTimeMap[endTime][index].started = 0;
           
            
            }
            
    
    
    */
    
    
    

    
    
    
    
    
    //Offer trip section
    
    
    
 
    
    
    //endTime needs to be added by 1000 to make 0000 not possible
    function offerTrip(uint64 startTime, uint32 endTime, uint64 endDate, uint64 latpickupLocation, uint64 longpickupLocation, uint256 price,  uint64[10] memory latPolygons,  uint64[10] memory longPolygons,  uint256 maxReservedAmount, uint8 objectType, string memory model  ) public onlyVerifiedCarOwner()
    {
        offer memory tempOffer;
        tempOffer.startTime = startTime;
        tempOffer.endTime = endTime;
        tempOffer.endDate = endDate;
        tempOffer.latpickupLocation = latpickupLocation;
        tempOffer.longpickupLocation = longpickupLocation;
     
        
        
        tempOffer.carOwnerAddress = msg.sender;
     
       // tempOffer.id = id; //maybe id should be set for the user to avoid collisions
       tempOffer.id = currentID; //setting id for the user
       currentID++;
       
       
       
        tempOffer.price = price;
        
         tempOffer.latPolygons = latPolygons;
         tempOffer.longPolygons = longPolygons;
         tempOffer.maxReservedAmount = maxReservedAmount;
         tempOffer.objectType = objectType;
         
         tempOffer.model = model;
        
        
       endTimeMap[endDate][mapindex[endDate]] = tempOffer;
       mapindex[endDate]++;
       
       
       
       
       
       
       
       
       
       
         // tempOffer.latdropofflocation = latdropofflocation;
        //tempOffer.longdropOffLocation = longdropOffLocation;
           //tempOffer.dropoffRange = dropoffRange;
       
    
    }
    
    
    
    
    
    //Change Trip details Section
        
    function updateCarLocation(uint64 endTime, uint256 index, uint64 newlat, uint64 newlong) public onlyVerifiedCarOwner
    {
        require(endTimeMap[endTime][index].carOwnerAddress == msg.sender);
        require(endTimeMap[endTime][index].reserved == false);
        endTimeMap[endTime][index].longpickupLocation = newlong;
        endTimeMap[endTime][index].latpickupLocation = newlat;
        
    }
    
    
   
        
    function updateCarPrice(uint64 endTime, uint256 index, uint256 price) public onlyVerifiedCarOwner
    {
        require(endTimeMap[endTime][index].carOwnerAddress == msg.sender);
        require(endTimeMap[endTime][index].reserved == false);
        endTimeMap[endTime][index].price = price;
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    function testVerifyme() public
    {
        usermap[msg.sender].verifiedDriver[0] = true;
        usermap[msg.sender].verifiedDriver[1] = true;
        usermap[msg.sender].verifiedDriver[2] = true;
        usermap[msg.sender].verifiedDriver[3] = true;
        usermap[msg.sender].verifiedDriver[4] = true;
         usermap[msg.sender].verifiedCarOwner = true;
         usermap[msg.sender].balance += 2000000;
    }
    
    
    
    
    /** Delete worked in test maybe not longer needed
    
    //basically deleting a trip
    function reserveTripExternal(uint64 endTime, uint256 index) public
    {
        require(endTimeMap[endTime][index].reserved == false);
        require(endTimeMap[endTime][index].carOwnerAddress == msg.sender);
        endTimeMap[endTime][index].reserved = true;
        endTimeMap[endTime][index].reservedAdress = msg.sender;
            
        
    }
    
    //car Owner can only unreserve trip if it was booked externally and if its actually his car  
     function unreserveTripExternal(uint64 endTime, uint256 index) public
    {
        require(endTimeMap[endTime][index].carOwnerAddress == msg.sender && endTimeMap[endTime][index].reservedAdress ==msg.sender);
        address def;
       endTimeMap[endTime][index].reservedAdress = def;
        endTimeMap[endTime][index].reserved = false;
        
        
    }
    
    
    */
    
    //needs to be tested -> worked in test
    function deleteTrip(uint64 endTime, uint256 index) public
    {
        require(endTimeMap[endTime][index].reserved == false);
        require(endTimeMap[endTime][index].carOwnerAddress == msg.sender);
        
         endTimeMap[endTime][index] = endTimeMap[endTime][mapindex[endTime]-1];
         delete endTimeMap[endTime][mapindex[endTime]-1];
         mapindex[endTime]--; 
         
        
        
     //   endTimeMap[endTime][index] = endTimeMap[endTime][endTimeMap[endTime].length -1]; //copy last element to the position which should be deleted //only works with dynamic arrays
     //   delete endTimeMap[endTime][endTimeMap[endTime].length -1]; //delete last element
     
    }
    
    
    
    

    
    
    
    
    
    
    
    
    
    //Get Trip Information Section
    
    
    
    function getTrip(uint64 endDate, uint256 index) public view returns(offer memory)  //offer[] memory
    {
        
        
        return endTimeMap[endDate][index]; //maybe mapindex has to be set to allow client to refind the trip -> probably better to set this client side when looping
    }
    
   
   
       function getIndex(uint64 endTime) public view returns (uint256) //returns length of that array
    {
        return mapindex[endTime];
    }
    
   



    //index +1 to make 0 distinguishable -no item found
    function getTripID(uint64 endTime, uint32 id, uint256 startindex) public view returns(uint256 index)
    {
        for(uint256 i = startindex; i<= mapindex[endTime]; i++)
        {
            if(endTimeMap[endTime][i].carOwnerAddress == msg.sender && endTimeMap[endTime][i].id == id)
            {
                return i+1;
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    /**
     
function testGetTokenBalance(bool option) public view returns (uint256)
{
    if(option == false)
    {
        return authorityTokens[msg.sender].totalSupply();
    }
    else{
        address def;
        return authorityTokens[def].totalSupply();
        
    }
}
   
    
    */
    
    
    
    
    
    
    
    /** old methods
     * 
     * 
     *   function divide(int256 n) public pure returns(int256)
    {
        return n/10000;
    }
    
    
    
     function getTrips(int64 startDate, int16 starthours) public view onlyVerifiedDriver() returns(offer[100] memory)  //offer[] memory
  {
      offer[100] memory offers;
      uint256 offerlength;
      
      //All trips with no endTime nor startTime can be added always if not reserced
      for(uint256 s = 0; s < mapindex[0]; s++)
         {
             if(endTimeMap[0][s].reserved == false)
             {
            
             offers[offerlength] = endTimeMap[0][s];
             offerlength++;
             }
         }
      
      
      
      //All trips with no endTime can be added immideatly if their startTime is early enough
       for(uint256 a = 0; a < mapindex[1]; a++)
         {
             if(endTimeMap[0][a].reserved == false)
             {
             if(endTimeMap[0][a].startTime <= (startDate*10000)+starthours-1000)
             {
             offers[offerlength] = endTimeMap[0][a];
             offerlength++;
             }
             }
         }
      
      
      
      // All trips with endDate > StartDate can be added immideatly if their startTime is early enough
      for(int64 i  = startDate+1; i < startDate+30; i++)
      {
         for(uint256 b = 0; b < mapindex[i]; b++)
         {
             if(endTimeMap[i][b].reserved == false)
             {
             if(endTimeMap[i][b].startTime <= (startDate*10000)+starthours-1000)
             {
             offers[offerlength] = endTimeMap[i][b];
             offerlength++;
             }
         } 
             }
      }
      
      
      // All trips with endDate = StartDate can be added immideatly if their startTime is early enough and their end date is after the required startDate
      for(uint256 c = 0; c < mapindex[startDate]; c++)
         {
             if(endTimeMap[startDate][c].reserved == false)
             {
             if(endTimeMap[startDate][c].startTime <= (startDate*10000)+starthours-1000)
             {
                 if(endTimeMap[startDate][c].endTime > starthours)
                 {
             offers[offerlength] = endTimeMap[startDate][c];
             offerlength++;
                 }
                     
                 }
             
             }
         }
      
      //offers[0] = endTimeMap[0][0];
      return offers;
  }
    
 */
}

pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;


import "./RoleManager.sol";
import "./TokenManager.sol";
contract CommunitySplit
{
    mapping (uint64 => offer[10000]) endTimeMap; //only Date, 0 means no endTime
   mapping (uint64 => uint256) public mapindex; //all indices of end time map, = length
   
   
    
    RoleManager roleManager;
    TokenManager tokenManager;
     
//     mapping(address => bool) firstTimeAdded; //checks if authority if added for the first time to not create multiple tokens for one address
     
     
   
     
     
     
    
    
    //int64[] indices;
    
    mapping (address => user) public usermap; //can rent or subrent objects
    
    
    
    uint256 currentID; //used to generate Ids 
    
    
    /**
    
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
     
 
  
   
    */
    
    
  
    
   
    
    
  
    
   
    
   
   //Verifier Section
 
 
 
 
 //calling neccessary modifiers to implement the trip logic from the subclass
 //Every role issue not directly related to trips is exclusively handeled in the subclass
   modifier onlyVerifiedDriver(uint8 objectType) {
        require (roleManager.isVerifiedDriver(msg.sender, objectType) == true);
        _;
    }
    
    modifier onlyVerifiedCarOwner() {
        require (roleManager.isVerifiedOwner(msg.sender) == true);
        _;
    }
    
     
     
     
     
     
     
     
      modifier onlyVerifiers()
    {
        require (roleManager.isVerifier(msg.sender) == true);
        _;
    }
    
  
  
      modifier onlyWithoutDebt()
    {
        require (tokenManager.hasDebt(msg.sender) == 0);
        _;
    }
    
      modifier onlyAuthorities()
    {
        require (roleManager.isAuthority(msg.sender) == true);
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
    
    
    
    address reservedAdress; //Address of the reserved Trip,                     if address == owner means that trip got deleted -> not needed anymore
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
      
      bool reserved; //did the user reserve a trip? -> maybe increase to a limit
      
      
      bool started; //did the user start a trip?
      
     
      
      
      uint8 rating; //Review Rating for that user from 1-5 on Client side
      uint256 ratingCount; //how often has this user been rated? Used to calculate rating
      
      
      mapping(address => bool) hasRatingRight; //checks if user has the right to give a 1-5 star rating for a trip (1 right for each ended trip)
      
   
 }
 
      
       constructor(string memory description) public {
           roleManager = new RoleManager(msg.sender); //creating a new instance of a subcontract in the parent class
           tokenManager = new TokenManager();
           tokenManager.createNewToken(msg.sender,description); //Genesis Token/ First Token
           
     //   authorities[msg.sender] = true;
     //   verifiers[msg.sender] = true;
      //  authorityTokens[msg.sender] = new CommunityToken(100, msg.sender, description, description); //generates new CommunityToken for that authority
        
    }
    
 
 
 
    //authorities who want to interact with the On Chain Governance need the address of the created local instance of the RoleManager contract
    function getRoleManagerAddress() public view returns(address)
    {
        return address(roleManager);
    }
    
       function getTokemManagerAddress() public view returns(address)
    {
        return address(tokenManager);
    }
    
    
    //after an authority is voted in it has the right to create at most one token for itself
    function createNewToken(string memory description) public onlyAuthorities
    {
        tokenManager.createNewToken(msg.sender, description);
    }
 

 
 //Initializes first authority when contract is created

    
 
 
 
 
 //ReservationSection
 
     //Checks if object can be reservated by anyone right now, true is it can get reservated
    function getIsReservable(uint64 endTime, uint256 index) public view returns (bool)
    {
        if(endTimeMap[endTime][index].reserved == false) //Even when the users status gets changed from reserved too started after starting a trip, the trip status actually is reserved and started at the same time
        return true;
        
        if(block.number - endTimeMap[endTime][index].reservedBlockNumber > endTimeMap[endTime][index].maxReservedAmount) //did i miss started trips?
        return true;
        
        
        return false;
        
    }
 
 
 
  
  
  //Object needs to be freem user needs to be verifired and cant have other reservations
   function reserveTrip(uint64 endTime, uint256 index) public onlyVerifiedDriver( endTimeMap[endTime][index].objectType) onlyWithoutDebt
    {
       
        require(usermap[msg.sender].reserved  == false);
         //***************else: emit already reserved Trip event***************
        
        
        
        require(getIsReservable(endTime, index) == true);
         //***************else: emit already reserved by somone else event ***************
        
        
       // require(usermap[msg.sender].balance > 1000); //require minimum balance *************change ERC20*****************
          require(tokenManager.getTotalBalanceOfUser(msg.sender) > 50*endTimeMap[endTime][index].price); //armim around 4 mins worth of balance 
          
          
            usermap[msg.sender].reserved = true;
          
             
            
            
            endTimeMap[endTime][index].reserved = true;
            endTimeMap[endTime][index].reservedAdress = msg.sender;
            endTimeMap[endTime][index].reservedBlockNumber = block.number;
          //***************emit Reservation successful event***************
          
        //  tokenManager.blockOtherPaymentsOfUser(msg.sender, endTimeMap[endTime][index].carOwnerAddress); //give allowance instead?
    }
    
    
    
    
    
    //canceling trip is only possible if user reserved the trip but did not start it yet
    function cancelReserve(uint64 endTime, uint256 index) public
    {
        if(endTimeMap[endTime][index].reservedAdress == msg.sender && endTimeMap[endTime][index].started == 0)
        {
            endTimeMap[endTime][index].reserved = false;
            usermap[msg.sender].reserved = false;
             //***************emit Reservation cancel successful event***************
             
          //   tokenManager.unblockOtherPaymentsOfUser(msg.sender);
        }
        
        
         //***************emit Reservation cancel not successful event***************
         
         
    }
    
    
    
    
    










//start and end Trip section    








    
    
    function startTrip(uint64 endTime, uint256 index) public onlyWithoutDebt
    {
        require(endTimeMap[endTime][index].reservedAdress == msg.sender && endTimeMap[endTime][index].started == 0);
        require(usermap[msg.sender].started == false); //user can only have 1 started trip
            // require(usermap[msg.sender].balance > 1000); //require minimum balance *************change ERC20*****************
            require(tokenManager.getTotalBalanceOfUser(msg.sender) > 50*endTimeMap[endTime][index].price); //user should have atleast enough balance for 50*5seconds -> around 4mins, minimum trip length
        require(tokenManager.getHasTotalAllowance(msg.sender) == true);
        //emit tripStart(tripAddress, tripKey, msg.sender, block.number);
         tokenManager.blockOtherPaymentsOfUser(msg.sender, endTimeMap[endTime][index].carOwnerAddress); //user gets blocked to make transactions to other addresses
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
           require(block.number > endTimeMap[endTime][index].userDemandsEnd+3); //authority has 3 blocks time to answer to endDemand request
         
         
         contractEndsTrip(endTime, index);
         
         
         
    }
    
    
   
    
    
    
    //only callable by carOwner if user wants to end the trip
    function confirmEndTrip(uint64 endTime, uint256 index) public
    {
         require(endTimeMap[endTime][index].carOwnerAddress == msg.sender && endTimeMap[endTime][index].started != 0);
           require(endTimeMap[endTime][index].userDemandsEnd != 0);
         contractEndsTrip(endTime, index);
        
    }
    
    function rejectEndTrip(uint64 endTime, uint256 index) public
    {
         require(endTimeMap[endTime][index].carOwnerAddress == msg.sender && endTimeMap[endTime][index].started != 0);
           require(endTimeMap[endTime][index].userDemandsEnd != 0);
         endTimeMap[ endTime][index].userDemandsEnd = 0;
            endTimeMap[endTime][index].userDemandsEnd = 0;
            //probably best to add an event and parse a string reason in parameters to state and explain why trip end was rejected
           
    }
    
    
     //On long rentals car owner can call this function to ensure sufficient balance from the user -> maybe dont use that function, just tell the user and add debt
    function doubtBalanceEnd(uint64 endTime, uint256 index) public
    {  
        require(endTimeMap[endTime][index].carOwnerAddress == msg.sender && endTimeMap[endTime][index].started != 0);
        //**************ERC20*********** if balance is not sufficient, renter can end contract
        
        require(tokenManager.getTotalBalanceOfUser(msg.sender) > 10*endTimeMap[endTime][index].price); //if user has less than 50seconds worth of balance then the owner can forceEnd the trip to prevent failure of payment
        
        contractEndsTrip(endTime, index);
        
        
        //Alternative: automatically end trips after certain amount and require user to rebook trips
        
    }
    
    
    
    
    
    function contractEndsTrip (uint64 endTime, uint256 index) internal
    {
        
        //*****************************ERC20Payment, out of money(?)**************************************
        tokenManager.handlePayment(block.number - endTimeMap[endTime][index].started,endTimeMap[endTime][index].price, msg.sender, endTimeMap[endTime][index].carOwnerAddress); //handle payment with elapsed time,´price of trip, from and to address
        if(tokenManager.hasDebt(msg.sender) == 0)
         tokenManager.unblockOtherPaymentsOfUser(msg.sender); //only unblocks user if the user managed to pay the full amount
     
             usermap[msg.sender].started = false;  
             usermap[msg.sender].hasRatingRight[endTimeMap[endTime][index].carOwnerAddress] = true;
            address def;
            endTimeMap[endTime][index].reservedAdress = def; //-> prob adress(0)
            endTimeMap[endTime][index].reserved = false;
            endTimeMap[endTime][index].started = 0;
            endTimeMap[endTime][index].userDemandsEnd = 0;
            
    }
    
    
    //returns the maxiumum amount of blocks the user can still rent the device before he/she runs out of balance
    function getMaxRamainingTime(uint64 endTime, uint256 index) public view returns (uint256)
    {
     require(endTimeMap[endTime][index].started != 0);
     uint256 currentPrice = (block.number - endTimeMap[endTime][index].started)*endTimeMap[endTime][index].price;
     uint256 userBalance = tokenManager.getTotalBalanceOfUser(endTimeMap[endTime][index].reservedAdress);
     uint256 theoreticalBalanceLeft = currentPrice -userBalance;
     return theoreticalBalanceLeft/endTimeMap[endTime][index].price;
     
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
    
    
    
    
    
    
    
   
}

pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;


import "./RoleManager.sol";
import "./TokenManager.sol";
//This contracts handles the trip logic and acts as a platform contract owning the TokenManager contract and the RoleManager contract
contract PlatformContract
{
    offer[] tripArray; //each trip offer by a lessor is stored in this array
    uint256[] indexOfID; //0 means offer got deleted
    RoleManager roleManager; //roleManager contract associated to this platform contract
    TokenManager tokenManager; //tokenManager contract associated to this platform contract
    mapping (address => user) public usermap; //can rent or subrent objects
    
    //Verifier Section
 
 
 
 
 //calling neccessary modifiers to implement the trip logic from the subclass
 //Every role issue not directly related to trips is exclusively handeled in the subclass
   modifier onlyVerifiedRenter(uint8 objectType) {
        require (roleManager.isVerifiedRenter(msg.sender, objectType) == true);
        _;
    }
    
    //objectType descirbes the sharing object category (car, charging station, bike, ...)
    modifier onlyVerifiedLessor(uint8 objectType) {
        require (roleManager.isVerifiedLessor(msg.sender, objectType) == true);
        _;
    }
     
     
      modifier onlyVerifiers()
    {
        require (roleManager.isVerifier(msg.sender) == true);
        _;
    }
    
  
    //renters who fail to pay for a trip have limited action right on the paltform 
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
    
    
    //renters or lessors which violated laws or acted in a malicious way can be blocked by authorities
    modifier isNotBlockedRenter()
    {
         require (roleManager.isBlocked(msg.sender, false) == false);
         _;
    }
    
      modifier isNotBlockedLessor()
    {
        require (roleManager.isBlocked(msg.sender, true) == false);
        _;
    }
  
  
  
  
  //Each offer issued by a verified lessor needs to provide the following attributes
    struct offer //offer cant be reserved while its started
 {
    address lessor; //lessor of the rental object
    uint256 startTime; //start time in sconds since uint  epoch (01.January 1970) -> use DateTime contract to convert Date to timestampt
    uint256 endTime; //end time in sconds since uint epoch (01.January 1970) -> use DateTime contract to convert Date to timestampt
    uint64 latpickupLocation; //lattitude of rental object pcikup location
    uint64 longpickupLocation; //longitude of rental object pcikup location
    
    uint64[10] latPolygons; 
    uint64[10] longPolygons; // at most 10 lattitude and longitude points to define return area of rental object
    
    address renter; //renter of the object                 
    bool reserved; //Is a trip reserved?
    uint256 reservedBlockNumber; //BlockNumber when a trip got reserved
    uint256 maxReservedAmount; //max amount of reservation time allowed in blocknumbers
    
    bool readyToUse; //Lessor needs to state if the device is ready for use (unlockable, ...) so that the renter does not need to pay for waiting
    
    //bool locked; //user might want to lock the object (car,..) during a trip to unlock it later (maybe not needed to be handled on chain but rather by interacting with the device itself)
    
    uint256 started; //Block number of start time, 0 by default -> acts as a bool check
    uint256 userDemandsEnd; //Block number of end demand
   
    uint256 id; //Uid of the trip
    uint256 price; //price in tokens per block (5 secs)
    
    uint8 objectType; //car, charging station, ...
    
    string model; //further information like BMW i3, Emmy Vesper, can be also used to present a more accurate picture to the user in the app
    
   }
 
 //users can be lessors or renters
 struct user
 {
      bool reserved; //did the user reserve a trip? -> maybe increase to a limit of multiple trips(?)
      
      bool started; //did the user start a trip?
      
      uint256 rating; //Review Rating for that user from 1-5 on Client side -> possible future feature that lessors can also rate renters and trips may automatically reject low rated renters
      
      uint256 ratingCount; //how often has this user been rated? Used to calculate rating
      
      mapping(address => bool) hasRatingRight; //checks if user has the right to give a 1-5 star rating for a trip lessor (1 right for each ended trip)
      mapping(address => bool) hasReportRight; //checks if the user has the right to give a report for a trip lessor
      
  }
 
		 //description: how do you want to name the first token?
       constructor(string memory description) public {
           roleManager = new RoleManager(msg.sender); //creating a new instance of a subcontract in the parent class  //Initializes first authority when contract is created
           tokenManager = new TokenManager();
           tokenManager.createNewToken(msg.sender,description); //Genesis Token/ First Token
           offer memory temp; //Genesis offer, cant be booked
           tripArray.push(temp);
           indexOfID.push(0); //0 id, indicates that trip got deleted, never used for an existing trip, points to Genesis trip
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
 



 //ReservationSection
 
     //Checks if object can be reservated by anyone right now, true is it can get reservated
    function getIsReservable(uint256 id) public view returns (bool)
    {
        if(tripArray[indexOfID[id]].reserved == false) //Even when the users status gets changed from reserved to started after starting a trip, the trip status actually is reserved and started at the same time
        return true;
        
        if(block.number - tripArray[indexOfID[id]].reservedBlockNumber > tripArray[indexOfID[id]].maxReservedAmount && tripArray[indexOfID[id]].started == 0) //if a trip exceeds the maxReservedAmount but was not started yet it can be reserved by another party again
        return true;
        
        
        return false;
        
    }
 
 
 
  
  
  //Object needs to be free, user needs to be verifired and cant have other reservations
   function reserveTrip(uint256 id) public onlyVerifiedRenter( tripArray[indexOfID[id]].objectType) onlyWithoutDebt isNotBlockedRenter
    {
       
        require(usermap[msg.sender].reserved  == false);
         //***************else: emit already reserved Trip event***************
        
        
        
        require(getIsReservable(id) == true);
         //***************else: emit already reserved by somone else event ***************
        
        
       // require(usermap[msg.sender].balance > 1000); //require minimum balance *************change ERC20*****************
          require(tokenManager.getTotalBalanceOfUser(msg.sender) > 50*tripArray[indexOfID[id]].price); //with 5secs blocktime around 4 mins worth of balance 
          
          
            usermap[msg.sender].reserved = true;
          
             
            
            
            tripArray[indexOfID[id]].reserved = true;
            tripArray[indexOfID[id]].renter = msg.sender;
           tripArray[indexOfID[id]].reservedBlockNumber = block.number; //reservation gets timstampt as its validity is time limited
          //***************emit Reservation successful event***************
          
        //  tokenManager.blockOtherPaymentsOfUser(msg.sender, tripArray[indexOfID[id]].lessor); //give allowance instead?
    }
    
    
    //canceling trip is only possible if user reserved the trip but did not start it yet
    function cancelReserve(uint256 id) public
    {
        if(tripArray[indexOfID[id]].renter == msg.sender && tripArray[indexOfID[id]].started == 0)
        {
            tripArray[indexOfID[id]].reserved = false;
            usermap[msg.sender].reserved = false;
             //***************emit Reservation cancel successful event***************
             
          //   tokenManager.unblockOtherPaymentsOfUser(msg.sender);
        }
        
        
         //***************emit Reservation cancel not successful event***************
         }
    
    
    //start and end Trip section    

    
    //users can only start trips if they are not blocked, dont have any debt, have a minimum balancethreshold right now, have not started another trip yet, have given the tokenManager contract allowance to deduct tokens on their behalf
    function startTrip(uint256 id) public onlyWithoutDebt isNotBlockedRenter
    {
        require(tripArray[indexOfID[id]].renter == msg.sender && tripArray[indexOfID[id]].started == 0);
        require(usermap[msg.sender].started == false); //user can only have 1 started trip
            // require(usermap[msg.sender].balance > 1000); //require minimum balance *************change ERC20*****************
            require(tokenManager.getTotalBalanceOfUser(msg.sender) > 50*tripArray[indexOfID[id]].price); //user should have atleast enough balance for 50*5seconds -> around 4mins, minimum trip length
        require(tokenManager.getHasTotalAllowance(msg.sender) == true);
        //emit tripStart(tripAddress, tripKey, msg.sender, block.number);
         tokenManager.blockOtherPaymentsOfUser(msg.sender, tripArray[indexOfID[id]].lessor); //user gets blocked to make transactions to other addresses
          tripArray[indexOfID[id]].readyToUse = false; //setting unlocked to false to esnure rental object is ready to use before user is charged
            tripArray[indexOfID[id]].started = block.number;
            usermap[msg.sender].started = true;
            usermap[msg.sender].hasReportRight[tripArray[indexOfID[id]].lessor] = true; //renter gets the right to submit a report if something is wrong at the start or during the trip (e.g. object not found, object not functioning properly, lessor maliciously rejected end of trip), reports always have to be accompanied by off chain prove client side and will be reviewed by authorites (or possibly additional roles)
            }
    
    
    //Authority needs to confirm after start trip that device is ready to used (unlocked,...)
    function confirmReadyToUse(uint256 id) public
    {
         require(tripArray[indexOfID[id]].lessor == msg.sender);
          tripArray[indexOfID[id]].started = block.number; //update started so user does not pay for waiting time
            tripArray[indexOfID[id]].readyToUse = true;
            //emit unlocked event
    }
    
    
    
    //only callable by Renter, demanding End of trip has to be confrimed by the lessor (valid drop off location,...)
    function demandEndTrip(uint256 id) public
    {
         require(tripArray[indexOfID[id]].renter == msg.sender && tripArray[indexOfID[id]].started != 0);
         require(usermap[msg.sender].started == true); //safety check, shouldnt be neccessarry to check
        require(tripArray[indexOfID[id]].userDemandsEnd == 0);
         tripArray[indexOfID[id]].userDemandsEnd = block.number;
         
    }
    
    //only callable by Renter, if lessor does not respond within 15 seconds, the renter can force end the trip
      function userForcesEndTrip(uint256 id) public
    {
         require(tripArray[indexOfID[id]].renter == msg.sender && tripArray[indexOfID[id]].started != 0);
         require(usermap[msg.sender].started == true); //safety check, shouldnt be neccessarry to check
           require(block.number > tripArray[indexOfID[id]].userDemandsEnd+3); //authority has 3 blocks time to answer to endDemand request
         
         
         contractEndsTrip(id);
         
         
         
    }
    
    
   
    
    
    
    //only callable by lessor if user wants to end the trip, confirms that the pbject was returned adequatly
    function confirmEndTrip(uint256 id) public
    {
         require(tripArray[indexOfID[id]].lessor == msg.sender && tripArray[indexOfID[id]].started != 0);
           require(tripArray[indexOfID[id]].userDemandsEnd != 0);
         contractEndsTrip(id);
        
    }
    
     //only callable by lessor if user wants to end the trip, states that the pbject was returned inadequatly, rejects endTrip attempt of renter, renter can always report against malicious use of this function
    function rejectEndTrip(uint256 id) public
    {
         require(tripArray[indexOfID[id]].lessor == msg.sender && tripArray[indexOfID[id]].started != 0);
           require(tripArray[indexOfID[id]].userDemandsEnd != 0);
         tripArray[indexOfID[id]].userDemandsEnd = 0;
            tripArray[indexOfID[id]].userDemandsEnd = 0;
            //probably best to add an event and parse a string reason in parameters to state and explain why trip end was rejected
           
    }
    
    
     //On long rentals Lessor can call this function to ensure sufficient balance from the user -> maybe dont use that function, just tell the user and add debt -> good idea for charging station as renter can force end easily here
    function doubtBalanceEnd(uint256 id) public
    {  
        require(tripArray[indexOfID[id]].lessor == msg.sender && tripArray[indexOfID[id]].started != 0);
        //**************ERC20*********** if balance is not sufficient, renter can end contract
        require(tripArray[indexOfID[id]].objectType == 4); //assuming object type 4 means charging station, function only makes sense for charging station 
        require(tokenManager.getTotalBalanceOfUser(msg.sender) > 10*tripArray[indexOfID[id]].price); //if user has less than 50seconds worth of balance then the Lessor can forceEnd the trip to prevent failure of payment
        
        contractEndsTrip(id);
        
        
        //Alternative: automatically end trips after certain amount and require user to rebook trips
        
    }
    
    //if renter demands end of trip and forces it or lessor confirms, the PlatformContract calls this function to handle payment and set all trip and user states to the right value again
    function contractEndsTrip (uint256 id) internal
    {
        
        //*****************************ERC20Payment, out of money(?)**************************************
        if(tripArray[indexOfID[id]].readyToUse) //user only needs to pay if the device actually responded and is ready to use -> maybe take out for testing to not require vehicle response all the time
       {
           if( tripArray[indexOfID[id]].userDemandsEnd == 0) //in this case user has to pay the difference form the current block number, should only happen if trip was force ended by authority
           tokenManager.handlePayment(block.number - tripArray[indexOfID[id]].started,tripArray[indexOfID[id]].price, msg.sender, tripArray[indexOfID[id]].lessor); //handle payment with elapsed time,´price of trip, from and to address
           else //in this case user only has to be the time until he/she demanded end of trip (user does not have to pay for the time it takes the rental object authority to confirm the trip)
            tokenManager.handlePayment(tripArray[indexOfID[id]].userDemandsEnd - tripArray[indexOfID[id]].started,tripArray[indexOfID[id]].price, msg.sender, tripArray[indexOfID[id]].lessor); //handle payment with elapsed time,´price of trip, from and to address
           
          } 
       
        if(tokenManager.hasDebt(msg.sender) == 0)
         tokenManager.unblockOtherPaymentsOfUser(msg.sender); //only unblocks user if the user managed to pay the full amount
         
     
             usermap[msg.sender].started = false;  
             usermap[msg.sender].hasRatingRight[tripArray[indexOfID[id]].lessor] = true;
            //address def;
            tripArray[indexOfID[id]].renter = address(0); //-> prob adress(0)
            tripArray[indexOfID[id]].reserved = false;
            tripArray[indexOfID[id]].started = 0;
            tripArray[indexOfID[id]].userDemandsEnd = 0;
            
             tripArray[indexOfID[id]].readyToUse = false; //restrict user from access to the vehicle => needs to be replicated in device logic
            
    }
    
    
    //returns the maxiumum amount of blocks the user can still rent the device before he/she runs out of balance, useful for client side warnings
    function getMaxRamainingTime(uint256 id) public view returns (uint256)
    {
     require(tripArray[indexOfID[id]].started != 0);
     uint256 currentPrice = (block.number - tripArray[indexOfID[id]].started)*tripArray[indexOfID[id]].price;
     uint256 userBalance = tokenManager.getTotalBalanceOfUser(tripArray[indexOfID[id]].renter);
     uint256 theoreticalBalanceLeft = currentPrice -userBalance;
     return theoreticalBalanceLeft/tripArray[indexOfID[id]].price;
     
    }
    
    
    //User has a rating right for each ended trip
    function rateTrip(address LessorAddress, uint8 rating) public
    {
        require(usermap[msg.sender].hasRatingRight[LessorAddress] == true);
        require(rating > 0);
        require(rating < 6);
        usermap[LessorAddress].rating += rating;
        usermap[LessorAddress].ratingCount++;
        usermap[msg.sender].hasRatingRight[LessorAddress] = false;
        
        
    }
    
    //User has the right to report a lessor for each started trip (might be useful to also add one for each reserved trip but allows spamming)
    function reportLessor(address LessorAddress, uint8 rating, string memory message) public
    {
         require(usermap[msg.sender].hasReportRight[LessorAddress] == true);
        //****here reports could be stored in an array with an own report governance logic or emited as an event for offchain handling by auhtorities which then return for on chain punishment****
        usermap[msg.sender].hasReportRight[LessorAddress] = false;
    }
    
    
    //Offer trip section
 
    
    
    //use DateTime contract before to convert desired Date to uint epoch
    function offerTrip(uint256 startTime, uint256 endTime, uint64 latpickupLocation, uint64 longpickupLocation, uint256 price,  uint64[10] memory latPolygons,  uint64[10] memory longPolygons,  uint256 maxReservedAmount, uint8 objectType, string memory model  ) public onlyVerifiedLessor(objectType) isNotBlockedLessor
    {
        offer memory tempOffer;
        tempOffer.startTime = startTime;
        tempOffer.endTime = endTime;
       
        tempOffer.latpickupLocation = latpickupLocation;
        tempOffer.longpickupLocation = longpickupLocation;
        
        tempOffer.lessor = msg.sender;
       
        tempOffer.price = price;
        
         tempOffer.latPolygons = latPolygons;
         tempOffer.longPolygons = longPolygons;
         tempOffer.maxReservedAmount = maxReservedAmount;
         tempOffer.objectType = objectType;
         
         tempOffer.model = model;
         
         
         tempOffer.id = indexOfID.length; // set id to the next following
        
        
      tripArray.push(tempOffer); //add trip to  the tripArray
     
      indexOfID.push(tripArray.length-1); //save location for latest id -> is linked to tempOffer.id from before
       
       
    }
    
    
    
    
    
    //Change Trip details Section
    
    
    //lessors can update object location if not in use or reserved   
    function updateObjectLocation(uint256 id, uint64 newlat, uint64 newlong) public onlyVerifiedLessor(tripArray[indexOfID[id]].objectType) //modifier might not be neccessary
    {
        require(tripArray[indexOfID[id]].lessor == msg.sender);
        require(tripArray[indexOfID[id]].reserved == false);
        tripArray[indexOfID[id]].longpickupLocation = newlong;
        tripArray[indexOfID[id]].latpickupLocation = newlat;
        
    }
    
    
   
     //lessors can update object price if not in use or reserved      
    function updateObjectPrice(uint256 id, uint256 price) public onlyVerifiedLessor(tripArray[indexOfID[id]].objectType) //modifier might not be neccessary -> check already happened before
    {
        require(tripArray[indexOfID[id]].lessor == msg.sender);
        require(tripArray[indexOfID[id]].reserved == false);
        tripArray[indexOfID[id]].price = price;
        
    }
    
    
    
    
    //lessors can delete their offers if not in use or reserved 
    function deleteTrip(uint256 id) public
    {
        require(tripArray[indexOfID[id]].reserved == false);
        require(tripArray[indexOfID[id]].lessor == msg.sender); //trip can only be deleted if not reserved (coveres reserved and started) and if the function is called by the Lessor
                 
         tripArray[indexOfID[id]] =  tripArray[tripArray.length-1]; //set last element to current element in the Array, thus ovverriting the to be deleted element
         indexOfID[tripArray[tripArray.length-1].id] = indexOfID[id]; //set the index of the last element to the position it was now switched to
         delete tripArray[tripArray.length-1]; //delete last element since it got successfully moved 
          indexOfID[id] = 0; //set index of deleted id = 0, indicating it got deleted
         tripArray.length--; //reduce length of array by one 
     
    }
    
   
    
    //maybe restrict function to authorities as its a costly operation, deletes outdated trips from the platform (trips with expired latest return date), frees storage
    function deleteOutdatedTrips() public
    {
        for(uint256 i = 1; i < tripArray.length; i++) //beginning at 1 since 0 trip is not used
        {
            if(tripArray[i].endTime < block.timestamp)
            deleteTripInternal(i);
        }
    }
    
     //difference from above: Lessor does not have to be msg.sender, gets called by the PlatformContract to delete outdated Trips
       function deleteTripInternal(uint256 id) internal
    {
        require(tripArray[indexOfID[id]].reserved == false); //object can only be rented if not in use
       
                 
         tripArray[indexOfID[id]] =  tripArray[tripArray.length-1]; //set last element to current element in the Array, thus ovverriting the to be deleted element
         indexOfID[tripArray[tripArray.length-1].id] = indexOfID[id]; //set the index of the last element to the position it was now switched to
         delete tripArray[tripArray.length-1]; //delete last element since it got successfully moved 
          indexOfID[id] = 0; //set index of deleted id = 0, indicating it got deleted
         tripArray.length--; //reduce length of array by one 
     
    }
    
    

    
    
    
    
    
    
    
    
    
    //Get Trip Information Section
    
    
    
    function getTrip(uint256 id) public view returns(offer memory)  //offer[] memory
    {
        
        
        return tripArray[indexOfID[id]]; //maybe mapindex has to be set to allow client to refind the trip -> probably better to set this client side when looping
    }
    
   
   
       function getLength() public view returns (uint256) //returns total amount of current trips
    {
        return tripArray.length;
    }
    
   



    //index +1 to make 0 distinguishable -no item found
    function getTripID(uint256 index) public view returns(uint256)
    {
       return tripArray[index].id;
    }
    
    
    //get sum of ratings and amount of ratings, need to be divided client side to retrive actual average rating -> costly operation
    function getRating(address a) public view returns( uint256[2] memory)
    {
        uint256[2] memory ratingArray;
        ratingArray[0] = usermap[a].rating;
        ratingArray[1] = usermap[a].ratingCount;
        return ratingArray;
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

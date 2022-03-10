pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract TripLogic
{
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
    
    
    
    
    
    
    
}
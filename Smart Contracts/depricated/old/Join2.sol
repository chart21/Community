pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;
contract Join2
{
    mapping (int64 => offer[10000]) endTimeMap; //only Date, 0 means no endTime
    mapping (int64 => uint256) public mapindex;
    
     mapping (address => bool) verifiers;
    
    
    //int64[] indices;
    
    mapping (address => user) public usermap;
    struct offer
 {
    address carOwnerAddress; 
    int64 startTime;
    int64 endDate; //repeat to let the client know
    int32 endTime; //hours - was added by 1000 to ensure 0000 is not possible
    int64 latpickupLocation;
    int64 longpickupLocation;
    int64 latdropofflocation;
    int64 longdropOffLocation;
    int32 dropoffRange;
    address reservedAdress;
    bool reserved;
    uint256 started; //Block number of start time
    uint256 index;
    int32 id;
    uint256 price; //next
 }
 
 struct user
 {
      uint balance;
      bool reserved;
      bool verifiedDriver;
      bool verifiedCarOwner;
 }
 
 
 
 
   modifier onlyVerifiers()
    {
        require (verifiers[msg.sender] == true);
        _;
    }
 
 function newVerifier(address proposal) public onlyVerifiers()
 {
     verifiers[proposal] = true;
 }
 
 function verifiyCarOwner(address proposal) public onlyVerifiers()
 {
     usermap[proposal].verifiedCarOwner = true;
 }
 
 function verifyDriver(address proposal) public onlyVerifiers()
 {
     usermap[proposal].verifiedDriver = true;
 }
 
 
   modifier onlyVerifiedDriver() {
        require (usermap[msg.sender].verifiedDriver == true);
        _;
    }
    
    modifier onlyVerifiedCarOwner() {
        require (usermap[msg.sender].verifiedCarOwner == true);
        _;
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
  
  
   function reserveTrip(int64 endTime, uint256 index) public onlyVerifiedDriver()
    {
        
        require(usermap[msg.sender].reserved  == false && endTimeMap[endTime][index].reserved == false);
        require(usermap[msg.sender].balance > 1000); //user can ride for atleast 15*1000 seconds
            usermap[msg.sender].reserved = true;
            endTimeMap[endTime][index].reserved = true;
            endTimeMap[endTime][index].reservedAdress = msg.sender;
        
    }
    
    //canceling trip is only possible if user reserved the trip but did not start it yet
    function cancelReserve(int64 endTime, uint256 index) public
    {
        if(endTimeMap[endTime][index].reservedAdress == msg.sender && endTimeMap[endTime][index].started == 0)
        {
            endTimeMap[endTime][index].reserved = false;
             usermap[msg.sender].reserved = false;
        }
    }
    
    
    
    function startTrip(int64 endTime, uint256 index) public
    {
        require(endTimeMap[endTime][index].reservedAdress == msg.sender && endTimeMap[endTime][index].started == 0);
        
        //emit tripStart(tripAddress, tripKey, msg.sender, block.number);
            endTimeMap[endTime][index].started = block.number;
            
        
    }
    
     //Every block customer loses 100*price of device balance, currently 1% commission, cancel reservse and start trips
    function endTrip(int64 endTime, uint256 index) public
    {
        require(endTimeMap[endTime][index].reservedAdress == msg.sender && endTimeMap[endTime][index].started != 0);
            //emit tripStart(tripAddress, tripKey, msg.sender, block.number);
           usermap[msg.sender].balance -= (block.number - endTimeMap[endTime][index].started)*100*endTimeMap[endTime][index].price; 
            usermap[msg.sender].balance += (block.number - endTimeMap[endTime][index].started)*99*endTimeMap[endTime][index].price;
            usermap[msg.sender].reserved = false;
            address def;
            endTimeMap[endTime][index].reservedAdress = def;
            endTimeMap[endTime][index].reserved = false;
            endTimeMap[endTime][index].started = 0;
            }
            
    
    //endTime needs to be added by 1000 to make 0000 not possible
    function offerTrip(int64 startTime, int32 endTime, int64 endDate, int64 latpickupLocation, int64 longpickupLocation, int64 latdropofflocation, int64 longdropOffLocation, int32 dropoffRange,int32 id, uint256 price) public onlyVerifiedCarOwner()
    {
        offer memory tempOffer;
        tempOffer.startTime = startTime;
        tempOffer.endTime = endTime;
        tempOffer.endDate = endDate;
        tempOffer.latpickupLocation = latpickupLocation;
        tempOffer.longpickupLocation = longpickupLocation;
        tempOffer.latdropofflocation = latdropofflocation;
        tempOffer.longdropOffLocation = longdropOffLocation;
        tempOffer.carOwnerAddress = msg.sender;
        tempOffer.dropoffRange = dropoffRange;
        tempOffer.id = id;
        tempOffer.price = price;
        
        
       endTimeMap[endDate][mapindex[endDate]] = tempOffer;
       mapindex[endDate]++;
       
    }
    
    function testVerifyme() public
    {
        usermap[msg.sender].verifiedDriver = true;
         usermap[msg.sender].verifiedCarOwner = true;
         usermap[msg.sender].balance += 2000000;
    }
    
    function reserveTripExternal(int64 endTime, uint256 index) public
    {
        require(endTimeMap[endTime][index].reserved == false);
        require(endTimeMap[endTime][index].carOwnerAddress == msg.sender);
        endTimeMap[endTime][index].reserved = true;
            
        
    }
    
    //car Owner can only unreserve trip if it was booked externally and if its actually his car  
     function unreserveTripExternal(int64 endTime, uint256 index) public
    {
        require(endTimeMap[endTime][index].carOwnerAddress == msg.sender);
        address def;
        require(endTimeMap[endTime][index].reservedAdress == def);
        endTimeMap[endTime][index].reserved = true;
        
        
    }
    function updateCarLocation(int64 endTime, uint256 index, int64 newlat, int64 newlong) public onlyVerifiedCarOwner
    {
        require(endTimeMap[endTime][index].carOwnerAddress == msg.sender);
        require(endTimeMap[endTime][index].reserved == false);
        endTimeMap[endTime][index].longpickupLocation = newlong;
        endTimeMap[endTime][index].latpickupLocation = newlat;
        
    }
    
    function getTrip(int64 endDate, uint256 index) public view returns(offer memory)  //offer[] memory
    {
        return endTimeMap[endDate][index];
    }
    
   
    //index +1 to make 0 distinguishable -no item found
    function getTripID(int64 endTime, int32 id, uint256 startindex) public view returns(uint256 index)
    {
        for(uint256 i = startindex; i<= mapindex[endTime]; i++)
        {
            if(endTimeMap[endTime][i].carOwnerAddress == msg.sender && endTimeMap[endTime][i].id == id)
            {
                return i+1;
            }
        }
    }
    
    function getIndex(int64 endTime) public view returns (uint256)
    {
        return mapindex[endTime];
    }
    
     function divide(int256 n) public pure returns(int256)
    {
        return n/10000;
    }
    
    
    
 
}

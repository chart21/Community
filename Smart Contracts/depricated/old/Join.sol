pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;
//In the future the car needs to track if it was droppedoff at the right location and if the engine is off before the trip can be ended. So far we only track drop off offchain which is not ideal -> car needs to have a node and gps access
contract Join
{
    //mapping (address => carOwner) addressMatch;
    mapping (address => customer) customerMatch;
   
    mapping (int8 => offers) datemapping;
    address[] carOwnerkeys;
    int256 countAuthorities = 1;
    mapping(address => bool) authorities;
    address platformOwner = msg.sender;
    mapping(address => bool) authorityVoted;
    vote proposal;
    offers[] offerList;
    
    constructor() public
    {
    authorities[msg.sender] = true;
    }
    //mapping (address => receipt) receipts:
  
  
   
    struct customer
    {
        bool verified;
        bool verifiedCarOwner;
        bool reserved;
        //address reservedTripAddress;
        //int reservedTripID;
        uint balance;
        
        
        
    }
    
 //   struct carOwner
 //   {
 //       bool verified;
 //       //mapping (int => offers) offerList;
 //       offers[] offerList;
 //   }
    
     struct offers
 {
    address carOwnerAddress; 
    int tripId;
    string time;
    string pickupLocation;
    string dropOffLocation;
    address reservedAdress;
    bool reserved;
    uint256 started;
 }
 
  struct vote
    {
        address proposedAuthority;
        uint256 PositiveVotesReceived;
        uint256 NegativeVotesRecived;
    }
 
     modifier onlyAuthorities()
    {
        require (authorities[msg.sender] == true);
        _;
    }
    
    
    
    // Only authorities should be able to invoke that function
    function verifyCarOwner(address carApplicant) public onlyAuthorities
    {
        addressMatch[carApplicant].verified = true;
        carOwnerkeys[carOwnerkeys.length] = carApplicant;
    }
    
    //Used for adding and dropping auhorities
    function voteAuthority(bool voteDecision) public onlyAuthorities
    {
        require(authorityVoted[msg.sender] == false);
            if(voteDecision == true)
            {
                proposal.PositiveVotesReceived++;
            if((proposal.PositiveVotesReceived+1)/2 > countAuthorities)
            {
                authorities[proposal.proposedAuthority] = true;
               vote memory newvote;
               proposal = newvote;
            }
            }
            if(voteDecision == false)
            {
                proposal.NegativeVotesRecived++;
                 if((proposal.NegativeVotesRecived+1)/2 > countAuthorities)
                 {
                         if(authorities[proposal.proposedAuthority] == true)
                         {
                             authorities[proposal.proposedAuthority] = false;
                             countAuthorities--;
                         }
                vote memory newvote;
               proposal = newvote;
                 }
                }
        
    }
    
    //Used for adding and dropping authorities -> spamming possible until other authorities successfully propose new Authority
    function proposeAuthority(address) public onlyAuthorities
    {
        address defAddress;
        if(proposal.proposedAuthority == defAddress)
        {
            vote memory temp;
            proposal = temp;
            proposal.proposedAuthority = defAddress;
        }
    }
    
    function getProposalAddress() public view onlyAuthorities returns (address)
    {
        return proposal.proposedAuthority;
    }
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
  //  event tripStart(address tripAddress, int tripKey, address userAddress, uint256 blocknumber);
//    constructor() public
  //  {
        
//    }
    
    modifier onlyVerifiedCustomer() {
        require (customerMatch[msg.sender].verified == true);
        _;
    }
    
    modifier onlyVerifiedCarOwner() {
        require (addressMatch[msg.sender].verified == true);
        _;
    }
    

    
    function reserveTrip(address tripAddress, uint256 tripKey) public onlyVerifiedCustomer()
    {
        
        require(addressMatch[tripAddress].offerList[tripKey].reserved  == false && customerMatch[msg.sender].reserved == false);
            addressMatch[tripAddress].offerList[tripKey].reserved = true;
            customerMatch[msg.sender].reserved = true;
            addressMatch[tripAddress].offerList[tripKey].reservedAdress = msg.sender;
        
    }
    
    //canceling trip is only possible if user reserved the trip but did not start it yet
    function cancelReserve(address tripAddress, uint256 tripKey) public
    {
        if(addressMatch[tripAddress].offerList[tripKey].reservedAdress == msg.sender && addressMatch[tripAddress].offerList[tripKey].started == 0)
        {
            addressMatch[tripAddress].offerList[tripKey].reserved = false;
            customerMatch[msg.sender].reserved = false;
        }
    }
    
    
    
    function startTrip(address tripAddress, uint256 tripKey) public
    {
        require(addressMatch[tripAddress].offerList[tripKey].reservedAdress == msg.sender && addressMatch[tripAddress].offerList[tripKey].started == 0);
        //emit tripStart(tripAddress, tripKey, msg.sender, block.number);
            addressMatch[tripAddress].offerList[tripKey].started = block.number;
            
        
    }
    
    //Every block customer loses 1 balance, currently 0% commission, cancel reservse and start trips
    function endTrip(address tripAddress, uint256 tripKey) public
    {
        require(addressMatch[tripAddress].offerList[tripKey].reservedAdress == msg.sender && addressMatch[tripAddress].offerList[tripKey].started != 0);
            //emit tripStart(tripAddress, tripKey, msg.sender, block.number);
            customerMatch[msg.sender].balance -= (block.number - addressMatch[tripAddress].offerList[tripKey].started);
            customerMatch[tripAddress].balance += (block.number - addressMatch[tripAddress].offerList[tripKey].started);
            customerMatch[msg.sender].reserved = false;
            address def;
            addressMatch[tripAddress].offerList[tripKey].reservedAdress = def;
            addressMatch[tripAddress].offerList[tripKey].started = 0;
            }
    
    function offerTrip(string memory time, string memory pickupLocation, string memory dropOffLocation) public onlyVerifiedCustomer()
    {
        offers memory offer;
        offer.time = time;
        offer.pickupLocation = pickupLocation;
        offer.dropOffLocation = dropOffLocation;
        addressMatch[msg.sender].offerList[addressMatch[msg.sender].offerList.length] = offer;
    }
    
    
    function getTripList() public view
    {
        
        for(int i = 0; i < carOwnerkeys.length; i++)
        {
            
        }
    }
    
    
    
}
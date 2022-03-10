pragma solidity >=0.4.22 <0.6.0;
//pragma experimental ABIEncoderV2;

//handles different roles on the Community Platform
contract RoleManager
{
    mapping (address => bool) verifiers; //have the right to verify users as Lessors or verified Renters
     
     mapping(address => bool) authorities; //have the right to vote in and out authorities, have their own tokens
     
      
      mapping(address => bool[5]) verifiedLessor; //verified Lessors can offer there property for rent on the platform -> obligations might differ whether you are allowed to lease out that specific object type
      
      mapping(address => bool[5]) verifiedRenter; //verified Renters have the right to rent specific property
      
      
      mapping(address => bool) blockedRenters; //users which are blocked from renting any objects (reasons might be steling of vehicles, or being an authority)
      
      mapping(address => bool) blockedLessors; //users which are blocked from leasing out any objects (reasons might be providing fake trips or denying end of trip with no basis)
     
     
     vote proposal; //Voting proposal, only one at one time, vote is a struct
 // address lastProposer; //Authorities can not propose more than one time in a row to prevent spamming. -> add block.number addition
 mapping(address => uint256) lastProposed; //block number of when this authority did propose last time, authorities can only propose every >10 blocks (-> 50 secs) to prevent spamming
  uint256 authorityCounter; //How many autohrities are in the network?
  
 
  //Modifiers are used to manage function access among roles
    modifier onlyVerifiers()
    {
        require (verifiers[msg.sender] == true);
        _;
    }
    
         modifier onlyAuthorities()
    {
        require (authorities[msg.sender] == true);
        _;
    }
  
  
    
     
     struct vote
    {
        address proposedAuthority;
        uint256 PositiveVotesReceived;
        uint256 NegativeVotesRecived;
        mapping (address => bool) hasVoted; //has the authority at that address already voted?
        
         string description; //a description of the votedAddress
        
    }
    
    
    
     constructor(address firstAddress) public {
      authorities[firstAddress] = true; //first adress is announced as first authority on the platform
       verifiers[firstAddress] = true;
       blockedRenters[firstAddress] = true; //authorities need to be blocked from rentals, see explanation in evaluateVotes() functions
      //  authorityTokens[msg.sender] = new CommunityToken(100, msg.sender, description, description); //generates new CommunityToken for that authority
        
    }

    
  
   //Used for adding and dropping authorities
    function proposeAuthority(address proposedAddress, string memory description) public onlyAuthorities
    {
        address defAddress; //change to address(0)
        if(proposal.proposedAuthority == defAddress && block.number >  lastProposed[msg.sender]+10) //only possible if last Vote is already over and Proposer has not proposed within the last 10 blocks  (prevents spamming)
        {
            vote memory temp; //can be deleted prob. and manually assign PositiveVotesReceived, .. to 0
            proposal = temp;
            proposal.proposedAuthority = proposedAddress;
            proposal.description = description;
            lastProposed[msg.sender] = block.number;
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
    function evaluateVotes() public //maybe change to internal
    {
         if(proposal.PositiveVotesReceived*2 >= authorityCounter) //Vote is over, authority gets added (or stays if it was already an autohrity)
            {
               if(authorities[proposal.proposedAuthority] == false)
                         {
                             authorities[proposal.proposedAuthority] = true;
                             authorityCounter++;
                             blockedRenters[proposal.proposedAuthority] = true; //authorities must be blcoked renters as during trip start all payments get blocked by the token manager, an authority which would get blocked in this context could no withdrawl tokens for users at the same time, also full debt based payment with own tokens should not be permitted
                             
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
                             //the former authority cannot be unblocked from not being allowed to rent since leftover tokens may still exist and have to be exchanged in fiat at any time a user demands
                         }
                vote memory newvote;
               proposal = newvote;
                 }
    }
    
    
      //Every authority has the right to step back, as total number of authories changes, current vote has to be reavluated
    function removeSelfFromAuthority() public onlyAuthorities
    {
      
        
         authorities[msg.sender] = false;
         if(msg.sender == proposal.proposedAuthority) //need to check if authority is currently in vote to not destroy the system
         {
              vote memory newvote;
               proposal = newvote;
         }
         
        authorityCounter--;
        evaluateVotes(); //Voting may have changed, need to reavluate
    }
    
    
     //Verifiers can verify Lessors
 function verifiyCarLessor(address userAddress, uint8 objectType) public onlyVerifiers()
 {
     verifiedLessor[userAddress] [objectType] = true;
 }
 
 
  //Verifiers can verify Renters
 function verifyRenter(address userAddress, uint8 objectType) public onlyVerifiers()
 {
   verifiedRenter[userAddress][objectType] = true;
 }
 
 
 //Authoirites can add Verifiers
 function addVerifier(address a) public onlyAuthorities
 {
     verifiers[a] = true;
 }
 
 //Authoirites can remove Verifiers if these are not other Authorities
  function removeVerifier(address a) public onlyAuthorities
 {
     require(a == msg.sender || authorities[a] == false); //authorities can only remove a verifier if the verifier is not another authority (unless they want to remove themselves)
     verifiers[a] = false;
 }
 
 
 //blocks user from renting or leasing out sharing objects, blockedType = false -> renting, blockedType = true -> sharing
 //A String message could be used and emmited or stored to justify the block
 function blockUser(address a, bool blockedType) public onlyAuthorities
 {
     require(authorities[a] == false); //authorities cannot block other authorities
     if(blockedType == false)
     blockedRenters[a] = true;
     else
     blockedLessors[a] = true;
 }
 
 //unblocks user from renting or leasing out sharing objects, blockedType = 0 -> renting, blockedType = 1 -> sharing
 function unblockUser(address a, bool blockedType) public onlyAuthorities
 {
     require(authorities[a] == false); //authorities must be blocked for renting and should not be blocked for leasing, this remains cosntant and they should not be able to unblock other authorities (or themselves)
     if(blockedType == false)
     blockedRenters[a] = false;
     else
     blockedLessors[a] = false;
 }
 
 
    //function to be removed later, convinient for testing to quickly verify oneself for leasing out and renting all objects
     function testVerifyme(address a) public
    {
     verifiedRenter[a][0] = true;
verifiedRenter[a][1] = true;
verifiedRenter[a][2] = true;
verifiedRenter[a][3] = true;
verifiedRenter[a][4] = true;
verifiedLessor[a][0] = true;
verifiedLessor[a][1] = true;
verifiedLessor[a][2] = true;
verifiedLessor[a][3] = true;
verifiedLessor[a][4] = true;
    }
    
    
    
    //getter Section
    
    function isAuthority(address a) public view returns(bool)
    {
        return authorities[a];
    }
    
     function isVerifier(address a) public view returns(bool)
    {
        return verifiers[a];
    }
    
    function isVerifiedLessor(address a, uint8 index) public view returns(bool)
    {
        return verifiedLessor[a][index];
    }
    
     function isVerifiedRenter(address a, uint8 index) public view returns(bool)
    {
        return verifiedRenter[a][index];
    }
    
    function isBlocked(address a, bool blockedType) public view returns(bool)
    {
        if(blockedType == false)
     return blockedRenters[a];
     else
     return blockedLessors[a];
    }
    
}
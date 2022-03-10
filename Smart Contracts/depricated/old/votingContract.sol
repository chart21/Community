contract votingContract
{
    uint256 authorityCounter;
    mapping(address => bool) authorities;
    uint proposalIDCounter;
    
    
    struct Voter {
       
        mapping(uint256 => bool) voted;  // if true, that person already voted for that proposal id
        uint vote;   // index of the voted proposal
        bool isVerifier; //is the Voter a verifier?
    }
    
     struct Proposal {
        bytes32 name;   // short name (up to 32 bytes)
        address proposalAddress; //address of proposal
        uint voteCount; // number of accumulated votes
        bool authorityProposal; //is Proposal propsed as authority or verifier?
        uint proposalID; //Id of the proposal, can never be the same
        
    }
    
     
     // This declares a state variable that
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;
    Proposal[] public addProposals; //addresses that should be added as authority
    Proposal[] public removeProposals; //addresses that should be removed as authority
    
    
    constructor() public {
        authorityCounter = 1;
        authorities[msg.sender] = true;
        
        }
        
        
        
        
    function voteAdd(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted[addProposals.proposalID], "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        // If `proposal` is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        addProposals[proposal].voteCount += sender.weight;
        if(sender.weight > 0)
        evaluateProposalAdd(proposal);
        
    }
    
    function evaluateProposalAdd(uint proposal) private
    {
        require(proposal.proposalAddress);
        if(addProposals[proposal].voteCount > authorityCounter/2) //> 50% Votes
        {
               Voter[proposal.proposalAddress].isVerifier = true;
               if(proposal.authorityProposal == true)
               {
                   authorityCounter++;
                   
               }
        }
    }
    
    
    
        
        
        




}
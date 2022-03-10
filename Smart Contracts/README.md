Deployment:


Deploy one PlatformContract contract. The PlatformContract takes a description as input on how you want to name the first token.
It will create a RoleManager contract and a TokenManager contract. You can receive their addresses with the getter methods of the PlatformContract.
You can reveive the address of each Community Token by calling the getter methods of the TokenManager contract. 


Testing:

For testing you should have at least 2 Ethereum account. 1 Account should do the deployment of the PlatformContract and will become the first authority on the platform.
Authorities are blocked from renting trips. Therefore you should use the second Ethereum account to test renting of trips. 
Simply deploy the PlatfomContract and get the address of the RoleManager contract. Verify the second ethereum account as a driver and the first ehtereum account
as a lessor using the methods of the RoleManager contract. You can then use the first ethereum account to offer a few trips. Get the address of the tokenManager contract and
get the address of the Community ERC20 token at index 0 (or at address of account 1). You can then transfer an arbitrary amount of Community ERC20 tokens from account 1 to account2.
Account 2 can then proceed to reserve and start trips created by account 1. Before account 2 can start a trip it first has to also interact with the first Communtiy ERC20 Token on the Platform and give total allowance
to the Token Manager contract. After doing all those steps you can play out a whole trip lifecycle. For further testing you may want to have additional accounts to vote in and out new authorities
announce verifiers, test debt, blocking of users and different types of verified renters and lessors. Once you created multiple tokens on the platforms you should notice that beofore renters can start
any trip they first have to go through each Community ERC20 token on the Platform and grant the TokenManagerContract total allowance. CLient side this process is automated for the renter. 
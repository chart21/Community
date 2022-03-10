pragma solidity >=0.4.0 <0.6.0;
pragma experimental ABIEncoderV2;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "./AccessRightManager.sol";

// file name has to end with '_test.sol'
contract test_1 {
AccessRightsManagement arm;
  function beforeAll() public {
    // here should instantiate tested contract
    arm = new AccessRightsManagement();
    bool result = arm.welcome("bla");
    Assert.equal(result, false, "user bla should not be recognised");
    result = arm.welcome("test");
    Assert.equal(result, true, "user test should be recognised");
   
 bool newresult = arm.proceedWelcome("bla","Please let me in");
   Assert.equal(newresult, true, "user should be able to requesst accoutn generation");
     result = arm.proceedWelcome("bla","Please let me in bro");
    Assert.equal(result, false, "user should not be able to requesst accoutn generation again");
     /**
     string memory message = arm.getCreationRequest("test");
    Assert.equal(true, (bytes(message).length > 0), "user message should be there");
    int8[4] memory a;
    a[2] = 2;
       Assert.equal(true, arm.getQueue().length == 1, "Queue should have 1 element now");
    arm.handleCreationRequest("test",true,0x65787465726e616c000000000000000000000000000000000000000000000000,"deliverer",a,[false,false,false,false,false]);
     Assert.equal(true, arm.getUser("bla").hasAccessRight[2] == 2, "user should have assigned access right");
     Assert.equal(true, arm.getQueue().length == 0,"Queue should be empty now");
     */
     
     
     
  }

  function check1() public {
   // arm = new AccessRightsManagement(); 
     // bool result = arm.proceedWelcome("bla","Please let me in bro");
    //Assert.equal(result, false, "user should not be able to requesst accoutn generation again");
     string memory message = arm.getCreationRequest("test");
    Assert.equal(true, (bytes(message).length > 0), "user message should be there");
    int8[4] memory a;
    a[2] = 2;
       Assert.equal(true, arm.getQueue().length == 1, "Queue should have 1 element now");
    arm.handleCreationRequest("test",true,0x65787465726e616c000000000000000000000000000000000000000000000000,"deliverer",a,[false,false,false,false,false]);
    // Assert.equal(true, arm.getUser("bla").hasAccessRight[2] == 2, "user should have assigned access right");
     //Assert.equal(true, arm.getQueue().length == 0,"Queue should be empty now");
     int8 newright = arm.newAccessRight("bla",1);
     Assert.equal(true, newright == 0,"access right before should be 0");
     arm.newAccessRight("bla",1);
  // bool allowed = arm.handleRequest("test",0,1,true);
  // Assert.equal(true, allowed,"access right should be granted");
     
}
}
/**
  function check2() public view returns (bool) {
    // use the return value (true or false) to test the contract
    return true;
  }
  
}

/**
contract test_2 {
 
  function beforeAll() public {
    // here should instantiate tested contract
    Assert.equal(uint(4), uint(3), "error in before all function");
  }

  function check1() public {
    // use 'Assert' to test the contract
    Assert.equal(uint(2), uint(1), "error message");
    Assert.equal(uint(2), uint(2), "error message");
  }

  function check2() public view returns (bool) {
    // use the return value (true or false) to test the contract
    return true;
  }
}
*/
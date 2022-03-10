pragma solidity >=0.4.0 <0.6.0;
pragma experimental ABIEncoderV2;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "./Join2.sol";

// file name has to end with '_test.sol'
contract test_1 {
Join2 arm;
  function beforeAll() public {
    // here should instantiate tested contract
    arm = new Join2();
    arm.testVerifyme();
    arm.offerTrip(201905211400,2400,20190524,30,40,50,60,5000);
    arm.offerTrip(201905211400,2400,20190523,30,40,50,60,5000);
    arm.reserveTrip(20190524, 1);
    arm.startTrip(20190524, 1);
    arm.endTrip(20190524, 1);
    
   // int64 endTime = arm.getTrips(20190523,2500)[0].endDate;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   
}
}
pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;
contract Variable
{
    int64 balance;
     mapping (uint64 => offer[]) endTimeMap;
      mapping (uint64 => uint256) public mapindex; 
     
     offer[] offerArray;
     
      struct offer //offer cant be reserved while its started
 {
    
  
    
    int key;
    //Address of the reserved Trip, if address == owner means that trip got deleted
    bool reserved; //Is a trip reserved?
  
   
    
    
 }
 
 
 
  function testfillArray() public
 {
   offer memory troll;
  troll.key = 0;
  
  
     offerArray.push(troll);
     
     
     
    
       
      
         offer memory troll1;
  troll.key = 1;
    offer memory trol2 ;
  trol2.key = 2;
    offer memory trol3  ;
  trol3.key = 3;
    offer memory trol4 ;
  trol4.key = 4;
    offer memory  trol5 ;
  trol5.key = 5;
    offer  memory trol6;
  trol6.key = 6;
    offer memory trol7;
  trol7.key = 7;
  
  
      offerArray.push(trol2);
       offerArray.push(trol3);
       offerArray.push(trol4);
      offerArray.push(trol5);
       offerArray.push(trol6);
      offerArray.push(trol7);
     
      
       
       
    // mapindex[0] = 4;
    // mapindex[1] = 3;
    //   mapindex[2] = 1;
     
     
    
     
 }
  function getLengthArray() public view returns (uint256)
    {
        return offerArray.length;
    }
 
 
 function deleteElement(uint256 index) public
 {
     offerArray[index] = offerArray[offerArray.length-1];
     delete offerArray[offerArray.length-1];
     offerArray.length--;
 }
 
 
 
 function testfill() public
 {
   offer memory troll;
  troll.key = 0;
  
  
     endTimeMap[0][0] = troll;
     
     
     
    
       
      
         offer memory troll1;
  troll.key = 1;
    offer memory trol2 ;
  trol2.key = 2;
    offer memory trol3  ;
  trol3.key = 3;
    offer memory trol4 ;
  trol4.key = 4;
    offer memory  trol5 ;
  trol5.key = 5;
    offer  memory trol6;
  trol6.key = 6;
    offer memory trol7;
  trol7.key = 7;
  
  
   endTimeMap[0][1] = trol2;
     endTimeMap[0][2] = trol3;
     endTimeMap[0][3] = trol4;
     endTimeMap[1][0] = trol5;
     endTimeMap[1][1] = trol6;
     endTimeMap[1][2] = trol7;
     
       endTimeMap[2][0] = troll1;
       
       
     mapindex[0] = 4;
     mapindex[1] = 3;
       mapindex[2] = 1;
     
     
    
     
 }
    
    function getLength(uint64 index) public view returns (uint256)
    {
        return endTimeMap[index].length;
    }
    
      function getLength2(uint64 index) public view returns (uint256)
    {
        return mapindex[index];
    }
    
      function deleteTrip(uint64 endTime, uint256 index) public
      {
         endTimeMap[endTime][index] = endTimeMap[endTime][mapindex[endTime] -1];
         delete endTimeMap[endTime][mapindex[endTime] -1];
         mapindex[endTime]--; 
     
      }
    
    
    function geteverything(uint64 index) public view returns ( offer[] memory)
    {
        return  endTimeMap[index];
    }
    
    
    
     function changeBalanceV(int64 pBalance) public
     {
         balance = pBalance;
     }
     
     function getBalance() public view returns (int64)
     {
         return balance;
     }
     
     
     
     
     
     
     
     
     
     
}
pragma solidity ^0.5.6;
pragma experimental ABIEncoderV2;

import "./owned.sol";
import "./Resource.sol";



contract XS is owned {
    
      
   struct pathway{
      address from;
      uint amount;
      uint class;
      uint timestamp;
  }
  
  
  struct resource{
      uint id;
      uint quantity;
      //address addr;
      //uint timestamp;
      //uint[] components;
  }
  mapping(address=>pathway[]) pathways;

    
    mapping (string => int256) public toId ;
    mapping (int256 => address) public toAddress;
    mapping( int =>resource[]) public recipes;    // id => id[]
    resource[] public resourcesTMP;

    int256 public nresources;

    constructor () public
    {
      nresources = 0;
    }

    event NewResource(string _label);

    // check if resource exists. If so, send order to resource, otherwise it should first create the resource and then send an order to it.
    function request(string memory label, uint amount) public returns (bool success)
    {
        //bytes32 label = sha3(_label);
        int256 id = toId[label];
        if (id > 0x0)//NOTE: id 0 reserved for any unmatched resource
        {
           Resource res = Resource(toAddress[id]);
           res.request(amount);
        }
        else
        {   // NOTE
            nresources += 1;
            Resource newres = new Resource(label);
            newres.request(amount);
            toAddress[nresources] = address(newres);
            toId[label] = nresources;
            
            emit NewResource(label);
        }
        return true;
    }

    function listResources() public view returns ( int [] memory )
    {
      int[] memory ret= new int[](uint (nresources));
      for(uint i=0; i < uint(nresources); i++)
        {
            Resource res = Resource(toAddress[int256(i+1)]);

            ret[i]= int(res.nrequests());
        }
        return ret;
    }

    function listResourcesName() public view returns ( string [] memory)
    {
      string[] memory ret =new string[](uint (nresources));
      for(uint i=0; i < uint(nresources); i++)
        {
            Resource res = Resource(toAddress[int256(i+1)]);

            ret[i]= string(res.label());
        }
        return ret;
    }
    
    // function createMatrix() public view returns ( string [] memory)
    // {
    //   string[] memory ret =new string[](uint (nresources));
    //   for(uint i=0; i < uint(nresources); i++)
    //     {
    //         Resource res = Resource(toAddress[int256(i+1)]);

    //         ret[i]= string(res.label());
    //     }
    //     return ret;
    // }
    
    
   // index = 0; mapping (uint256 => address[]);
    //address[] storage b = mapping[index++];
    
    // function addRecipe(uint  productID, uint[] memory resources, uint[] memory quantities) public{
    //     resource[] storage  res   = resources[productID];
        
    //     for (uint i; i<resources.length;i++){
    
    //         //check if resource list existed;
    //       res[i]= resource(resources[i],quantities[i]);
    //     }
    // }
    
}
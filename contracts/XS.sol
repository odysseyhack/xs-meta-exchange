 pragma solidity ^0.5.6;
pragma experimental ABIEncoderV2;

import "./ResourceDAO.sol";

contract XS {
    
    mapping( address => mapping(uint256 => int256)) public wallets ; 
    

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

    mapping (string => uint) public toId ;
    mapping (uint => address) public toAddress;

    uint public nresources;

    constructor() public
    {
      nresources = 0;
    }


    // check if resource exists. If so, send order to resource, otherwise it should first create the resource and then send an order to it.
    function request(string memory label,uint recipe, string memory location, uint amount) public returns (bool success)
    {
        //bytes32 label = sha3(_label);
        uint id = toId[label];
        if (id > 0x0)//NOTE: id 0 reserved for any unmatched resource
        {
           ResourceDAO res = ResourceDAO(toAddress[id]);
           res.requestRecipe(recipe, amount, location);
        }
        else //if resourece does not exist, create one, then request it
        {
            ResourceDAO res =  ResourceDAO(createResource(label));
            res.requestRecipe(recipe, amount, location);
        }
        return true;
    }

    
    function subtractAssets(address _address, uint[] memory assets, uint amount) public {
        //TODO:check for permission
        for (uint i = 0; i<  assets.length; i++){
           wallets[_address][i] -= int(assets[i] * amount);
        }
        
    }
    
      function addAssets(address _address, uint[] memory assets, uint amount) public {
        //TODO:check for permission
        for (uint i = 0; i<  assets.length; i++){
           wallets[_address][i] += int(assets[i] * amount);
        }
        
    }

    function createResource(string memory label) public returns (address){
        nresources += 1;
        ResourceDAO newres = new ResourceDAO(label,nresources, address(this));
        toAddress[nresources] = address(newres);
        toId[label] = nresources;
        emit NewResource(label);
        return address(newres);
    }


    
    //   function proposeExchange(uint[] memory inlets, uint[]  memory inletsamount , uint[] memory outlets, uint[] memory outletsamount) public returns (bool success)
    // {
    //     //bytes32 label = sha3(_label);
        
    //     for(uint i = 0; i < outlets.length ; i++) //for the hackathon, this will always be 1 
    //     {
    //          ResourceDAO output = ResourceDAO(toAddress[outlets[i]]);
    //          output.addRecipe()
    //     }
        

    //     return true;
    // }


    function listResources() public view returns ( int [] memory )
    {
      int[] memory ret= new int[](uint (nresources));
      for(uint i=0; i < uint(nresources); i++)
        {
            ResourceDAO res = ResourceDAO(toAddress[i+1]);

            ret[i]= int(res.nrequests());
        }
        return ret;
    }

    function listResourcesName() public view returns ( string [] memory)
    {
      string[] memory ret =new string[](uint (nresources));
      for(uint i=0; i < uint(nresources); i++)
        {
            ResourceDAO res = ResourceDAO(toAddress[i+1]);

            ret[i]= string(res.label());
        }
        return ret;
    }

    // function createMatrix() public view returns ( string [] memory)
    // {
    //   string[] memory ret =new string[](uint (nresources));
    //   for(uint i=0; i < uint(nresources); i++)
    //     {
    //         ResourceDAO res = ResourceDAO(toAddress[int256(i+1)]);

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
    //       res[i]= ResourceDAO(resources[i],quantities[i]);
    //     }
    // }

    event NewResource(string _label);
}

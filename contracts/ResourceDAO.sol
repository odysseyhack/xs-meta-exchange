pragma solidity ^0.5.6;

//import "mortal.sol";


contract ResourceDAO //is also a full `DAO'
{
    enum Status {Requested, Claimed, Completed}
    
    enum Assets {Time, Energy, Transportation, Waste}
    
    struct Recipe {
        string name;
        address[] components;// which sub resources are needed (by address)
        uint[] componentRecipe; //tells which specific recipe to order in the components
        uint[] amounts; // tell how much we need (in resource units defined in the DAO )
        uint ncomponents; 
        //uint reputation;
        //string IPFSInfo;
    }

    struct Request {
        address requester;
        uint recipeID;
        uint amounts;
        //string location; //(geohash)
        uint8 status;
        uint creation;
        //string IPFSInfo;
    }
    
    //Each dao contains information about its recipes)
     Recipe[]  public recipes;
    
    //Alternative: Agent based (every DAO IS a recipe)
    //mapping(int=>Resource[]) components;
    //mapping(int=>int[]) quantities;
    
    uint nrecipes;
    uint bestrecipe; // Selected by DAO prosumer signaling
    

    Request[] public requests;

    string public label;   // the name of this resource
    uint public id;        // unique identifier of the resource
    uint public nrequests; // Current overall demand of resource


    event NewRequest(string _label , uint recipeID, uint amount );

    constructor (string memory _label) public
    {
        nrequests = 0;
        nrecipes = 0;
        bestrecipe = 0;
        label = _label;
        //rep = new Reputation();
    }
    
    // call for default recipe 
    function request(uint _amount) public 
    {
        requestRecipe(bestrecipe, _amount);
    }
    // call for specific recipe
    function requestRecipe(uint _recipeID, uint _amount) public 
    {
        if (nrecipes == 0 || _recipeID >= nrecipes ) return ; //Check validity of request
        
        Request memory order = Request (msg.sender, _recipeID, _amount,  0 , now);
        nrequests += _amount;
        requests.push(order);
        
        //Order component resources 
        for (uint i = 0; i<recipes[_recipeID].ncomponents; i++)
        {
            //if (recipes[_recipeID].components[i] == address(0x0)) return; //exit if no additional components are required
            
            uint ramount =  recipes[_recipeID].amounts[i] * _amount; //Here we are multipling needed components with the requested amount
            uint rrecipe = recipes[_recipeID].componentRecipe[i];
            
            ResourceDAO r = ResourceDAO(recipes[_recipeID].components[i]);
            r.requestRecipe(rrecipe, ramount);
            
            // Optimized function (did not test this)
            //(recipes[recipeID]).components[i]).call(bytes4(keccak256("requestRecipe(uint, uint)"),rrecipe,ramount);
        }
        
        //Notify listeners
        emit NewRequest(label,_recipeID,_amount);
    }

    function getRequestInfo(uint id ) public view returns (
      address requester,
      uint amounts,
      //string memory lat,
      //string memory lon,
      uint status,
      uint creation
    ){
      Request storage order =  requests[ id ];
      requester = order.requester;
      amounts = order.amounts;
      //lat = order.lat;
      //lon = order.lon;
      status = order.status;
      creation = order.creation;

    }

    function getStatus(uint id) public view returns (uint status) {
      Request memory order = requests[id];
      status = order.status;
      return status;
    }

    function confirm(uint id) public
    {
        Request storage order = requests[id];
        order.status = 2; //Status::Completed;
        //Transfer agreed amount from requester to supplier
        //eg:
        //time.balanceOf[msg.sender] += order.amounts;
        //time.balanceOf[order.requester] -= order.amounts;
        

    }
    
    function getTruePrice(uint recipeID) view public returns (uint) {
        uint sum = 0;
        if ( nrecipes == 0 ) return 1; // exit rule, change for different assets;
        for (uint i = 0; i < recipes[recipeID].components.length; i++){
            sum+=recipes[recipeID].amounts[i]*ResourceDAO(recipes[recipeID].components[i]).getTruePrice(recipes[recipeID].componentRecipe[i]);
        }
        return sum; 
    }
    
    
        
    function getTrueAssetPrice(uint recipeID) view public returns (uint[] memory) {

       uint[] memory result;;
       if ( nrecipes == 0 )  return result;
   
        for (uint i = 0; i < recipes[recipeID].components.length; i++){
            ResourceDAO r = ResourceDAO(recipes[recipeID].components[i]);
            result[r.id()]++;
            // if (r.id() == uint(Assets.Energy)) result[uint(Assets.Energy)]++;
            // if (r.id() == uint(Assets.Waste)) result[uint(Assets.Waste)]++;
            // if (r.id() == uint(Assets.Transportation)) result[uint(Assets.Transportation)]++;
            
            result = mulVectors(addVectors(result, r.getTrueAssetPrice(recipes[recipeID].componentRecipe[i])),recipes[recipeID].amounts[i]);
            //sum+=recipes[recipeID].amounts[i]*ResourceDAO(recipes[recipeID].components[i]).getTrueAssetPrice(recipes[recipeID].componentRecipe[i]);
        }
        return result;
    }
    
    
    function getTruePriceGeneric(uint recipeID) view public returns (uint[] memory) {

       uint[] memory result;
       if ( nrecipes == 0 )  return result;
   
        for (uint i = 0; i < recipes[recipeID].components.length; i++){
            ResourceDAO r = ResourceDAO(recipes[recipeID].components[i]);
            result[r.id()]++;
            result = mulVectors(addVectors(result, r.getTrueAssetPrice(recipes[recipeID].componentRecipe[i])),recipes[recipeID].amounts[i]);
            //sum+=recipes[recipeID].amounts[i]*ResourceDAO(recipes[recipeID].components[i]).getTrueAssetPrice(recipes[recipeID].componentRecipe[i]);
        }
        return result;
    }
    
     function  addVectors (uint[] memory lhs, uint[] memory rhs) pure public returns (uint[] memory)
    {
        uint[] memory v =  new uint[](lhs.length); 
        for (uint i = 0; i < lhs.length; i++)
            v[i] = lhs[i] - rhs[i];
        return v;
    }

    function  mulVectors (uint[] memory lhs, uint scalar) pure  public returns (uint[] memory)
    {
        uint[] memory v = new uint[](lhs.length); 
        for (uint i = 0; i < lhs.length; i++)
            v[i] = lhs[i] * scalar;
        return v;
    }
    
    function addRecipe(string memory name, address[] memory components, uint[] memory componentRecipe, uint[] memory quantities) public{
        uint ncomponents = components.length;
        recipes.push(Recipe(name, components, componentRecipe,quantities,ncomponents));
        nrecipes++;
    }
    
   function getComponents(uint recipeID) view public returns (address[] memory ){
        return recipes[recipeID].components;
    }
}

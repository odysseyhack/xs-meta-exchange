pragma solidity ^0.5.6;

//import "mortal.sol";


contract Resource
{
    enum Status {Requested, Claimed, Completed}
    
    struct Recipe {
        string name;
        address[] components;// which sub resources are needed
        uint[] componentRecipe; //tells which specific recipe to order in the components
        uint[] amounts; // tell how much we need (in resource units defined in the DAO )
        uint ncomponents; 
        //string IPFSInfo;
    }

    struct Request {
        address requester;
        uint recipeID;
        uint amounts;
        //string location;
        uint8 status;
        uint creation;
        //string IPFSInfo;
    }
    
    //Data based (Each dao contains information about its recipes)
     Recipe[]  public recipes;
    
    //Agent based (every DAO is a component of a recipe)
    //mapping(int=>Resource[]) components;
    //mapping(int=>int[]) quantities;
    
    uint nrecipes;
    uint bestrecipe; // Selected by DAO prosumer signaling
    

    Request[] public requests;

    string public label; // the name of this resource
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
        Request memory order = Request (msg.sender, _recipeID, _amount,  0 , now);
        nrequests += _amount;
        requests.push(order);
        //Order component resources 
        for (uint i = 0; i<recipes[_recipeID].ncomponents; i++)
        {
            //if (recipes[_recipeID].components[i] == address(0x0)) return; //exit if no additional components are required
            
            Resource r = Resource(recipes[_recipeID].components[i]);
            uint ramount =  recipes[_recipeID].amounts[i] * _amount; //Here we are multipling needed components with the requested amount
            uint rrecipe = recipes[_recipeID].componentRecipe[i];

            r.requestRecipe(rrecipe, ramount);
            //(recipes[recipeID]).components[i]).call(bytes4(keccak256("request(string lat, string lon)"),);
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
        order.status = 2; //Status.completed;
        //Transfer agreed amount from requester to supplier
        //eg:
        //time.balanceOf[msg.sender] += order.amounts;
        //time.balanceOf[order.requester] -= order.amounts;
        

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

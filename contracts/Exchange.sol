pragma experimental ABIEncoderV2;
pragma solidity ^0.5.6;

import "./ResourceDAO.sol";

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}


contract ERC1178 {
    // Required Functions
    function implementsERC1178() public pure returns (bool);
    function totalSupply() public view returns (uint256);
    function individualSupply(uint256 classId) public view returns (uint256);
    function balanceOf(address owner, uint256 classId) public view returns (uint256);
    function classesOwned(address owner) public view returns ( uint256[] memory);
    function transfer(address to, uint256 classId, uint256 quantity) public;
    function approve(address to, uint256 classId, uint256 quantity) public;
    function transferFrom(address from, address to, uint256 classId) public;

    // Optional Functions
    function name() public pure returns (string memory);
    function className(uint256 classId) public view returns (string memory);
    function symbol() public pure returns (string memory);

    // Required Events
    event Transfer(address indexed from, address indexed to, uint256 indexed classId, uint256 quantity);
    event Approval(address indexed owner, address indexed approved, uint256 indexed classId, uint256 quantity);
}

contract Exchange is ERC1178 {
  using SafeMath for uint256;
  address public Owner;
  uint256 public tokenCount;
  uint256 currentClass;
  uint256 minTokenPrice;
  uint256 minCount;
  string hello;
  
  struct Transactor {
    address actor;
    uint256 amount;
  }
  
  struct TokenExchangeRate {
    uint256 heldAmount;
    uint256 takeAmount;
  }
  
  mapping(uint256 => uint256) public classIdToSupply;
  mapping(address => mapping(uint256 => uint256)) ownerToClassToBalance;
  mapping(address => mapping(uint256 => Transactor)) approvals;
  mapping(uint256 => string) public classNames;
  mapping(address => mapping(uint256 => mapping(uint256 => TokenExchangeRate))) exchangeRates;


    mapping (string => int256) public toId ;
    mapping (int=> address) public toAddress;
 
    int256 public nresources;


  // Constructor
  constructor () public {
    Owner = msg.sender;
    currentClass = 1;
    tokenCount = 0;
    minCount = 1; // min number of tokens (arbitrary)
    minTokenPrice = 0; // (also arbitrary)
  }

  function implementsERC1178() public pure returns (bool) {
    return true;
  }

  function totalSupply() public view returns (uint256) {
    return tokenCount;
  }

  function individualSupply(uint256 classId) public view returns (uint256) {
    return classIdToSupply[classId];
  }

  function balanceOf(address owner, uint256 classId) public view returns (uint256) {
    /* if (ownerToClassToBalance[owner] == 0) return 0; */
    return ownerToClassToBalance[owner][classId];
  }

  // class of 0 is meaningless and should be ignored.
  function classesOwned(address owner) public view returns (uint256[] memory){
    uint256[] memory tempClasses = new uint256[](currentClass - 1);
    uint256 count = 0;
    for (uint256 i = 1; i < currentClass; i++){
      if (ownerToClassToBalance[owner][i] != 0){
        if (ownerToClassToBalance[owner][i] != 0){
          tempClasses[count] = i;
        }
        count += 1;
      }
    }
    uint256[] memory classes = new uint256[](count);
    for (uint i = 0; i < count; i++){
      classes[i] = tempClasses[i];
    }
    return classes;
  }

  function transfer(address to, uint256 classId, uint256 quantity) public {
    require(ownerToClassToBalance[msg.sender][classId] >= quantity);
    ownerToClassToBalance[msg.sender][classId] -= quantity;
    ownerToClassToBalance[to][classId] += quantity;
    Transactor memory zeroApproval;
    zeroApproval = Transactor(address(0x0), 0);
    approvals[msg.sender][classId] = zeroApproval;
  }

  function approve(address to, uint256 classId, uint256 quantity) public {
    require(ownerToClassToBalance[msg.sender][classId] >= quantity);
    Transactor memory takerApproval;
    takerApproval = Transactor(to, quantity);
    approvals[msg.sender][classId] = takerApproval;
    emit Approval(msg.sender, to, classId, quantity);
  }

  function proposeExchange(uint256 classIdHeld, uint256 quantityHeld,
    uint256 classIdWanted, uint256 quantityWanted) public {
    require(ownerToClassToBalance[msg.sender][classIdHeld] >= quantityHeld);
    TokenExchangeRate memory tokenExchangeApproval;
    tokenExchangeApproval = TokenExchangeRate(quantityHeld, quantityWanted);
    exchangeRates[msg.sender][classIdHeld][classIdWanted] = tokenExchangeApproval;
  }


  // fills partial exchanges if approval and balance allows for it.
  function exchange(address to, uint256 classIdPosted, uint256 quantityPosted,
    uint256 classIdWanted, uint256 quantityWanted) public {
      // check if capital existence requirements are met by both parties
    require(ownerToClassToBalance[msg.sender][classIdPosted] >= quantityPosted);
    require(ownerToClassToBalance[to][classIdWanted] >= quantityWanted);
    // check if approvals are met
    require(approvals[msg.sender][classIdPosted].actor == address(this) &&
      approvals[msg.sender][classIdPosted].amount >= quantityPosted);
    require(approvals[to][classIdWanted].actor == address(this) &&
      approvals[to][classIdWanted].amount >= quantityWanted);
    // check if exchange rate is acceptable
    TokenExchangeRate storage rate = exchangeRates[to][classIdWanted][classIdPosted];
    require(SafeMath.mul(rate.takeAmount, quantityWanted) >= SafeMath.mul(rate.heldAmount, quantityPosted));
    // update balances
    ownerToClassToBalance[msg.sender][classIdPosted] -= quantityPosted;
    ownerToClassToBalance[to][classIdPosted] += quantityPosted;
    ownerToClassToBalance[msg.sender][classIdWanted] += quantityWanted;
    ownerToClassToBalance[to][classIdWanted] -= quantityWanted;
    // update approvals and
    approvals[msg.sender][classIdPosted].amount -= quantityPosted;
    approvals[to][classIdWanted].amount -= quantityWanted;
  }

  function transferFrom(address from, address to, uint256 classId) public {
    Transactor storage takerApproval = approvals[from][classId];
    uint256 quantity = takerApproval.amount;
    require(takerApproval.actor == to && quantity >= ownerToClassToBalance[from][classId]);
    ownerToClassToBalance[from][classId] -= quantity;
    ownerToClassToBalance[to][classId] += quantity;
    Transactor memory zeroApproval;
    zeroApproval = Transactor(address (0x0), 0);
    approvals[from][classId] = zeroApproval;
  }

  function name() public pure returns (string memory) {
    return "XS Exchange";
  }

  function className(uint256 classId) public view returns (string memory){
    return classNames[classId];
  }

  function symbol() public pure returns (string memory) {
    return "XS";
  }

  // Call this function to create own token offering
  function registerClass(string memory entityName, uint256 supply) public payable returns (bool){
    require(msg.value >= supply * minTokenPrice && supply >= minCount);
    ownerToClassToBalance[msg.sender][currentClass] = supply;
    classNames[currentClass] = entityName;
    classIdToSupply[currentClass] = supply;
    currentClass += 1;
    tokenCount += supply;
    return true;
  }
  
  
   function request(string memory label, uint amount) public returns (bool success)
    {
        //bytes32 label = sha3(_label);
        int256 id = toId[label];
        if (id > 0x0)//NOTE: id 0 reserved for any unmatched resource
        {
           ResourceDAO res = ResourceDAO(toAddress[id]);
           res.request(amount);
        }
        else
        {   // NOTE
            nresources += 1;
            ResourceDAO newres = new ResourceDAO(label,nresources);
            newres.request(amount);
            toAddress[nresources] = address(newres);
            toId[label] = nresources;
            
            emit NewResource(label);
        }
        return true;
    }
}
pragma solidity ^0.4.8;
import "./UserFactory.sol";

contract SharkCoin {
  address public owner;
  address public factoryAddress;
  uint public totalSupply;
  UserFactory public userFactory;

  mapping(address => uint256) balances;
  mapping(address => uint256) reputations;
  mapping(address => bool) gifted;

  string public constant name = "Shark Coin";
  string public constant symbol = "SHK";
  uint8 public constant decimals = 0;
  uint8 public constant signUpBonus = 100;

  function SharkCoin(uint balance) public {
    totalSupply = balance;
    owner = msg.sender;
    balances[owner] = balance;
  }

  function giftToNewUser(address newContractUser) public returns (bool success) {
    if (msg.sender != factoryAddress) {
      Error("This is defiantely cybercrime");
      return false;
    }
    if (gifted[newContractUser] == true) {
      Error("This user already got intro coins!");
      return false;
    }
    balances[newContractUser] += signUpBonus;
    gifted[newContractUser] = true;
    totalSupply += signUpBonus;

    return true;
  }

  function setUserFactory(address _factoryAddress) public returns (bool success) {
    if (msg.sender != owner) {
      Error("You are not the boss of the shark kid");
      return false;
    }
    factoryAddress = _factoryAddress;
    return true;
  }

  function getUserFactory() public constant returns (UserFactory) {
    return UserFactory(factoryAddress);
  }

  function getTotalSupply() public constant returns (uint) {
    return totalSupply;
  }

  function balanceOf(address sharkUser) public constant returns (uint balance) {
    return balances[sharkUser];
  }

  function reputationOf(address sharkUser) public constant returns (uint reputation) {
    return reputations[sharkUser];
  }

  function transfer(address to, uint tokens) public returns (bool success) {
    if (balances[msg.sender] < tokens) {
      Error("You are too poor");
      return false;
    }

    balances[msg.sender] = balances[msg.sender] - tokens;
    balances[to] = balances[to] + tokens;
    Transfer(msg.sender, to, tokens);

    return true;
  }

  function reputate(address to, uint tokens) public returns (bool success) {
    userFactory = UserFactory(factoryAddress);
    if (!userFactory.userExistsAt(to)) {
      Error("Users not in the system cannot have a reputation!");
      return false;
    }
    if (balances[msg.sender] < tokens) {
      Error("You are too poor");
      return false;
    }

    balances[msg.sender] = balances[msg.sender] - tokens;
    totalSupply -= tokens;
    reputations[to] = reputations[to] + tokens;
    Reputate(msg.sender, to, tokens);

    return true;
  }

  function loan(address to, uint principal, uint interestPercent, uint dueBlocks) public returns (bool success) {
    // Fail and return false if there is no user at the to address
    // Fail and return false if you guys are not buddies

    // Loan is created
    // Loan is probably a contract or structure with these things and that includes block it has been created at
    // When Loan is due,
  }

  event Error(string msg);
  event Transfer(address indexed from, address indexed to, uint tokens);
  event Reputate(address indexed from, address indexed to, uint tokens);

  // TODO: Add loan functionality
  /*
    Okay how do we want a loan to work?
    We can only loan to users registered by our factory
    Loans are a struct
    loan grows after some period
    every block a loan is late a peputation hit is given
    is a loan is ate it drains your account if you have money then eats your reputation

    To do this, get block number, block as a dude date, also variable for new thing
    Loan can be it's own contracts
    Takes due block, amont, interest

    perhaps give interest if things happen


    loans require mutual buddyship
  */
}

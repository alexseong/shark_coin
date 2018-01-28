pragma solidity 0.4.18;
import "./SharkCoin.sol";
import "./UserFactory.sol";

contract User {
  address public owner;
  address public governingCoin;
  UserFactory public factory;
  SharkCoin public sharkCoin;
  string public firstName;
  string public lastName;
  string public interests;
  string public bio;

  // note that these addresses are not public keys of users but instead
  mapping (address => bool) public buddies;
  // Note that this is reviews of us not not reviews we have written, these addresses represent the writer not the recipient
  mapping (address => string) public reviews;
  address[] public buddiesList;


  function User(address _owner, address _factoryAddress, address _governingCoin, string _firstName, string _lastName, string _interests, string _bio) public {
    owner = _owner;
    factory = UserFactory(_factoryAddress);
    governingCoin = _governingCoin;
    firstName = _firstName;
    lastName = _lastName;
    interests = _interests;
    bio = _bio;
  }

  function getSharkBalance() public constant returns(uint balance) {
    sharkCoin = SharkCoin(governingCoin);
    balance = sharkCoin.balanceOf(owner);
    return(balance);
  }

  function getSharkRep() public constant returns(uint reputation) {
    sharkCoin = SharkCoin(governingCoin);
    reputation = sharkCoin.reputationOf(owner);
    return(reputation);
  }

  function setFirstName(string _newName) public returns(bool) {
      if (msg.sender != owner) {
          Error("You are not the owner");
          return false;
      }
      firstName = _newName;
      FirstNameChanged(_newName);
      return true;
  }

  function setLastName(string _newName) public returns(bool) {
      if (msg.sender != owner) {
          Error("You are not the owner");
          return false;
      }
      lastName = _newName;
      LastNameChanged(_newName);
      return true;
  }

  function setInterests(string _newInterests) public returns(bool) {
      if (msg.sender != owner) {
          Error("You are not the owner");
          return false;
      }
      interests = _newInterests;
      InterestsChanged(_newInterests);
      return true;
  }

  function setBio(string _newBio) public returns(bool) {
      if (msg.sender != owner) {
          Error("You are not the owner");
          return false;
      }
      bio = _newBio;
      BioChanged(_newBio);
      return true;
  }

  function addBuddy(address newBuddy) public returns(bool) {
    if (msg.sender != owner) {
        Error("You are not the owner");
        return false;
    }

    if(buddies[newBuddy] == true) {
      Error("He is your buddy silly!");
      return false;
    }

    buddies[newBuddy] = false;
    buddiesList.push(newBuddy);
    BuddyAdded(owner, newBuddy);
    return true;
  }

  // TODO: functionality for reviews and how that might work

  event FirstNameChanged(string changedTo);
  event LastNameChanged(string changedTo);
  event InterestsChanged(string changedTo);
  event BioChanged(string changedTo);
  event BuddyAdded(address buddyAdder, address addedBuddy);
  event Error(string msg);
}

pragma solidity ^0.4.8;
import "./User.sol";
import "./SharkCoin.sol";

contract UserFactory {
  SharkCoin public sharkCoin;

  // TODO: add bool function to know who is mutual buddies

  struct Data {
    address uid;
    address contractAddress;
    bool exists;
  }
  // index of created contracts
  mapping (address => Data) public users;
  address[] public usersList;
  address public governingCoin;

  function UserFactory(address _sharkAddress) public {
    sharkCoin = SharkCoin(_sharkAddress);
  }

  // useful to know the row count in contracts index

  function getUserCount() public constant returns(uint userCount)
  {
   return usersList.length;
  }

  // deploy a new contract

  function newUser(address uid, string name, string surname, string interests, string about)
    public
    returns(bool success)
  {
    if (userExistsAt(uid)) {
      return false;
    }
    // this is a security thing as we give new users shark coin, and if they sign up a new user, we give them coins
    address u = new User(uid, address(this), sharkCoin, name, surname, interests, about);
    users[uid] = Data({
      uid: uid,
      contractAddress: u,
      exists: true
    });
    usersList.push(uid);
    sharkCoin.giftToNewUser(uid);
    AddUser(uid, u);
    return true;
  }

  function userExistsAt(address potentialUser) public constant returns (bool hasUserContract)
  {
    return users[potentialUser].exists;
  }

  function isMutualBuddies(address buddyOne, address buddyTwo) public constant returns (bool areBuddies) {
    User userOne = User(buddyOne);
    User userTwo = User(buddyTwo);
    return (userOne.buddies(buddyTwo) && userTwo.buddies(buddyOne));
  }

  function isMutualBuddiesEthAddress(address buddyOne, address buddyTwo) public constant returns (bool areBuddies) {
    address userOneContractAddress = users[buddyOne].contractAddress;
    address userTwoContractAddress = users[buddyTwo].contractAddress;
    User userOne = User(userOneContractAddress);
    User userTwo = User(userTwoContractAddress);
    return (userOne.buddies(userTwoContractAddress) && userTwo.buddies(userOneContractAddress));
  }

  event AddUser(address uid, address u);
}

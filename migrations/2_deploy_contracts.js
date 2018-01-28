"use strict";

const UserFactory = artifacts.require('./UserFactory.sol');
const SharkCoin = artifacts.require('./SharkCoin.sol');

/**
 * @param deployer object : The thing that can deploy contracts
 * @param network  string : Network name, e.g. "live" or "development"
 * @param accounts  array : Array with accounts addresses
 */
module.exports = async (deployer, network, accounts)=> {
    deployer.deploy(SharkCoin, 1000)
      .then(() => SharkCoin.deployed())
      .then(sharkInstance => {
        return deployer.deploy(UserFactory, sharkInstance.address);
      });

    const uf = await UserFactory.deployed();
    console.log(`Example contract address: ${UserFactory.address}`);
};

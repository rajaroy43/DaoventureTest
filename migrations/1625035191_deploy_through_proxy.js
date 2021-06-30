const { deployProxy } = require('@openzeppelin/truffle-upgrades');
const CarSelling = artifacts.require('CarSelling');

module.exports = async function(deployer,network,accounts) {
  // Use deployer to state migration tasks.
  const instance = await deployProxy(CarSelling, [accounts[0]], { deployer });
  console.log('Deployed', instance.address);
};

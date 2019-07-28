const Kyc = artifacts.require('./kyc.sol');

module.exports = function(deployer, network, accounts) {

    return deployer
        .then(() => {
            return deployer.deploy(
                Kyc
            );
        });
};
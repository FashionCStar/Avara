const AvaraNft = artifacts.require("AvaraNft");
const OwnershipModule = artifacts.require("OwnershipModule")
// Avara.owner()     0x279202a23614e9f8c6b3ab43ebbe4ab0c3f0ec88 
// Avara.address  0x8337b6FE7A3198FB864FfbDE97dda88cfDCCbd96
// AVAR Holder:    0x8effc4e9b5e43d46a5667775c549309c98d58e2b
module.exports = async function (deployer, network, accounts) {
	let res;
	let cOwner = '0x279202a23614e9f8c6b3ab43ebbe4ab0c3f0ec88'
	let baseContract = '0x8337b6FE7A3198FB864FfbDE97dda88cfDCCbd96'
	await deployer.deploy(AvaraNft, "AVARANFT", "ANFT");
	await deployer.deploy(OwnershipModule, cOwner, baseContract, AvaraNft.address)
};

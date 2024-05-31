require('chai')
    .use(require('chai-as-promised'))
    .should()

const {assert} = require('chai')

const AvaraNft = artifacts.require("AvaraNft");
const OwnershipModule = artifacts.require("OwnershipModule")

const avaraAddress = '0x8337b6fe7a3198fb864ffbde97dda88cfdccbd96'
const avaraABI = require('../ABI/avara.js')

contract('Marketplace Contract', (accounts) => {
    before(async() => {
        avaraNft = await AvaraNft.deployed()
        ownershipModule = await OwnershipModule.deployed()
        avaraHolder = '0x8effc4e9b5e43d46a5667775c549309c98d58e2b'
        avara = new web3.eth.Contract(avaraABI, avaraAddress)
    })
    it('selling nft', async() => {
        await avaraNft.mint('test data')
        await avaraNft.mint('test data')
        await avaraNft.mint('test data')
        res = await avaraNft.nftIdPointer()
        assert.equal(res, 3, 'token id correct')

        await ownershipModule.selling(0, web3.utils.toWei('1', 'Gwei'))
        res = await ownershipModule.sellNftList(0)
        assert.equal(res.price, web3.utils.toWei('1', 'Gwei'), 'sell price')
        assert.equal(res.seller, accounts[0], 'seller address')
    })
    it('buying', async() => {
        await web3.eth.sendTransaction(
            {
                from: accounts[0],
                to: avaraHolder,
                value: '1000000000000000'
            }
        )
        await avara.methods.approve(ownershipModule.address, web3.utils.toWei('10', 'Gwei')).send({from: avaraHolder})
        await ownershipModule.buying(0, {from: avaraHolder})


    })
})
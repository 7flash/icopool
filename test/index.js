const expect = require("chai")
  .use(require("chai-as-promised"))
  .use(require("chai-bignumber")(web3.BigNumber))
  .expect;

const Token = artifacts.require('./Token.sol')
const Tokensale = artifacts.require('./Tokensale.sol')
const Pool = artifacts.require('./Pool.sol')

contract("Pool", function(accounts) {
  before(async() => {
    token = await Token.new()
    tokensale = await Tokensale.new()
    await tokensale.setToken(token.address)

    pool = await Pool.new(
      token.address,
      tokensale.address,
      0,
      9999999999999999999,
      1,
      1000,
      1000
    )
  })

  describe('Funding', () => {
    it('should process payments', async () => {
      await pool.sendTransaction({ from: accounts[1], value: 100 })
      const stageAfterFirstPayment = await pool.getCurrentStateId()

      await pool.sendTransaction({ from: accounts[2], value: 900 })
      const stageAfterSecondPayment = await pool.getCurrentStateId()

      const balance = await pool.balances(accounts[1])

      expect(await pool.balances(accounts[1])).to.be.bignumber.equal(100)
      expect(await pool.balances(accounts[2])).to.be.bignumber.equal(900)

      await pool.conditionalTransitions()
      const stageAfterTransition = await pool.getCurrentStateId()

      expect(web3.toUtf8(stageAfterFirstPayment)).to.be.equal("funding")
      expect(web3.toUtf8(stageAfterSecondPayment)).to.be.equal("funding")
      expect(web3.toUtf8(stageAfterTransition)).to.be.equal("distribution")

      expect(await token.totalSupply()).to.be.bignumber.equal(1000)
      expect(await token.balanceOf(pool.address)).to.be.bignumber.equal(1000)
    })
  })

  describe('Distribution', () => {
    it('should allow to withdraw tokens', async () => {
      await pool.withdrawTokens({ from: accounts[1] })

      expect(await token.balanceOf(pool.address)).to.be.bignumber.equal(900)
      expect(await token.balanceOf(accounts[1])).to.be.bignumber.equal(100)
    })
  })
})

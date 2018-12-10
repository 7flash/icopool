const Token = artifacts.require("Token")
const Tokensale = artifacts.require("Tokensale")
const Pool = artifacts.require("Pool")

const context = require("../context.json")

let tokenInstance;
let tokensaleInstance;
let poolInstance;

module.exports = function(deployer, network, accounts) {
  const { fundingStart, fundingEnd, minFunding, maxFunding, minTokens } = context

  deployer.then(function() {
    return deployer.deploy(Token)
  }).then(function() {
    return Token.deployed()
  }).then(function(token) {
    tokenInstance = token

    return deployer.deploy(Tokensale)
  }).then(function() {
    return Tokensale.deployed()
  }).then(function(tokensale) {
    tokensaleInstance = tokensale

    return tokensaleInstance.setToken(tokenInstance.address)
  }).then(function() {
    return deployer.deploy(Pool,
      tokenInstance.address, tokensaleInstance.address,
      fundingStart, fundingEnd, minFunding, maxFunding, minTokens
    )
  })
}

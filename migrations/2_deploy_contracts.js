const Token = artifacts.require("Token")
const Tokensale = artifacts.require("Tokensale")
const Pool = artifacts.require("Pool")

const context = require("../context.json")

let tokenInstance;
let tokensaleInstance;
let poolInstance;

module.exports = function(deployer, network, accounts) {
  let poolArgs = [
    context.fundingStart,
    context.fundingEnd,
    context.minFunding,
    context.maxFunding,
    context.minTokens
  ]

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
    poolArgs.unshift(tokenInstance.address)
    poolArgs.unshift(tokensaleInstance.address)

    return deployer.deploy(Pool, ...poolArgs)
  })
}

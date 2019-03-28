const Barter = artifacts.require("Barter");

const utils = require("../js/utils.js");
const assertFail = require("./helpers/assertFail");

contract("PollManager", (accounts) => {
    let barter;
    it("should create barter contract", async () => {
        barter = await Barter.new();
    });
});

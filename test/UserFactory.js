"use strict";

const Reverter = require('./helpers/reverter');
const { asserts, reverts, equal } = require('./helpers/asserts');

const UserFactory = artifacts.require('./UserFactory');


contract('UserFactory', function(accounts) {

    // And this thing is used to make snapshots of test network state
    // and return to the latest `snapshot` with `revert` method, to keep
    // things clear afterEach test.
    // It's not related to the Solidity revert!
    const reverter = new Reverter(web3);

    const OWNER = accounts[0];
    const NON_OWNER = accounts[1];

    let userFactory;

    afterEach('revert', reverter.revert);  // Reset test network state to the latest `snapshot`

    before('setup', async () => {
        userFactory = await UserFactory.deployed();
        await reverter.snapshot();  // Create first `snapshot` before all tests
    });


    describe("User Factory", () => {

        it("should create a user", async () => {
            const result = await userFactory.newUser.call(accounts[0], 'Travis','Sean','Alex','Austin');
            assert.isTrue(result);
        });

        it("log user addess", async () => {
            const result = await userFactory.newUser(accounts[0], 'Travis','Sean','Alex','Austin');
            console.log(result);
        });

        it("should not create a user based on a false address", async () => {
            const result = await userFactory.newUser.call(0, 'Travis','Sean','Alex','Austin');
            assert.isTrue(result);
        });

    });

});

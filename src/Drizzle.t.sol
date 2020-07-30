pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "./Drizzle.sol";

contract DrizzleTest is DSTest {
    Drizzle drizzle;

    function setUp() public {
        drizzle = new Drizzle();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}

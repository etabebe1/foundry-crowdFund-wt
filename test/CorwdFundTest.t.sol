// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.24;

import {CrowdFund} from "../src/CrowdFund.sol";
import {Test, console} from "forge-std/Test.sol";

contract CrowdFundTest is Test {
    CrowdFund crowdFund;

    function setUp() external {
        crowdFund = new CrowdFund();
    }

    function testMinAmountIsFive() public view {
        assertEq(crowdFund.minAmount(), 5 * 1e18);
    }

    function testCrowdFundOwner() public view {
        assertEq(crowdFund.i_owner(), address(this));
    }

    // In the function bellow we're calling a function outside of our contract
    // Therefore, what con we do
    // 1. Unit
    //  - Testing specific part of our code
    // 2. Integration
    //  -Testing how our code works with part of our code
    // 3. Forked
    //  - Testing how our code on a simulated real environment
    // 4. Staging
    //  - Testing how our code on a real environment but not live (prod)
    function testPriceFeedVersion() public view {
        uint256 version = crowdFund.getVersion();
        assertEq(version, 4);
    }
}

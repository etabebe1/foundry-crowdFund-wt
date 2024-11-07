// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.24;

import {CrowdFund} from "../src/CrowdFund.sol";
import {DeployCrowdFund} from "../script/DeployCrowdFund.s.sol";
import {Test, console} from "forge-std/Test.sol";

contract CrowdFundTest is Test {
    CrowdFund crowdFund;

    address priceFeedAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

    function setUp() external {
        // crowdFund = new CrowdFund(priceFeedAddress);
        DeployCrowdFund deployCrowdFund = new DeployCrowdFund();
        crowdFund = deployCrowdFund.run();
    }

    function testMinAmountIsFive() public view {
        assertEq(crowdFund.minAmount(), 5 * 1e18);
    }

    function testCrowdFundOwner() public view {
        assertEq(crowdFund.i_owner(), msg.sender);
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

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.24;

import {CrowdFund} from "../src/CrowdFund.sol";
import {DeployCrowdFund} from "../script/DeployCrowdFund.s.sol";
import {Test, console} from "forge-std/Test.sol";

contract CrowdFundTest is Test {
    CrowdFund crowdFund;

    address USER = makeAddr("user"); // prank address
    uint256 SEND_VALUE = 10e18;
    uint256 USER_START_BALANCE = 50 ether;

    function setUp() external {
        // crowdFund = new CrowdFund(priceFeedAddress);
        DeployCrowdFund deployCrowdFund = new DeployCrowdFund();
        crowdFund = deployCrowdFund.run();
        vm.deal(USER, USER_START_BALANCE);
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
        assertEq(version, 4); // on Mainnet - v = 6 and Sepolia or Anvil v = 4
    }

    function testFundFailsWitoutEnoughEth() public payable {
        vm.expectRevert("Minimum amount to send is 5"); // Expecting revert for the next line
        // crowdFund.fund{value: SEND_VALUE}(); // Trying to fund with > minAmount of ETH
        crowdFund.fund{value: 0}(); // Tryying to send no value //results failing
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // Means next TX will be sent by USER
        crowdFund.fund{value: SEND_VALUE}();
        uint256 amountFunded = crowdFund.getAdressToAmountFunded(USER);

        assertEq(amountFunded, SEND_VALUE);
        console.log(amountFunded);
    }
}

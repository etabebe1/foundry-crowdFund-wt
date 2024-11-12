// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.24;

import {CrowdFund} from "../src/CrowdFund.sol";
import {DeployCrowdFund} from "../script/DeployCrowdFund.s.sol";
import {Test, console} from "forge-std/Test.sol";

contract CrowdFundTest is Test {
    CrowdFund crowdFund;

    address USER = makeAddr("user");

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
        assertEq(version, 4); // on Mainnet - v = 6 and Sepolia or Anvil v = 4
    }

    function testFundFailsWitoutEnoughEth(uint256 amount) public {
        vm.expectRevert("Minimum amount to send is 5"); // Meaning we expect the next TX will likely fail
        crowdFund.fund{value: 0}(); //sending 0 ETH making it to fail
        // crowdFund.fund{value: 0}();
    }

    function testFundFailsWitoutEnoughEth() public {
        vm.expectRevert("Minimum amount to send is 5"); // Expecting revert with this exact message
        // crowdFund.fund{value: 0}(); // Trying to fund with 0 ETH
        crowdFund.fund(); // Tyrying to send no value //results failing
    }

    // function testFundUpdatesFundedDataStructure() public {
    //     vm.prank(USER);

    //     crowdFund.fund{value: 10e18}();

    //     uint256 amountFunded = crowdFund.getAdressToAmountFunded(USER);
    //     assertEq(amountFunded, 10e18);
    // }
}

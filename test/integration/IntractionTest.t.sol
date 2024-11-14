// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {console} from "../../lib/forge-std/src/console.sol";
import {Test} from "../../lib/forge-std/src/Test.sol";
import {CrowdFund} from "../../src/CrowdFund.sol";
import {DeployCrowdFund} from "../../script/DeployCrowdFund.s.sol";
import {FundCrowdFund, WithdrawCrowdFund} from "../../script/Interaction.s.sol";

contract InteractionsTest2qap is Test {
    CrowdFund crowdFund;

    address USER = makeAddr("user"); // prank address
    uint256 SEND_VALUE = 10e18;
    uint256 USER_START_BALANCE = 50 ether;

    function setUp() public {
        // deploy contract
        DeployCrowdFund deployCrowdFund = new DeployCrowdFund();
        crowdFund = deployCrowdFund.run();
        vm.deal(USER, USER_START_BALANCE);
    }

    function testUserCanFundIntractions() public {
        FundCrowdFund fundCrowdFund = new FundCrowdFund();
        fundCrowdFund.fundCrowdFund(address(crowdFund));
        // fund interactions

        WithdrawCrowdFund withdrawCrowdFund = new WithdrawCrowdFund();
        withdrawCrowdFund.withdrawCrowdFund(address(crowdFund));

        assertEq(address(crowdFund).balance, 0);
    }
}

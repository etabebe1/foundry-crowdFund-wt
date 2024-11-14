// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {CrowdFund} from "../src/CrowdFund.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";

// 0x79e012DD0141FC53cd769B9a5e0CE50e8a56576E latest

contract FundCrowdFund is Script {
    uint256 constant SEND_VALUE = 0.1 ether;

    function fundCrowdFund(address mostRecentlyDeployed) public {
        CrowdFund(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();

        console.log("Funded CrowdFund with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "CrowdFund",
            block.chainid
        );

        console.log(mostRecentDeployed);

        vm.startBroadcast();
        fundCrowdFund(mostRecentDeployed);
        vm.stopBroadcast();
    }
}

contract WithdrawCrowdFund is Script {
    function withdrawCrowdFund(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        CrowdFund(payable(mostRecentlyDeployed)).withdarw();
        vm.stopBroadcast();

        console.log("Withdraw CrowdFund balance!");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "CrowdFund",
            block.chainid
        );
        withdrawCrowdFund(mostRecentlyDeployed);
    }
}

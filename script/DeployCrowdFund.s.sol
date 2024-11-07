// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {CrowdFund} from "../src/CrowdFund.sol";

contract DeployCrowdFund is Script {
    function run() external {
        vm.startBroadcast();
        new CrowdFund();
        vm.stopBroadcast();
    }
}

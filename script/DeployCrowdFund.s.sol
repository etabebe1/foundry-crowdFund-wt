// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {CrowdFund} from "../src/CrowdFund.sol";

contract DeployCrowdFund is Script {
    address priceFeedAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

    function run() external returns (CrowdFund) {
        vm.startBroadcast();
        CrowdFund crowdFund = new CrowdFund(priceFeedAddress);
        vm.stopBroadcast();
        return crowdFund;
    }
}

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {CrowdFund} from "../src/CrowdFund.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployCrowdFund is Script {
    // address priceFeedAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

    function run() external returns (CrowdFund) {
        HelperConfig helperConfig = new HelperConfig();
        (address priceFeedAddress, address priceFeedAddress2) = helperConfig
            .activeNetworkConfig(); // get the price feed address from the config

        vm.startBroadcast();
        CrowdFund crowdFund = new CrowdFund(priceFeedAddress);
        vm.stopBroadcast();
        return crowdFund;
    }
}

// contract DeployCrowdFund is Script {
//     address priceFeedAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

//     function run() external returns (CrowdFund) {
//         HelperConfig helperConfig = new HelperConfig(priceFeedAddress);
//         address ethUsdPriceFeed = helperConfig.activeNetworkConfig();

//         vm.startBroadcast();
//         console.log(ethUsdPriceFeed);
//         CrowdFund crowdFund = new CrowdFund(ethUsdPriceFeed);
//         vm.stopBroadcast();
//         return crowdFund;
//     }
// }

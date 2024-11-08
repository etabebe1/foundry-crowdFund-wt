// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {CrowdFund} from "../src/CrowdFund.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployCrowdFund is Script {
    //-> ETH/USD PriceFeedAddress
    address priceFeedAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306; // Sepolia
    address priceFeedAddressMainnet =
        0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419; //Mainnet

    function run() external returns (CrowdFund) {
        HelperConfig helperConfig = new HelperConfig(priceFeedAddressMainnet);
        address ethPriceAddrFromHelperConfig = helperConfig
            .activeNetworkConfig(); // get the price feed address from the config

        console.log(ethPriceAddrFromHelperConfig);

        vm.startBroadcast();
        CrowdFund crowdFund = new CrowdFund(ethPriceAddrFromHelperConfig);
        vm.stopBroadcast();
        return crowdFund;
    }
}

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

// This file will
// 1. Deploy mocks when we are on a local anvil chian
// 2. Keep track of contract address accross different chains
// Sepolia ETH/USD !== Mainnet ETH/USD (Addresses)

contract HelperConfig {
    // If we are on a local anvil, we deploy mock
    // Otherwise, grap the existing address from the live network

    NetworkConfig public activeNetworkConfig;

    // an object we need form sepolia test net
    struct NetworkConfig {
        address priceFeedAddress;
    }

    constructor() {
        // if we are on a local anvil, deploy mock
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getSepoliaEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // we need to get the price feed address from sepolia
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeedAddress: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaConfig;
    }

    function getAnvilEthConfig() public pure {}
}

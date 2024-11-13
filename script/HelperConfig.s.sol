// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

// This file will
// 1. Deploy mocks when we are on a local anvil chian
// 2. Keep track of contract address accross different chains
// Sepolia ETH/USD !== Mainnet ETH/USD (Addresses)

import {Script, console} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockAggregatorV3.sol";

contract HelperConfig is Script {
    // If we are on a local anvil, we deploy mock
    // Otherwise, grap the existing address from the live network
    NetworkConfig public activeNetworkConfig;
    uint8 public constant _decimal = 18;
    int256 public constant _initalAnswer = 2800;

    // an object we need form sepolia test net
    struct NetworkConfig {
        address priceFeedAddress;
    }

    constructor(address priceFeedAddress) {
        // if we are on a local anvil, deploy mock
        if (block.chainid == 11155111) {
            // Sepolia
            activeNetworkConfig = getSepoliaNetwork(priceFeedAddress);
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetNetwork(priceFeedAddress);
        } else {
            // Anvil
            activeNetworkConfig = getOrCreateAnvilNetwork();
        }
    }

    function getSepoliaNetwork(
        address _priceFeedAddress
    ) public pure returns (NetworkConfig memory) {
        // we need to get the price feed address from sepolia
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeedAddress: _priceFeedAddress
        });

        return sepoliaConfig;
    }

    function getMainnetNetwork(
        address _priceFeedAddress
    ) public pure returns (NetworkConfig memory) {
        // we need to get the price feed address from sepolia
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeedAddress: _priceFeedAddress
        });

        return sepoliaConfig;
    }

    // TODO: Check getOrCreateAnvilNetwork function it's not running properly on a local anvil chain
    function getOrCreateAnvilNetwork() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeedAddress != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            _decimal,
            _initalAnswer
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeedAddress: address(mockPriceFeed)
        });

        return anvilConfig;
    }
}

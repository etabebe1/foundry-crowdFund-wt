// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from
    "../lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConvertor {
    function getEthPrice(AggregatorV3Interface priceFeed) public view returns (int256) {
        (, int256 answer,,,) = priceFeed.latestRoundData();
        return (answer * 1e10);
    }

    function getConversionRate(int256 minValue, AggregatorV3Interface priceFeed) public view returns (int256) {
        int256 currentEthPrice = getEthPrice(priceFeed);
        int256 ethAmount = (currentEthPrice * minValue) / 1e18;
        return ethAmount;
    }

    function getVersion(AggregatorV3Interface priceFeed) public view returns (uint256) {
        return priceFeed.version();
    }
}

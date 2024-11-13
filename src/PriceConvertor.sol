// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from
    "../lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {console} from "forge-std/console.sol";

library PriceConvertor {
    function getEthPrice(AggregatorV3Interface priceFeed) public view returns (int256) {
        (, int256 answer,,,) = priceFeed.latestRoundData();
        return (answer * 10000000000);
    }

    function getConversionRate(int256 minValue, AggregatorV3Interface priceFeed) public view returns (int256) {
        int256 currentEthPrice = getEthPrice(priceFeed);
        int256 ethAmount = (currentEthPrice * minValue) / 1000000000000000000;
        // console.log("ethAmount:", ethAmount);
        // console.log("ethAmount:", minValue); //min amount of Eth must be sent to see this

        return ethAmount;
    }

    function getVersion(AggregatorV3Interface priceFeed) public view returns (uint256) {
        return priceFeed.version();
    }
}

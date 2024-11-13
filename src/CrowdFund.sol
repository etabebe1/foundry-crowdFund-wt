// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {PriceConvertor} from "./PriceConvertor.sol";
import {AggregatorV3Interface} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {console} from "forge-std/console.sol";

error CrowdFund_NotOwner();

contract CrowdFund {
    using PriceConvertor for int256;

    // constants and immutable - keywords to reduce txCost
    address private immutable i_owner;
    int256 public constant minAmount = 5 * 10 ** 18;

    address[] public s_listOfFunders;
    mapping(address => uint256) public s_funderToAmountRaised;

    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function fund() public payable {
        // Ensure that the conversion rate is in the correct unit and is greater than the minimum amount
        int256 conversionRate = int256(msg.value).getConversionRate(
            s_priceFeed
        );

        // console.log("conversion rate:", conversionRate);

        require(conversionRate > minAmount, "Minimum amount to send is 5");

        s_listOfFunders.push(msg.sender);
        s_funderToAmountRaised[msg.sender] =
            s_funderToAmountRaised[msg.sender] +
            msg.value;
    }

    function getVersion() public view returns (uint256) {
        return PriceConvertor.getVersion(s_priceFeed);
    }

    function withdarw() public onlyOwner {
        for (uint256 funder = 0; funder < s_listOfFunders.length; funder++) {
            address funderAddress = s_listOfFunders[funder];
            s_funderToAmountRaised[funderAddress] = 0;
        }

        s_listOfFunders = new address[](0);

        // msg.sender = address
        // payable(msg.sender) = pyable address
        // transfer - automatically reverts if transaction failed
        // payable(msg.sender).transfer(address(this).balance);
        // send - reverts if we add error handling mechanism like (require)
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "send failed");
        // call - returns a bool and byte code ()
        (bool txSent, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(txSent, "send failed");
        // which one to choose call
    }

    modifier onlyOwner() {
        // require(msg.sender == owner, "Only owner can call this functoin");
        if (msg.sender != i_owner) {
            revert CrowdFund_NotOwner();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    // View | Pure function as (Getter)

    function getAdressToAmountFunded(
        address fundingAddress
    ) external view returns (uint256) {
        return s_funderToAmountRaised[fundingAddress];
    }

    function getAddressOfFunder(
        uint256 _index
    ) external view returns (address) {
        return s_listOfFunders[_index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}

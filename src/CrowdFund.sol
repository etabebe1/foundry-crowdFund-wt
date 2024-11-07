// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {PriceConvertor} from "./PriceConvertor.sol";
import {AggregatorV3Interface} from
    "../lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error CrowdFund_NotOwner();

contract CrowdFund {
    using PriceConvertor for int256;

    // constants and immutable - keywords to reduce txCost
    address public immutable i_owner;

    // address priceFeedAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    int256 public constant minAmount = 5 * 1e18;

    address[] public listOfFunders;
    mapping(address => uint256) public funderToAmountRaised;

    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function fund() public payable {
        require(int256(msg.value).getConversionRate(s_priceFeed) > minAmount, "Minimum amount to send is 5");

        listOfFunders.push(msg.sender);
        funderToAmountRaised[msg.sender] = funderToAmountRaised[msg.sender] + msg.value;
    }

    function getVersion() public view returns (uint256) {
        return PriceConvertor.getVersion(s_priceFeed);
    }

    function withdarw() public onlyOwner {
        for (uint256 funder = 0; funder > listOfFunders.length; funder++) {
            address funderAddress = listOfFunders[funder];
            funderToAmountRaised[funderAddress] = 0;
        }

        listOfFunders = new address[](0);

        // msg.sender = address
        // payable(msg.sender) = pyable address
        // transfer - automatically reverts if transaction failed
        payable(msg.sender).transfer(address(this).balance);
        // send - reverts if we add error handling mechanism like (require)
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "send failed");
        // call - returns a bool and byte code ()
        (bool txSent,) = payable(msg.sender).call{value: address(this).balance}("");
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
}

pragma solidity ^0.5.0;

import "./SterlingCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// Inherit the crowdsale contracts
contract SterlingCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        uint rate,
        address payable wallet,
        SterlingCoin token,
        uint openingTime,
        uint closingTime,
        uint goal,
        uint cap
    )
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(cap)
        TimedCrowdsale(openingTime, closingTime)
        RefundableCrowdsale(goal)
        public
    {
        // constructor can stay empty
    }
}

contract SterlingCoinSaleDeployer {

    address public tokenSaleAddress;
    address public tokenAddress;
    uint openingTime = now;
    uint closingTime = openingTime + 24 weeks;
    uint goal = 1e5;
    uint cap = goal * 10;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet
    )
        public
    {
        // create the SterlingCoin and keep its address handy
        SterlingCoin token = new SterlingCoin(name, symbol, 0);
        tokenAddress = address(token);

        // create the SterlingCoinSale and set parameters
        SterlingCoinSale tokenSale = new SterlingCoinSale(1, wallet, token, openingTime, closingTime, goal, cap);
        tokenSaleAddress = address(tokenSale);
        
        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(tokenSaleAddress);
        token.renounceMinter();
    }
}

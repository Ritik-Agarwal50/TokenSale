// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/TokenSale.sol";
import "forge-std/Address.sol";

contract TokenSaleTest is Test {
    TokenSale public tokenSale;
    address public buyer;
    uint256 public amount;

    function setUp() public {
        // Deploy the TokenSale contract
        tokenSale = new TokenSale /* constructor arguments */();
        // Set the buyer address and amount
        buyer = Address.fromString("0x123...");
        amount = 1000;
    }

    function testContributeToPresale() public {
        // Assume that the presale is currently active
        // and the buyer has enough ETH to make the contribution
        // Also assume that the buyer has approved the TokenSale contract to spend tokens on their behalf

        // Call the contributeToPresale function
        tokenSale.contributeToPresale(amount);

        // Check that the contribution was recorded
        assertEq(
            tokenSale.tokenBalances(buyer),
            amount,
            "Contribution was not recorded"
        );
    }

    function testContributeToPublicSale() public {
        // Assume that the public sale is currently active
        // and the buyer has enough ETH to make the contribution
        // Also assume that the buyer has approved the TokenSale contract to spend tokens on their behalf

        // Call the contributeToPublicSale function
        tokenSale.contributeToPublicSale(amount);

        // Check that the contribution was recorded
        assertEq(
            tokenSale.tokenBalances(buyer),
            amount * 2,
            "Contribution was not recorded"
        );
    }

    function testDistributeTokens() public {
        // Call the distributeTokens function
        tokenSale.distributeTokens(buyer, amount);
        // Check that the tokens were distributed
        assertEq(
            tokenSale.tokenBalances(buyer),
            amount,
            "Tokens were not distributed"
        );
    }

    function testClaimRefund() public {
        // Call the claimRefund function
        tokenSale.claimRefund({from: buyer});
        // Check that the refund was processed
        assertEq(
            tokenSale.refundableEther(buyer),
            0,
            "Refund was not processed"
        );
    }

    // Add more tests as needed...
}

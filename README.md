key design choices and features:

1.Modular Imports: The contract uses OpenZeppelin contracts, including IERC20, SafeERC20, and Ownable, for standardized token functionality, safety checks, and owner control.

2.Token and Sale Parameters: The contract stores the project token (projectToken) and defines arameters for both presale and public sale, such as caps, contribution limits, and timeframes.

3.Token Distribution Mapping: The tokenBalances mapping keeps track of token balances for contributors, facilitating distribution and refund calculations.

4.Refund Tracking: The refundableEther mapping tracks the amount of ether eligible for refund for each contributor.

5.Events Logging: Events like Contribution, TokenDistribution, and Refund are emitted, providing transparency and enabling external systems to track relevant activities.

6.Modifiers for Sale Phases: Modifiers onlyDuringPresale and onlyDuringPublicSale restrict certain functions to execute only during the corresponding sale phases.

7.Constructor Initialization: The constructor initializes contract parameters, including the project token and sale details.

8.Contribution Functions: Functions contributeToPresale and contributeToPublicSale allow contributors to participate in the presale and public sale, respectively. They enforce contribution limits, cap constraints, and proper token transfers.

9.Token Distribution Function: The distributeTokens function allows the owner to distribute project tokens to a specified recipient, ensuring there are enough tokens in the contract.

10.Refund Function: Contributors can claim a refund using the claimRefund function if they have eligible refundable ether, and the refund is transferred to their address.

11.Fallback Function Restriction: The receive function is restricted to prevent accidental or malicious transfers to the contract without data, minimizing potential issues.
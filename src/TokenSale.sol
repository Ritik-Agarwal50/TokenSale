// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenSale {
    using SafeERC20 for IERC20;

    IERC20 public projectToken;

    // Presale parameters
    uint256 public presaleMaxCap;
    uint256 public presaleMinContribution;
    uint256 public presaleMaxContribution;
    uint256 public presaleEndTime;

    // Public sale parameters
    uint256 public publicSaleMaxCap;
    uint256 public publicSaleMinContribution;
    uint256 public publicSaleMaxContribution;
    uint256 public publicSaleStartTime;

    // Token distribution parameters
    mapping(address => uint256) public tokenBalances;

    // Refund tracking
    mapping(address => uint256) public refundableEther;

    event Contribution(
        address indexed contributor,
        uint256 amount,
        bool isPresale
    );
    event TokenDistribution(address indexed recipient, uint256 amount);
    event Refund(address indexed contributor, uint256 amount);

    modifier onlyDuringPresale() {
        require(block.timestamp < presaleEndTime, "Presale has ended");
        _;
    }

    modifier onlyDuringPublicSale() {
        require(
            block.timestamp >= publicSaleStartTime,
            "Public sale has not started"
        );
        require(
            block.timestamp < presaleEndTime + publicSaleStartTime,
            "Public sale has ended"
        );
        _;
    }

    constructor(
        address _projectToken,
        uint256 _presaleMaxCap,
        uint256 _presaleMinContribution,
        uint256 _presaleMaxContribution,
        uint256 _presaleEndTime,
        uint256 _publicSaleMaxCap,
        uint256 _publicSaleMinContribution,
        uint256 _publicSaleMaxContribution,
        uint256 _publicSaleStartTime
    ) {
        projectToken = IERC20(_projectToken);
        presaleMaxCap = _presaleMaxCap;
        presaleMinContribution = _presaleMinContribution;
        presaleMaxContribution = _presaleMaxContribution;
        presaleEndTime = _presaleEndTime;
        publicSaleMaxCap = _publicSaleMaxCap;
        publicSaleMinContribution = _publicSaleMinContribution;
        publicSaleMaxContribution = _publicSaleMaxContribution;
        publicSaleStartTime = _publicSaleStartTime;
    }

    function contributeToPresale(
        uint256 _amount
    ) external payable onlyDuringPresale {
        require(msg.value == _amount, "Amount mismatch");
        require(
            _amount >= presaleMinContribution,
            "Below presale minimum contribution"
        );
        require(
            _amount <= presaleMaxContribution,
            "Exceeds presale maximum contribution"
        );
        require(
            address(this).balance + _amount <= presaleMaxCap,
            "Presale cap reached"
        );

        projectToken.safeTransfer(msg.sender, _amount);
        tokenBalances[msg.sender] += _amount;
        refundableEther[msg.sender] += _amount;

        emit Contribution(msg.sender, _amount, true);
    }

    function contributeToPublicSale(
        uint256 _amount
    ) external payable onlyDuringPublicSale {
        require(msg.value == _amount, "Amount mismatch");
        require(
            _amount >= publicSaleMinContribution,
            "Below public sale minimum contribution"
        );
        require(
            _amount <= publicSaleMaxContribution,
            "Exceeds public sale maximum contribution"
        );
        require(
            address(this).balance + _amount <= publicSaleMaxCap,
            "Public sale cap reached"
        );

        projectToken.safeTransfer(msg.sender, _amount);
        tokenBalances[msg.sender] += _amount;
        refundableEther[msg.sender] += _amount;

        emit Contribution(msg.sender, _amount, false);
    }

    function distributeTokens(address _recipient, uint256 _amount) external {
        require(
            _amount <= projectToken.balanceOf(address(this)),
            "Insufficient project tokens"
        );
        projectToken.safeTransfer(_recipient, _amount);
        emit TokenDistribution(_recipient, _amount);
    }

    function claimRefund() external {
        require(refundableEther[msg.sender] > 0, "No refund available");
        uint256 refundAmount = refundableEther[msg.sender];
        refundableEther[msg.sender] = 0;
        payable(msg.sender).transfer(refundAmount);
        emit Refund(msg.sender, refundAmount);
    }

    receive() external payable {
        revert("Fallback function not allowed");
    }
}

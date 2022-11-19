// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract PoolETH is Ownable {

    struct RewardDeposit {
        uint256 reward;
        uint256 totalSupply;
        mapping(address => uint256) balances;
    }

    mapping(address => uint256) public lastWithdrawIndex;
    mapping(address => uint256) public balances;
    RewardDeposit[] public RewardDepositSnapshots;
    uint256 currentIndex;

    constructor() {}

    function balanceOf (address _user) public view returns (uint256) {
        return balances[_user];
    }

    function calculatePendingReward (address _user) public view returns (uint256) {
        uint256 reward = 0;
        for (uint256 i = lastWithdrawIndex[_user]; i < currentIndex; i++) {
            RewardDeposit storage rewardDeposit = RewardDepositSnapshots[i];
            reward += rewardDeposit.reward * rewardDeposit.balances[_user] / rewardDeposit.totalSupply;
        }
        return reward;
    }

    function deposit (uint256 _amount) external {
        RewardDeposit storage currentRewardDeposit = RewardDepositSnapshots[currentIndex];
        currentRewardDeposit.balances[msg.sender] += _amount;
        currentRewardDeposit.totalSupply += _amount;
    }

    function depositoRewards (uint256 _amount) external onlyOwner {
        RewardDeposit storage currentRewardDeposit = RewardDepositSnapshots[currentIndex];
        currentRewardDeposit.reward += _amount;
        currentIndex++;
    }

    function withdraw () external {
        uint256 pendingReward = calculatePendingReward(msg.sender);
        uint256 balance = balances[msg.sender];
        balances[msg.sender] = 0;
        lastWithdrawIndex[msg.sender] = currentIndex;
        payable(msg.sender).transfer(pendingReward + balance);
    }
}
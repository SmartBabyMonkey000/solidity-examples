// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MultiSender {
    contructor()

    function multiSender(address token, address sender, address[] memory receivers, uint256[] memory amounts) public {
        require(token != address(0));

        for(uint256 i = 0; i < receivers.length; i++) {
            IERC20(token).transfer(sender, receivers[i], amounts[i]);
        }
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AToken is ERC20, Ownable {
    constructor() ERC20("AToken", "ATK") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}

//deployed contract address = 0x560315E8B2D4C31ac540B2dfa0DAcB043cD9b1D0
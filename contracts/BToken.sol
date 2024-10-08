// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BToken is ERC20, Ownable {
    constructor() ERC20("BToken", "BTK") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    function mint(address _to, uint256 _amount) external onlyOwner {
        _mint(_to, _amount);
    }
}

// deployed contract address = 0x1d89194AD3698643e2f8093731D2c5691eAC726F
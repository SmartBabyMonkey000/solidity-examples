// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "./interfaces/ITTNDEXERC20.sol";
import "./libraries/SafeMath.sol";

contract TTNDEXERC20 is ITTNDEXERC20 {
    using SafeMath for uint;

    string public constant override name = 'TTNDEX LPs';
}
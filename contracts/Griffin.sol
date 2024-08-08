// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../../phoenixv3/RewardManagementV3.sol";
import "./GriffinNFT.sol";

contract Griffin in Ownable {
    using SafeMath for uint256;

    struct CandidateInfo {
        address user;
        uint256 tokenId;
        uint256 remainCount;
    }

    struct WinnerInfo {
        address user;
        uint256 createTime;
    }

    event BuyNFT(address sender, uint256 nCount);
    event SetPeriodTime(address sender, uint256 period);
    event SetMaxOrderCount(address sender, uint256 count);
    event SetNFTPrice(address sender, uint256 newPrice1, uint256 newPrice2, uint256 newPrice3, uint256 newPrice4, uint256 newPrice5);
    event SetContractStatus(address sender, uint256 _newPauseContract);
    event SetGriffinFee(address sender, uint256 griffineFee);
    event SetTierCount(address sender, uint256 tier1, uint256 tier2, uint256 tier3, uint256 tier4, uint256 tier5);
    event SetWinnerCountPerTier(address sender, uint256 winner1, uint256 winner2, uint256 winner3, uint256 winner4, uint256 winner5);

    event SetTeamWallet(address sender, address wallet);
    event SetWinnerWallet(address sender, address wallet);
    event SetMaintenanceWallet(address sender, address wallet);
    event SetRoyaltyFee(address sender, uint256 winnerFee, uint256 teamFee);
    event AllGriffinFee(address sender, uint256 nCount);
    event TokenGriffinFee(address sender, uint256 tokenId, uint256 nCount);
    event ChangeTier(address sender, uint256 nTier);
    event SetBackendWallet(address sender, address wallet);
    event SetMinRepeatCount(address sender, uint256 minCount);

    event Received(address sender, uint256 value);
    event Fallback(address sender, uint256 value);

    uint256[5] _tierCount;

    uint256 pauseContract           = 0;
    uint256 MAX_ORDER_COUNT         = 20;
    uint256 ONE_PERIOD_TIME         = 7 * 86400;
    uint256 ONETINE_GRIFFIN_FEE     = 25 * 10 ** 15;
    uint256 _nftPrice;
    uint256 _unit                   = 10 ** 18;
    uint256 _teamRoyalty            = 500;
    uint256 _winnerRoyalty          = 500;
    uint256 _minRepeatCount         = 4;
    uint256 public _nextTierLevel   = 0;
    uint256[2] public _avaxBalance;
    uint256[2] public _walletBalance;
    uint256 public _totalNFT;
    uint256 public _griffinCount;
    uint256 public _lastGriffin;

    uint256[5] _nftPrices;
    uint256[5] _winnerCountPerTier;
    uint256 nounce                  = 0;
    uint256 spanSize                = 100;
    uint256 consideringSpanIndex    = 0;
    mapping(address => bool) public _whiteList;
    uint256 public _whiteListPrice;
    uint256 public _whiteListLimit  = 10;
    mapping(address => uint256) public _whiteListCount;
    mapping(address => uint256) public _buyHistory;
    uint256 public _buyLimit;
    uint256 public _fireBird;

    



}
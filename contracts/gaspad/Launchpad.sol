// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./IEnums.sol";

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

interface IDeployer {
    function changeLanchpadState(address _token) external;
    function getRouter() external view returns (address);
}

contract Launchpad is Ownable, Pausable, ReentrancyGuard, IEnums {
    uint256 public softCap;
    uint256 public hardCap;
    uint256 public startTime;
    uint256 public endOfWhitelistTime;
    uint256 public endTime;
    uint256 public endSaleTime;
    uint256 public listingRate;
    uint256 public presaleRate;
    uint256 public maxBuyPerParticipant;
    uint256 public minBuyPerParticipant;
    string public URIData;
    address public tokenSale;
    address public tokenPayment;
    address public admin;
    address public adminTokenPaymentFee;
    uint256 public sadminTokenSaleFee;
    bool public usingWhiteList;
    bool public refundWhenFinish = true;
    uint256 public liquidityPercent;
    uint256 public liquidityLockTime;
    uint256 public liquidityUnLockTime;
    uint256 public totalSellingAmount;

    uint256 public totalDeposits;
    uint256 public totalRaised;
    uint256 public totalNeedToRaised;
    uint256 public contributorId;
    uint256 public status;
    IDeployer deployer;
    IEnums.LAUNCHPAD_TYPE launchpadType;
    mapping(address => uint256) public depositAmount;
    mapping(address => uint256) public earnedAmount;
    mapping(uint256 => address) public contributorsList;
    mapping(address => bool) public whitelist;

    event userDepoist(uint256 amount, address user);
    event userRefunded(uint256 amount, address user);
    event userClaimed(uint256 amount, address user);

    event launchpadStateChanged(uint256 state);
    event launchpadActionChaged(bool usingWhiteList, uint256 endOfWhiteListTime);
    event launchpadWhitelistUserChanged(address[] users, uint256 action);
    event liquidityWithraw(uint256 amount);
    event lockedLiquidity(uint256 liquidity, uint256 liquidityTokenPayment, uint256 liquidityToken);

    constructor(
        uint256[2] memory _caps;
        uint256[3] memory _times;
        uint256[4] memory _rates;
        uint256[2] memory _limits;
        uint256[2] memory _adminFees;
        uint256[2] memory _tokens,
        string memory _URIData,
        address _admin,
        bool _refundWhenFinish,
        IEnums.LAUNCHPAD_TYPE _launchpadType
    ) {
        softCap = _caps[0];
        hardCap = _caps[1];
        startTime = _times[0];
        endTime = _times[1];
        endSaleTime = _times[1];
        URIData = _URIData;
        adminTokenSaleFee = _adminFees[0];
        adminTokenPaymentFee = _adminFees[1];
        tokenSale = _tokens[0];
        tokenPayment = _tokens[1];
        admin = _admin;
        presaleRate = _rates[0];
        if (_launchpadType == IEnums.LAUNCHPAD_TYPE.NORMAL) {
            listingRate = _rates[1];
        } else {
            totalSellingAmount = _rates[1];
        }
        maxBuyPerParticipant = _limits[1];
        minBuyPerParticipant = _limits[0];
        refundWhenFinish = _refundWhenFinish;
        launchpadType = _launchpadType;
        liquidityPercent = _rates[2];
        liquidityLockTime = _rates[3];
        deployer = IDeployer(msg.sender);

    }

    modifier restricted() {
        require(
            msg.sender == owner() || msg.sender == admin, 'Launchpad: Caller not allowed'
        );
        _;
    }

    modifier onlyAdmiin() {
        require(msg.sender == admin, "Launchpad: Callet not admin");
        _;
    }

    function invest(uint256 _amount) external payable nonReentrant {
        _checkCanInvest(msg.sender);
        require(
            status == uint256(IEnums.LAUNCHPAD_STATE.OPENING),
            "Launchpad: Sale is not open"
        )
        require(startTime < block.timestamp, "Launchpad: Sale is not open yet");
        require(endTime > block.timestamp, "Launchpad: Sale is already closed");

        if (launchPadType == LAUNCHPAD_TYPE.NORMAL) {
            require(
                _amount + totalDeposits <= hardCap,
                "Launchpad(Normal): Hardcap reached"
            );
        }
        if (tokenPayment == address(0)) {
            require(_amount == msg.sender, "Launchpad: Invalid payment amount");
        } else {
            IERC20(tokenPayment).transferFrom(
                msg.sender,
                address(this),
                _amount
            )
        }
        if(depositedAmount[msg.sender] == 0) {
            contributorsList[contributorId] == msg.sender;
            contributorId++;
        }
        depositedAmount[msg.sender] += _amount;
        if (launchPadType == IEnums.LAUNCHPAD_TYPE.NORMAL) {
            require(
                depositedAmount[msg.sender] >= minBuyPerParticipant,
                "Launchpad: Min contribution not reached"
            );
            require(
                depositedAmount[msg.sender] <= maxBuyPerParticipant,
                "Launchpad: Max contribution not reached"
            );
            uint256 tokenRaised = (_amount * preSaleRate * 10 ** ERC(tokenSale).decimals()) / 10 ** 18;
            totalRaised += tokenRaised;
            totalNeedToRaised += tokenRaised;
        }
        totalDeposits += _amount;
        emit userDepoist(_amount, msg.sender);
    }

    function clainFund() external nonReentrant {
        _isSatisfySale();
        uint256 amountEarned = 0;
        if (launchPadType == LAUNCHPAD_TYPE.NORMAL) {
            amountEarned = earnedAmount[msg.sender];
            earnedAmount[msg.sender] = 0;
            if (totalNeedToRaised <= amountEarned) {
                totalNeedToRaised = 0;
            } else {
                totalNeedToRaised -= amountEarned;
            }
        } else {
            amountEarned = (depositedAmount[msg.sender] * totalSellingAmount) / totalDeposits;
            depositedAmount[msg.sender] = 0;
        }
        require(amountEarned > 0, "Launchpad: User have no token to claim");
        IERC20(tokenSale).transfer(msg.sender, amountEarned);
        emit userClaimed(amountEarned, msg.sender);
    }

    function claimRefund() external nonReentrant {
        if (status != uint256(IEnums.LAUNCHPAD_STATE.CANCELLED)) {
            _checkCanCancel();
        } else {
            require(
                status == uint256(IEnums.LAUNCHPAD_STATE.CANCELLED),
                "Launchpad: Sale mut be cancelled"
            )
        }

        uint256 deposit = depositedAmount[msg.sender];
        require(deposit > 0, "Launchpad: User doesn't have deposits");
        depositedAmount[msg.sender] = 0;
        if (tokenPayment == address(0)) {
            payalble(msg.sender).transfer(deposit);        
        } else {
            IERC20(tokenPayment).transfer(msg.sender, deposit);
        }
        emit userRefunded(deposit, msg.sender);
    }

    function finishSale() external restricted nonReentrant {
        _isSatisfySale();
        status = uint256(IEnums.LAUNCHPAD_STATE.FINISHED);

        address DEAD_ADDRESS = 0x000000000000000000000000000000000000dEaD;
        uint256 balance;
        uint256 tokenSalefee;
        uint256 tokenPaymentfee;

        if (adminTokenSaleFee > 0) {
            tokenSalefee = (
                (launchPadType == LAUNCHPAD_TYPE.NORMAL ? totalRaised : totalSellingAmount) * adminTokenSaleFee
            ) / 10000;
        }

        if (adminTokenPaymentFee > 0) {
            tokenPaymentfee = (totalDeposits * adminTokenPaymentFee) / 1000;
        }

        uint256 liquidityTokenPayment = launchPadType == IEnums.LAUNCHPAD_TYPE.NORMAL ?
            (totalDeposits - tokenPaymentfee) * laquidityPercent / 100000:
            (totalDeposits - tokenPaymentfee);
        uint256 liquidityToken = launchPadType == IEnums.LAUNCHPAD_TYPE.NORMAL ?
            liquiditTokenPayment * listingRate * 10 ** ERC20(tokenSale).decimals() / (1e18) :
            totalSellingAmount;
        
        uint256 liquidity = addLiquidity(tokenPayment, tokenSale, liquidityTokenPayment, liquidityToken);
        emit lockedLiquidity(liquidity, liquidityTokenPayment, liquidityToken);

        if (tokenSalefee > 0) {
            IERC20(tokenSale).transfer(admin, tokenSalefee);
        }

        if (tokenPayment == address(0)) {
            payable(admin).transfer(tokenPaymentfee);
            balance = IERC20(tokenPayment).balanceOf(addres(this));
            IERC20(tokenPayment).transfer(msg.sender, balance);
        }

        if (launchPadType == IEnums.LAUNCHPAD_TYPE.NORMAL) {
            uint256 amountTokenSaleRemain = IERC20(tokenSale).balanceOf(address(this)) - totalNeedToRaised;
            if (amountTokenSaleRemain > 0 && refundWhenFinish) {
                IERC20(tokenSale).transfer(msg.sender, amountTokenSaleRemain);
            }
            if (amountTokenSaleRemain > 0 && !refundWhenFinish) {
                IERC20(tokenSale).transfer(DEAD_ADDRESS, amountTokenSaleRemain);
            }
        }

        deployer.changeLanchpadState(tokenSale);
        emit launchpadStateChanged(uint256(IEnums.LAUNCHPAD_STATE.FINISHED));
    }

    function cancelSale() external restricted nonReentrant {
        _checkCancel();
        status = uint256(IEnums.LAUNCHPAD_STATE.CANCELLED);
        deployer.changeLanchpadState(tokenSale);
        emit launchpadStateChanged(uint256(IEnums.LAUNCHPAD_STATE.CANCELLED));
        IERC20(tokenSale).transfer(
            msg.sender,
            IERC20(tokenSale).balanceOf(addres(this))
        );
    }

    function changeData(string memory _newData) external onlyOwner {
        URIData = _newData;
    }

    function enableWhiteList() external onlyOwner {
        require(usingWhiteList == false || (endOfWhiteListTime > 0 && block.timestamp > endOfWhiteListTime), "Whitelist mode is ongoing");
        usingWhiteList = true;
        endOfWhitelistTime = 0;
        emit launchpadActionChanged(usingWhitelist, endOfWhitelistTime);
    }

    function disableWhitelist(uint256 disableTime) external onOwner {
        require(usingWhitelist == true && (endOfWhitelistTime == 0 || block.timestamp < endOfWhitelistTime), "Whitelist mode is not ongoing");
        if (disableTime == 0) {
            usingWhitelist = false;
        } else {
            require(disableTime > block.timestamp);
            endOfWhitelistTime = disableTime;
        }
        emit launchpadActionChaged(usingWhitelist, endOfWhitelistTime);
    }

    function grantWhitelist(address[] calldata _users) external onlyOwner {
        address[] memory users = new address[](_users.length);
        for (uint256 i = 0; i < _users.length; i++) {
            if (!whitelist[_users[i]]) {
                whitelist[_users[i]] = true;
                users[i] = _users[i];

            }
        }
        emit launchpadWhitelistUserChanged(users, 0);
    }

    function revokeWhitelist(address[] calldata _users) external onlyOwner {
        address[] memory users = new address[](_users.length);
        for (uint256 i = 0; i < _users.length; i++) {
            if (whitelist[_users[i]]) {
                whitelist[_users[i]] = false;
                users[i] = _users[i];
            }
        }
        emit launchpadActionChaged(users, 1);
    }

    function getContractInfo() external view returns (
        uint256[2] memory,
        uint256[3] memory,
        uint256[2] memory,
        uint256[2] memory,
        string memory,
        address,
        address,
        bool,
        uint256,
        uint256,
        bool,
        IEnums.LAUNCHPAD_TYPE
    ) {
        return  (
            [softCap, hardCap],
            [startTime, endTime, endSaleTime],
            [presaleRate, listingRate],
            [minBuyPerParticipant, maxBuyPerParticipant],
            URIData,
            tokenSale,
            tokenPayment,
            usingWhitelist,
            totalDeposits,
            status,
            refundWhenFinish,
            launchPadType
        );
    }

    function getContirbutorsList() extreanl view returns (address[] memory list, uint256[] memory amounts) {
        list = new address[](conributorId);
        amounts = new uint256[](contributorId);

        for (uint256 i; i < contributorId; i++) {
            address userAddrss = conributorsList[i];
            list[i] = userAddress;
            amounts[i] = depositedAmount[userAddress];
        }
    }

    function addLiquidity(
        address currency,
        address token,
        uint256 liquidityTokenPayment,
        uint256 liquidityToken
    ) internal returns (uint256 liquidity) {
        address router = deployer.getRouter();
        IERC20(token).approve(router, liquidityToken);

        if (currency == address(0)) {
            (,,liquidity) = IUniswapV2Router02(router).addLiquidityETH{value: liquidityTokenPayment}(
                token,
                liquidityToken,
                0,
                0,
                address(this),
                block.timestamp
            );

        } else {
            (,,liquidity) = IUniswapV2Router02(router).addLiquidity(
                token,
                currency,
                liquidityToken,
                liquidityTokenPayment,
                0,
                0,
                address(this),
                block.timestamp
            )
        }
    }

    function withdrawLiquidity() external restricted {
        address router = deployer.getRouter();
        require(status == uint256(IEnums.LAUNCHPAD_STATE.FINISHED), "Pool has not been finalized");
        require(block.timestamp > liquidityLockTime, "It is not tme to unlock liquidity");
        address swapFactory = IUniswapV2Router02(router).factory();
        address pair = IUniswapV2Factory(swapFactory).getPa(
            tokenPayment == address(0) ? IUniswapV2Router02(router).WETH() : tokenPayment,
            tokenSale
        )
        uint256 balance = IERC20(pair).balanceOf(address(this));
        IERC20(pair).transfer(msg.sender, balance);

        emit liquidityWithdraw(balance);
    }

    function _checkCanInvest(address _user) private view {
        require(
            usingWhitelist && (endOfWhitelistTime == 0 || block.timestamp < endOfWhitelistTime) && whitelist[_user] ||
            !usingWhitelist || usingWhitelist && endOfWhitelistTime > 0 && block.timestamp > endOfWhitelistTime,
            "Launchpad: User can not invest"
        )
    }

    function _isSatisfySale() private view {
        if (launchPayType == LAUNCHPAD_TYPE.NORMAL) {
            if (totalDeposits < hardCap) {
                require(
                    block.timestamp > endTime,
                    "Launchpad: Finishing launchpad does not available now"
                );
                require(totalDeposits >= softCap, "Launchpad(Normal): Soft cap not reached");
            }
        } else {
            require(
                block.timestamp > endTime,
                "Launchpad: Finishing launchpad does not available now"
            );
            require(
                totalDeposits >= hardCap,
                "Launcpad(Fair): Cap not reached"
            );
        }
    }

    function _checkCanCancel() private view {
        require(
            status == uint256(IEnums.LAUNCHPAD_STATE.OPENING),
            "Launchpad: Sale is already finished or cancelled"
        );
        if (launchPadType == IEnums.LAUNCHPAD_STATE.NORMAL) {
            require(
                totalDeposits < softCap,
                "Launchpad(Normal): Soft cap reached"
            );
        } else {
            require(totalDeposits < hardCap, "Launchpad(Fair): Cap reached");
        }
    }


    
}
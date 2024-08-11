// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./Launchpad.sol";

contract LaunchpadDeployer is OwnableUpgradeable {
    uint256 public deployCost;
    address public router;

    mapping(address => address) public launchpadByToken;
    mapping(IEnums.LAUNCHPAD_TYPE => uint256) public launchpadCount;

    event launchpadDeployed(
        address launchpad,
        address deployer,
        uint256[2] _caps,
        uint256[3] _times,
        uint256[4] _rates,
        uint256[2] _limits,
        uint256[2] _adminFees,
        address[2] _tokens,
        string _URIData,
        bool _refundWhenFinish,
        IEnums.LAUNCHPAD_TYPE _launchpadType
    )

    function initialize() external initializer {
        _Ownable_init();
        deployCost = 0.001 ether;
    }

    function createLaunchpad(
        address launchpad,
        address deployer,
        uint256[2] _caps,
        uint256[3] _times,
        uint256[4] _rates,
        uint256[2] _limits,
        uint256[2] _adminFees,
        address[2] _tokens,
        string _URIData,
        bool _refundWhenFinish,
        IEnums.LAUNCHPAD_TYPE _launchpadType
    ) public payable {
        _checkCanCreateLaunch(_token[0]);
        if (_launchpadType == IEnums.LAUNCHPAD_TYPE.FAIR) {
            require(
                _caps[0] == 0 && _limits[0] == 0 && _limits[1] == 0,
                "Invalid create launch input"
            )
        }
        Launchpad newLaunchPad = new Launchpad(
            _caps,
            _times,
            _rates,
            _limits,
            _adminFees,
            _tokens,
            _URIData,
            owner(),
            _refundWhenFinish,
            _launchpadType
        );
        _sendTokenLaunchpadContract(
            _rates[0],
            _rates[1],
            _rates[2],
            _caps[1],
            _token[0],
            _adminFee[0],
            address
        );
        _updateLaunchpadData(
            _launchpadType,
            address(newLaunchPad),
            _tokens[0]
        );
        newLaunchPad.transferOwnership(msg.sender);
        payable(owner()).transfer(msg.value);

        emit launchpadDeployed(
            address(newLaunchPad),
            msg.sender,
            _caps,
            _times,
            _rates,
            _limits,
            _adminFees,
            _tokens,
            _URIData,
            _refundWhenFinish,
            _lauchpadType            
        )
    }

    function setDeployPrice(uint256 _price) external onlyOwner {
        deployCost = _price;
    }

    function changeLanchpadState(address _token) external {
        require(
            launchpadByToken[_token] == msg.sender,
            "Only launchpads can remove"
        );
        launchpadByToken[_token] = address(0);
    }

    function _checkCanCreateLaunch(addres _token) private {
        require(msg.value >= deployCost, "Not enough BNB to deploy");
        require(
            launchpadByToken[_token] == address(0),
            "Launchpad already created"
        );
    }

    function _sendTokenToLaunchContract(
        uint256 _presaleRate,
        uint256 _listingRate,
        uint256 _liquidityPercent,
        uint256 _cap,
        uint256 _tokenSale,
        uint256 _adminTokenSaleFee,
        address _launchpad,
        IEnums.LAUNCHPAD_TYPE _launchpadType
    ) private {
        if (_lauchpadType == IEnums.LAUNCHPAD_TYPE.NORMAL) {
            uint256 tokensToDistribute = (_presaleRate * cap * 10 ** ERC20(_tokenSale).decimals()) / 10 ** 18;
            uint256 tokensToLiquidty = (_listRate * _cap * _liquidityPercent / 100000 * 
                                        10 ** ERC20(_tokenSale).decimals()) / 10 ** 18
            uint256 adminTokenSaleFee = 0;
            if (_adminTokenSaleFee > 0) {
                admintTokenSaleFee = (tokensToDistribute * _adminTokenSaleFee) / 10000;
            }
            ERC20(_tokenSale).transferFrom(
                msg.sender,
                _launchpad,
                tokensToDistribute + tokensToLiquidty + adminTokenSaleFee
            )
        } else {
            uint256 _totalSellingAmount = _listingRate;
            uint256 adminTokenSaleFee = 0;
            if (_adminTokenSaleFee > 0) {
                adminTokenSaleFee = (_totalSellingAmount * _adminTokenSaleFee) / 10000;
            }
            ERC20(_tokenSale).transferFrom(
                msg.sender,
                _launchpad,
                _totalSellingAmount * 2 + adminTokenSaleFee
            );
        }
    }

    function _updateLaunchpadData(
        IEnums.LAUNCHPAD_TYPE _launcpadType,
        address _launchpad,
        address _token
    ) private {
        launchpadByToken[_token] = _launchpad;
        launchpadCount[_launchpadType]++;
    }

    function setRouter(address _router) public onlyOwner {
        router = _router;
    }

    function getRouter() external view returns(address) {
        return router;
    }

}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./Ownable.sol";
import "./IUniswapV2Router02.sol";

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external;
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract AirdropSubscription is Ownable {

  struct Subscription {
    address subscriber;
    uint256 start;
    uint256 end;
    uint8 tier;
  }

  struct Airdrop {
    address creator;
    address token;
    uint256 totalTiers;
    uint256 initialSupply;
    uint256 remainingSupply;
    uint256 start;
    uint256 end;
  }

  struct Whitelist {
    address creator;
    address token;
  }

  struct DiscountToken {
    address token;
    uint256 discountPct;
    uint256 minWethValue;
  }

  mapping(address => mapping(uint256 => bool)) public claimed;
  Airdrop[] public airdrops;

  // Iterable discountTokens
  mapping(address => bool) public isDiscountToken;
  mapping(address => uint256) public discountTokenIndex;
  DiscountToken[] public discountTokens;

  // Iterable subscriptions
  mapping(address => bool) public isSubscribed;
  mapping(address => uint256) public subscriptionIndex;
  Subscription[] public subscriptions;

  // Iterable token whitelist
  mapping(address => bool) public isWhitelisted;
  mapping(address => uint256) public whitelistIndex;
  Whitelist[] public whitelisted;

  // For swaps and checking value held
  address public uniswapV2RouterAddress;
  IUniswapV2Router02 public uniswapV2Router;

  uint256 public subscriptionDuration;
  uint256 public tier1Total = 0;
  uint256 public tier2Total = 0;
  uint256 public tier3Total = 0;
  uint256 public totalTiers = 0;
  uint256 public basePriceUsd = 10 * 10**18; // $10

  IERC20 public skpToken;
  IERC20 public usdToken;
  address[] public skpWethUsdPath;

  address public airdropManager;
  address payable public receiverA;
  address payable public receiverB;
  address payable public receiverC;

  constructor(
    address[] memory _team,
    address _skpToken,
    address _usdToken,
    uint256 _subscriptionDuration,
    address _uniswapV2RouterAddress
  ) {
    super.transferOwnership(_team[0]);
    airdropManager = (_team[0]);
    receiverA = payable(_team[1]);
    receiverB = payable(_team[2]);
    receiverC = payable(_team[3]);
    skpToken = IERC20(_skpToken);
    usdToken = IERC20(_usdToken);
    subscriptionDuration = _subscriptionDuration;
    uniswapV2Router = IUniswapV2Router02(_uniswapV2RouterAddress);

    // Store path for reuse
    skpWethUsdPath = new address[](3);
    skpWethUsdPath[0] = _skpToken;
    skpWethUsdPath[1] = uniswapV2Router.WETH();
    skpWethUsdPath[2] = _usdToken;
  }

  receive() external payable {}
  fallback() external payable {}

  /**
   * @notice Get list of addresses with expired subscriptions and return keeper-compatible payload
   * @return upkeepNeeded bool, true if upkeep is needed
   * @return performData is an abi encoded list of addresses to unsubscribe
   */
  function checkUpkeep(bytes calldata checkData) public view returns (bool, bytes memory) {
    uint256[] memory pollRange = abi.decode(checkData, (uint256[]));
    uint256 numSubs = getNumSubscriptions();
    require(pollRange[0] < numSubs, "start");
    require(pollRange[0] < pollRange[1], "range");
    uint256 pollUntil = (pollRange[1] > numSubs) ? numSubs : pollRange[1];
    address[] memory unsubscribed = new address[](pollUntil - pollRange[0]);
    uint256 index = 0;
    for (uint256 i = pollRange[0]; i < pollUntil; i++) {
      if (block.timestamp > subscriptions[i].end) {
        unsubscribed[index++] = subscriptions[i].subscriber;
      }
    }
    bool upkeepNeeded = (index > 0);
    bytes memory performData = abi.encode(unsubscribed);
    return (upkeepNeeded, performData);
  }

  /**
   * @notice Called by keeper to cleanup expired subscriptions
   * @param performData The abi encoded list of addresses to unsubscribe
   */
  function performUpkeep(bytes calldata performData) external {
    address[] memory addresses = abi.decode(performData, (address[]));
    for (uint256 i = 0; i < addresses.length; i++) {
      uint256 deleteIndex = subscriptionIndex[addresses[i]];
      require(block.timestamp > subscriptions[deleteIndex].end);
      if(subscriptions[deleteIndex].tier == 1) tier1Total -= 1;
      if(subscriptions[deleteIndex].tier == 2) tier2Total -= 1;
      if(subscriptions[deleteIndex].tier == 3) tier3Total -= 1;
      totalTiers -= subscriptions[deleteIndex].tier;
      if (deleteIndex != subscriptions.length - 1) {
        // deleting in middle - overwrite w/ last element
        subscriptions[deleteIndex] = subscriptions[subscriptions.length - 1];
        subscriptionIndex[subscriptions[deleteIndex].subscriber] = deleteIndex;
      }
      // cleanup storage space
      subscriptions.pop();
      delete subscriptionIndex[addresses[i]];
      isSubscribed[addresses[i]] = false;
    }
  }

  // AIRDROP CLAIMING FUNCTIONS
  function getClaimableTokens(address _subscriber, uint256 _airdropIndex) public view returns (string memory reason, uint256 claimableTokens) {
    if (airdrops.length == 0) return ("!airdrops", 0);
    if (subscriptions.length == 0) return ("!subs", 0);
    Airdrop memory airdrop = airdrops[_airdropIndex];
    Subscription memory subscription = subscriptions[subscriptionIndex[_subscriber]];
    if (subscription.subscriber != _subscriber) return ("nosub", 0);
    if (!isWhitelisted[airdrop.token]) return ("!WL", 0);
    if (airdrop.remainingSupply == 0) return ("!tokens", 0);
    if (claimed[_subscriber][_airdropIndex]) return ("claimed", 0);
    if (block.timestamp < airdrop.start) return ("early", 0);
    if (block.timestamp > airdrop.end) return ("late", 0);
    if (block.timestamp > subscription.end) return ("subexp", 0);
    if (subscription.start > airdrop.start) return ("subd2late", 0);
    return ("", (subscription.tier * airdrop.initialSupply) / airdrop.totalTiers);
  }

  function claimAirdrop(address _subscriber, uint256 _airdropIndex) external {
    (string memory reason, uint256 claimableTokens) = getClaimableTokens(_subscriber, _airdropIndex);
    require(bytes(reason).length == 0, reason);
    require(claimableTokens > 0);
    claimed[_subscriber][_airdropIndex] = true;
    airdrops[_airdropIndex].remainingSupply -= claimableTokens;
    IERC20(airdrops[_airdropIndex].token).transfer(_subscriber, claimableTokens);
  }

  // SUBSCRIPTION PAYMENTS
  function subscribeSKP(address _subscriber, uint8 _tier, address _discountToken, uint256 _payment) public {
    require(1 <= _tier && _tier <= 3);
    require(!isSubscribed[_subscriber]);
    require(_payment >= getPaymentSKP(_subscriber, _tier, _discountToken));

    // Pay in SKP
    skpToken.transferFrom(msg.sender, address(this), _payment);
    _subscribe(_subscriber, _tier);
  }

  function getPaymentSKP(address _subscriber, uint8 _tier, address _discountToken) public view returns (uint256) {
    uint256 amountOut = getPaymentBUSD(_subscriber, _tier, _discountToken);
    uint256 amountInMin = uniswapV2Router.getAmountsIn(amountOut, skpWethUsdPath)[0];
    uint256 amountInMinWithSlippage = (amountInMin*10080)/10000; // 80 bips 
    return amountInMinWithSlippage;
  }

  function getPaymentBUSD(address _subscriber, uint8 _tier, address _discountToken) public view returns (uint256) {
    require(1 <= _tier && _tier <= 3);
    uint256 payment;
    if (_tier == 1) payment = basePriceUsd * 100 / 100; // 1 x basePriceUsd w/ 0% discount
    if (_tier == 2) payment = basePriceUsd * 180 / 100; // 2 x basePriceUsd w/ 10% discount
    if (_tier == 3) payment = basePriceUsd * 240 / 100; // 3 x basePriceUsd w/ 20% discount
    if (_discountToken != address(0)) {
      DiscountToken memory discountToken = discountTokens[discountTokenIndex[_discountToken]];
      require(discountToken.token == _discountToken);
      address[] memory tokenWethPath = new address[](2);
      tokenWethPath[0] = discountToken.token;
      tokenWethPath[1] = uniswapV2Router.WETH();
      uint256 balance = IERC20(discountToken.token).balanceOf(_subscriber);
      if (
        balance > 0 &&
        uniswapV2Router.getAmountsOut(balance, tokenWethPath)[1] >= discountToken.minWethValue
      ) {
        payment -= ((payment * discountToken.discountPct) / 100);
      }
    }
    return payment;
  }

  function setSubscriptionDuration(uint256 _duration) external onlyOwner {
    require(_duration > 0);
    subscriptionDuration = _duration;
  }
  
  function _subscribe(address _subscriber, uint8 _tier) internal {
    isSubscribed[_subscriber] = true;
    subscriptionIndex[_subscriber] = subscriptions.length;
    if (_tier == 1) tier1Total += 1;
    if (_tier == 2) tier2Total += 1;
    if (_tier == 3) tier3Total += 1;
    subscriptions.push(Subscription(
      _subscriber,
      block.timestamp,
      block.timestamp + subscriptionDuration,
      _tier
    ));
    totalTiers += _tier;
  }

  // AIRDROP CREATIONs
  function createAirdrop(address _creator, address _token, uint256 _initialSupply, uint256 _start, uint256 _end) external {
    require(isWhitelisted[_token]);
    require(isWhitelisted[_creator]);
    require(_initialSupply > 0);
    require(_start < _end);
    require(block.timestamp <= _start);
    IERC20(_token).transferFrom(msg.sender, address(this), _initialSupply);
    airdrops.push(
      Airdrop(msg.sender, _token, totalTiers, _initialSupply, _initialSupply, _start, _end)
    );
  }

  function cleanupAirdrop(uint256 _airdropIndex) external {
    Airdrop memory airdrop = airdrops[_airdropIndex];
    require(block.timestamp < airdrop.start || airdrop.end < block.timestamp);
    require(msg.sender == airdrop.creator);
    uint256 remaining = airdrops[_airdropIndex].remainingSupply;
    airdrops[_airdropIndex].remainingSupply = 0; // prevent reentrancy
    IERC20(airdrop.token).transfer(msg.sender, remaining);
  }

  // WHITELIST MANAGEMENT
  function setWhitelist(address _creator, address _token) external onlyOwner {
    require(!isWhitelisted[_token]);
    require(!isWhitelisted[_creator]);
    isWhitelisted[_token] = true;
    isWhitelisted[_creator] = true;
    whitelistIndex[_token] = whitelisted.length;
    whitelisted.push(Whitelist(_creator, _token));
  }

  function unsetWhitelist(address _creator, address _token) external onlyOwner {
    require(isWhitelisted[_token]);
    require(isWhitelisted[_creator]);
    isWhitelisted[_token] = false;
    isWhitelisted[_creator] = false;
    uint deleteIndex = whitelistIndex[_token];
    if (deleteIndex != whitelisted.length - 1) {
      // deleting in middle - overwrite w/ last element
      whitelisted[deleteIndex] = whitelisted[whitelisted.length - 1];
      whitelistIndex[whitelisted[deleteIndex].token] = deleteIndex;
    }
    // cleanup storage space
    whitelisted.pop();
    delete whitelistIndex[_token];
  }

  // DISCOUNT TOKEN MANAGEMENT
  function setDiscountPct(address _token, uint256 _discountPct, uint256 _minWethValue) external onlyOwner {
    require(!isDiscountToken[_token]);
    require(_discountPct <= 100);
    isDiscountToken[_token] = true;
    discountTokenIndex[_token] = discountTokens.length;
    discountTokens.push(DiscountToken(
      _token,
      _discountPct,
      _minWethValue
    ));
  }

  function unsetDiscountPct(address _token) external onlyOwner {
    require(isDiscountToken[_token]);
    isDiscountToken[_token] = false;
    uint deleteIndex = discountTokenIndex[_token];
    if (deleteIndex != discountTokens.length - 1) {
      // deleting in middle - overwrite w/ last element
      discountTokens[deleteIndex] = discountTokens[discountTokens.length - 1];
      discountTokenIndex[discountTokens[deleteIndex].token] = deleteIndex;
    }
    // cleanup storage space
    discountTokens.pop();
    delete discountTokenIndex[_token];
  }

  // GENERAL MANAGEMNET
  function setBasePriceUsd(uint256 _basePriceUsd) external onlyOwner {
    basePriceUsd = _basePriceUsd;
  }

  function payoutSKP() external {
    uint256 skpTokenAmount = skpToken.balanceOf(address(this));
    skpToken.transfer(receiverA, (skpTokenAmount*67000000000000000000)/100000000000000000000);
    skpToken.transfer(receiverB, (skpTokenAmount*16500000000000000000)/100000000000000000000);
    skpToken.transfer(receiverC, (skpTokenAmount*16500000000000000000)/100000000000000000000);
  }

  function transferOwnership(address _airdropManager) public override {
    require(msg.sender == airdropManager);
    super.transferOwnership(_airdropManager);
    airdropManager = _airdropManager;
  }

  function updateReceiverAAddress(address _receiverA) external onlyOwner {
    receiverA = payable(_receiverA);
  }

  function updateReceiverBAddress(address _receiverB) external {
    require(msg.sender == _receiverB);
    receiverB = payable(_receiverB);
  }

  function updateReceiverCAddress(address _receiverC) external {
    require(msg.sender == receiverC);
    receiverC = payable(_receiverC);
  }

  // UI HELPERS / READ ONLY VIEWS
  function getNumSubscriptions() public view returns (uint256) {
    return subscriptions.length;
  }

  function getNumAirdrops() public view returns (uint256) {
    return airdrops.length;
  }

  function getNumDiscountTokens() public view returns (uint256) {
    return discountTokens.length;
  }

  function getNumWhitelisted() public view returns (uint256) {
    return whitelisted.length;
  }

  function getWhitelist() public view returns (address[] memory _creators, address[] memory _tokens) {
    _creators = new address[](whitelisted.length);
    _tokens = new address[](whitelisted.length);
    for (uint i; i < whitelisted.length; i++) {
      _creators[i] = whitelisted[i].creator;
      _tokens[i] = whitelisted[i].token;
    }
  }

  function getAllClaimableTokens(address _subscriber) public view returns (string[] memory, uint256[] memory) {
    string[] memory reasons = new string[](airdrops.length);
    uint256[] memory allClaimableTokens = new uint256[](airdrops.length);
    for (uint256 i = 0; i < airdrops.length; i++) {
      (reasons[i],allClaimableTokens[i]) = getClaimableTokens(_subscriber, i);
    }
    return (reasons, allClaimableTokens);
  }

  // Returns any stuck tokens

  function withdraw() external onlyOwner {
    (bool s,) = payable(msg.sender).call{value: address(this).balance}("");
    require(s);
  }
  function withdraw(address _token) external onlyOwner {
    IERC20(_token).transfer(msg.sender, IERC20(_token).balanceOf(address(this)));
  }
}

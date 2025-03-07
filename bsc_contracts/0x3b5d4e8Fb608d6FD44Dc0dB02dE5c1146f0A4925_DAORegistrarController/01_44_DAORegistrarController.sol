pragma solidity >=0.8.4;

import "./BaseRegistrarImpl.sol";
import "./StringUtils.sol";
import "../resolvers/Resolver.sol";
import "../registry/ReverseRegistrar.sol";
import "./interfaces/IDAORegistrarController.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "../wrapper/INameWrapper.sol";
import "./interfaces/IPriceOracle.sol";
/**
 * @dev A registrar controller for registering and renewing names at fixed cost.
 */
contract DAORegistrarController is Ownable, IDAORegistrarController {
    using StringUtils for *;
    using Address for address;

    uint256 public constant MIN_REGISTRATION_DURATION = 28 days;
    bytes32 private constant DAO_NODE = 0xb5f2bbf81da581299d4ff7af60560c0ac854196f5227328d2d0c2bb0df33e553;
        // 0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;

    BaseRegistrarImpl immutable base;
    IPriceOracle public prices;
    uint256 public immutable minCommitmentAge;
    uint256 public immutable maxCommitmentAge;
    ReverseRegistrar public immutable reverseRegistrar;
    INameWrapper public immutable nameWrapper;

    mapping(bytes32 => uint256) public commitments;

    event NameRegistered(
        string name,
        bytes32 indexed label,
        address indexed owner,
        uint256 price,
        uint256 expires
    );
    event NameRenewed(
        string name,
        bytes32 indexed label,
        uint256 cost,
        uint256 expires
    );

    constructor(
        BaseRegistrarImpl _base,
        IPriceOracle _prices,
        uint256 _minCommitmentAge,
        uint256 _maxCommitmentAge,
        ReverseRegistrar _reverseRegistrar,
        INameWrapper _nameWrapper
    ) {
        require(_maxCommitmentAge > _minCommitmentAge);

        base = _base;
        prices = _prices;
        minCommitmentAge = _minCommitmentAge;
        maxCommitmentAge = _maxCommitmentAge;
        reverseRegistrar = _reverseRegistrar;
        nameWrapper = _nameWrapper;
    }

    function setPrices(IPriceOracle _prices) public onlyOwner {
        prices = _prices;
    }
    function rentPrice(string memory name, uint256 duration)
        public
        view
        override
        returns (uint256)
    {
        bytes32 label = keccak256(bytes(name));
        return prices.price(name, base.nameExpires(uint256(label)), duration);
    }

    function valid(string memory name) public pure returns (bool) {
        return name.strlen() >= 3;
    }

    function available(string memory name) public view override returns (bool) {
        bytes32 label = keccak256(bytes(name));
        return valid(name) && base.available(uint256(label));
    }

    function makeCommitment(
        string memory name,
        address owner,
        uint256 duration,
        bytes32 secret,
        address resolver,
        bytes[] calldata data,
        bool reverseRecord,
        uint32 fuses,
        uint64 wrapperExpiry
    ) public pure override returns (bytes32) {
        bytes32 label = keccak256(bytes(name));
        if (data.length > 0) {
            require(
                resolver != address(0),
                "DAORegistrarController: resolver is required when data is supplied"
            );
        }
        return
            keccak256(
                abi.encode(
                    label,
                    owner,
                    duration,
                    resolver,
                    data,
                    secret,
                    reverseRecord,
                    fuses,
                    wrapperExpiry
                )
            );
    }

    function commit(bytes32 commitment) public override {
        require(commitments[commitment] + maxCommitmentAge < block.timestamp);
        commitments[commitment] = block.timestamp;
    }

    function register(
        string calldata name,
        address owner,
        uint256 duration,
        bytes32 secret,
        address resolver,
        bytes[] calldata data,
        bool reverseRecord,
        uint32 fuses,
        uint64 wrapperExpiry
    ) public payable override {
        uint price = rentPrice(name, duration);
        require(
            msg.value >= price,
            "DAORegistrarController: Not enough ether provided"
        );

        _consumeCommitment(
            name,
            duration,
            makeCommitment(
                name,
                owner,
                duration,
                secret,
                resolver,
                data,
                reverseRecord,
                fuses,
                wrapperExpiry
            )
        );

        uint256 expires = nameWrapper.registerAndWrapETH2LD(
            name,
            owner,
            duration,
            resolver,
            fuses,
            wrapperExpiry
        );

        _setRecords(resolver, keccak256(bytes(name)), data);

        if (reverseRecord) {
            _setReverseRecord(name, resolver, msg.sender);
        }

        emit NameRegistered(
            name,
            keccak256(bytes(name)),
            owner,
            price,
            expires
        );

        if (msg.value > price) {
            payable(msg.sender).transfer(
                msg.value - price
            );
        }
    }

    function renew(string calldata name, uint256 duration)
        external
        payable
        override
    {
        bytes32 label = keccak256(bytes(name));
        uint256 price = rentPrice(name, duration);
        require(
            msg.value >= price,
            "ETHController: Not enough Ether provided for renewal"
        );

        uint256 expires = base.renew(uint256(label), duration);

        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
        }

        emit NameRenewed(name, label, msg.value, expires);
    }

    function withdraw() public {
        payable(owner()).transfer(address(this).balance);
    }

    function supportsInterface(bytes4 interfaceID)
        external
        pure
        returns (bool)
    {
        return
            interfaceID == type(IERC165).interfaceId ||
            interfaceID == type(IDAORegistrarController).interfaceId;
    }

    /* Internal functions */

    function _consumeCommitment(
        string memory name,
        uint256 duration,
        bytes32 commitment
    ) internal {
        // Require a valid commitment (is old enough and is committed)
        require(
            commitments[commitment] + minCommitmentAge <= block.timestamp,
            "DAORegistrarController: Commitment is not valid"
        );
        // If the commitment is too old, or the name is registered, stop
        require(
            commitments[commitment] + maxCommitmentAge > block.timestamp,
            "DAORegistrarController: Commitment has expired"
        );
        require(available(name), "DAORegistrarController: Name is unavailable");

        delete (commitments[commitment]);

        require(duration >= MIN_REGISTRATION_DURATION);
    }

    function _setRecords(
        address resolver,
        bytes32 label,
        bytes[] calldata data
    ) internal {
        // use hardcoded .eth namehash
        bytes32 nodehash = keccak256(abi.encodePacked(DAO_NODE, label));
        for (uint256 i = 0; i < data.length; i++) {
            // check first few bytes are namehash
            bytes32 txNamehash = bytes32(data[i][4:36]);
            require(
                txNamehash == nodehash,
                "DAORegistrarController: Namehash on record do not match the name being registered"
            );
            resolver.functionCall(
                data[i],
                "DAORegistrarController: Failed to set Record"
            );
        }
    }

    function _setReverseRecord(
        string memory name,
        address resolver,
        address owner
    ) internal {
        reverseRegistrar.setNameForAddr(
            msg.sender,
            owner,
            resolver,
            string.concat(name, ".dao")
        );
    }
}
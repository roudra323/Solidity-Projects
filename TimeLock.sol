// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TimeLock {
    error NotOwnerError();
    error TxIdNotUniqueError(bytes32 txId);
    error TimeStampNotInRangeError(uint256 blockTimestamp, uint256 _timestamp);
    error NotQueuedError(bytes32 txId);
    error TimeStampNotPassedError(uint256 blockTimestamp, uint256 _timestamp);
    error TimeStampExpiredError(uint256 blockTimestamp, uint256 expires);
    error TxFailedError();

    event Cancel(bytes32 txId);

    event Queue(
        bytes32 txId,
        address indexed _target,
        uint256 _value,
        string _func,
        bytes _data,
        uint256 _timestamp
    );
    event Execute(
        bytes32 txId,
        address indexed _target,
        uint256 _value,
        string _func,
        bytes _data,
        uint256 _timestamp
    );

    address internal owner;
    uint256 public MIN_DELAY = 10; // 10 seconds
    uint256 public MAX_DELAY = 1000; // 1000 seconds
    uint256 public constant GRACE_PERIOD = 1000; // 1000 seconds

    mapping(bytes32 => bool) public queued;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotOwnerError();
        }
        _;
    }

    receive() external payable {}

    function getTxId(
        address _target,
        uint256 _value,
        string calldata _func,
        bytes calldata _data,
        uint256 _timestamp
    ) public pure returns (bytes32 txId) {
        return keccak256(abi.encode(_target, _value, _func, _data, _timestamp));
    }

    function queue(
        address _target,
        uint256 _value,
        string calldata _func,
        bytes calldata _data,
        uint256 _timestamp
    ) external onlyOwner {
        //create tx id
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);

        //check tx id is unique
        if (queued[txId]) {
            revert TxIdNotUniqueError(txId);
        }

        //check timestamp
        if (
            block.timestamp + MIN_DELAY > _timestamp ||
            block.timestamp + MAX_DELAY < _timestamp
        ) {
            revert TimeStampNotInRangeError(block.timestamp, _timestamp);
        }

        //queue tx
        queued[txId] = true;

        emit Queue(txId, _target, _value, _func, _data, _timestamp);
    }

    function execute(
        address _target,
        uint256 _value,
        string calldata _func,
        bytes calldata _data,
        uint256 _timestamp
    ) external payable onlyOwner returns (bytes memory) {
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
        //check the txId is queued or not
        if (!queued[txId]) {
            revert NotQueuedError(txId);
        }
        //check block.timestamp > _timestamp

        if (block.timestamp < _timestamp) {
            revert TimeStampNotPassedError(block.timestamp, _timestamp);
        }

        if (block.timestamp > _timestamp + GRACE_PERIOD) {
            revert TimeStampExpiredError(
                block.timestamp,
                _timestamp + GRACE_PERIOD
            );
        }
        /*GRACE_PERIOD: This variable defines the amount of time allowed
         after the scheduled execution time for a transaction
          to be executed before it is considered expired.
           If the current timestamp is greater than the scheduled execution
            time plus GRACE_PERIOD, then the transaction will be rejected
             with the TimeStampExpiredError error.*/



        //delete the txId
        delete queued[txId];

        //generating the function selector
        bytes memory data;

        //function is not empty
        if (bytes(_func).length > 0) {
            data = abi.encodePacked(bytes4(keccak256(bytes(_func))), _data);
        } else {
            data = _data;
        }
        //execute it
        (bool ok, bytes memory res) = _target.call{value: _value}(data);

        //checking if the request is ok or not
        if (!ok) {
            revert TxFailedError();
        }
        emit Execute(txId, _target, _value, _func, _data, _timestamp);
        return res;
    }

    function cancle(bytes32 _txId) external onlyOwner {
        if (!queued[_txId]) {
            revert NotQueuedError(_txId);
        }
        delete queued[_txId];
        emit Cancel(_txId);
    }
}

contract TestTimeLock {
    address public timeLock;

    constructor(address _timeLock) {
        timeLock = _timeLock;
    }

    function test() external view {
        require(msg.sender == timeLock);
        //more code to do stuffs e.g.
        //upgrade contracts
        //transfer funds
        //switch price oracle
    }

    function getTimestamp() external view returns (uint256) {
        return block.timestamp + 100; 
        /*By adding 100 to the current block timestamp,
        the getTimestamp function returns a value that is guaranteed to be greater than
        the current block timestamp, allowing transactions to be queued
        for execution in the immediate future.*/
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TestMultiCall {
    function func1() external view returns (uint256, uint256) {
        return (1, block.timestamp);
    }

    function func2() external view returns (uint256, uint256) {
        return (2, block.timestamp);
    }

    function getData1() external pure returns(bytes memory) {
        return abi.encodeWithSelector(this.func1.selector);
    }

    function getData2() external pure returns(bytes memory) {
        return abi.encodeWithSelector(this.func2.selector);
    }
}


// contract TestMultiCall {
//     uint256 constant blockDuration = 15; // average block time in seconds

//     function func1() external view returns (uint256, uint256) {
//         return (1, block.number);
//     }

//     function func2() external view returns (uint256, uint256) {
//         return (2, block.number);
//     }

//     function getData1() external view returns (bytes memory) {
//         bytes memory selector = abi.encodeWithSelector(this.func1.selector);
//         uint256 blockNumber = block.number;
//         uint256 blockTimestamp = blockNumber * blockDuration;
//         return abi.encodePacked(selector, blockNumber, blockTimestamp);
//     }

//     function getData2() external view returns (bytes memory) {
//         bytes memory selector = abi.encodeWithSelector(this.func2.selector);
//         uint256 blockNumber = block.number;
//         uint256 blockTimestamp = blockNumber * blockDuration;
//         return abi.encodePacked(selector, blockNumber, blockTimestamp);
//     }
// }


contract MultiCall {
    function multiCall(address[] calldata targets, bytes[] calldata data)
        external
        view
        returns (bytes[] memory)
    {
        require(
            targets.length == data.length,
            "Target length is not equal to bytes."
        );
        bytes[] memory results = new bytes[](data.length);

        for (uint256 i; i < data.length; i++) {
            (bool success, bytes memory result) = targets[i].staticcall(
                data[i]
            );

            require(success, "Not Successfull");
            results[i] = result;
        }

        return results;
    }
}

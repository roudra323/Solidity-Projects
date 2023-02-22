// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract AbiEncodeDecode {
    function encode(
        uint256 x,
        address addr,
        uint256[] calldata nums
    ) external pure returns (bytes memory) {
        return abi.encode(x, addr, nums);
    }

    function decode(bytes calldata data)
        external
        pure
        returns (
            uint256 x,
            address addr,
            uint256[] memory arr
        )
    {
        (x, addr, arr) = abi.decode(data, (uint256, address, uint256[]));
    }
}

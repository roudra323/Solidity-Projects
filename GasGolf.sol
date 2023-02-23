// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract GasGolf {
    uint256 public total;

    //[1,2,3,4,5,100]

    function sumIfEvenAndLessThan99(uint256[] calldata nums) external {
        uint256 _total;
        uint len = nums.length;
        for (uint256 i; i < len; i ++) {
            uint num = nums[i];
            if ( num % 2 == 0 && num < 99) {
                _total += num;
            }
        }
        total = _total;
    }
}

//transaction execution 
//50860 28676 -> start
//49115 26931 -> calldata
//48773 26589 -> i++
//48258 26074 -> state variable,cache array length,load array variables to memory
//48039 25855 -> made total state variable local , then lastly assigned the local variable to state variable

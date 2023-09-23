// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Arena {
    mapping(address => address) public collectionToPool;
    address[] public deployedPools;


    // creates a pool for a specified collection
    // one pool per collection can be made
    function createPool(address nftCollection) public {
    }

    function getDeployedPools() public view returns (address[] memory) {
        return deployedPools;
    }
    
}

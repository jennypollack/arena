// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


contract Pool {
    // the collectionID 
    address public collection;

    struct Inventory {
        uint256[] nfts;
        address[] users;
        // stores the rewards accumulated for the active users
        mapping(address => uint256) accumulatedRewards;
    }

    Inventory inventory;

    constructor(address collection_) {
        collection = collection_;

    }
}

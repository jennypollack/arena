// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


contract Pool {
    // the collectionID 
    address public collection;

    constructor(address collection_) {
        collection = collection_;

    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


// not responsible for lost or stolen items


/*

              _                                         _ _     _         __             _           _                      _        _              _ _                     
             | |                                       (_) |   | |       / _|           | |         | |                    | |      | |            (_) |                    
  _ __   ___ | |_   _ __ ___  ___ _ __   ___  _ __  ___ _| |__ | | ___  | |_ ___  _ __  | | ___  ___| |_    ___  _ __   ___| |_ ___ | | ___ _ __    _| |_ ___ _ __ ___  ___ 
 | '_ \ / _ \| __| | '__/ _ \/ __| '_ \ / _ \| '_ \/ __| | '_ \| |/ _ \ |  _/ _ \| '__| | |/ _ \/ __| __|  / _ \| '__| / __| __/ _ \| |/ _ \ '_ \  | | __/ _ \ '_ ` _ \/ __|
 | | | | (_) | |_  | | |  __/\__ \ |_) | (_) | | | \__ \ | |_) | |  __/ | || (_) | |    | | (_) \__ \ |_  | (_) | |    \__ \ || (_) | |  __/ | | | | | ||  __/ | | | | \__ \
 |_| |_|\___/ \__| |_|  \___||___/ .__/ \___/|_| |_|___/_|_.__/|_|\___| |_| \___/|_|    |_|\___/|___/\__|  \___/|_|    |___/\__\___/|_|\___|_| |_| |_|\__\___|_| |_| |_|___/
                                 | |                                                                                                                                        
                                 |_|                                                                                                                                        






 */

contract Arena {
    mapping(address => address) public collectionToPool;
    address[] public deployedPools;

    // creates a pool for a specified collection
    // one pool per collection can be made
    // todo:
    function createPool(address nftCollection) public {
    }

    function getDeployedPools() public view returns (address[] memory) {
        return deployedPools;
    }
    
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


// not responsible for lost or stolen items

/*

                __                                           _ __    __        
   ____  ____  / /_   ________  _________  ____  ____  _____(_) /_  / /__      
  / __ \/ __ \/ __/  / ___/ _ \/ ___/ __ \/ __ \/ __ \/ ___/ / __ \/ / _ \     
 / / / / /_/ / /_   / /  /  __(__  ) /_/ / /_/ / / / (__  ) / /_/ / /  __/     
/_/ /_/\____/\__/  /_/   \___/____/ .___/\____/_/ /_/____/_/_.___/_/\___/      
    ____              __         /_/_                                          
   / __/___  _____   / /___  _____/ /_   ____  _____                           
  / /_/ __ \/ ___/  / / __ \/ ___/ __/  / __ \/ ___/                           
 / __/ /_/ / /     / / /_/ (__  ) /_   / /_/ / /                               
/_/  \____/_/     /_/\____/____/\__/ __\____/_/                                
   _____/ /_____  / /__  ____     (_) /____  ____ ___  _____                   
  / ___/ __/ __ \/ / _ \/ __ \   / / __/ _ \/ __ `__ \/ ___/                   
 (__  ) /_/ /_/ / /  __/ / / /  / / /_/  __/ / / / / (__  )                    
/____/\__/\____/_/\___/_/ /_/  /_/\__/\___/_/ /_/ /_/____/                     
                                                                               


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

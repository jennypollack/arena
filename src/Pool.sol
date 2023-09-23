// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";


contract Pool {
    // the collectionID 
    address public collection;

    struct Inventory {
        uint256[] nfts;
        address[] users;
        // stores the rewards accumulated for the active users
        mapping(address => uint256) accumulatedRewards;

        // stores the nft ids that a user has put in the pool
        mapping(address => uint256[]) deposits;
    }

    Inventory inventory;

    struct Auction {
        // todo
        bool active;
    }

    Auction auction;

    constructor(address collection_) {
        collection = collection_;

    }

    // need to be able to add an NFT to the pool's inventory
    function addToInventory(uint256 id_) public {
        // Ensure the NFT is owned by the caller
        require(IERC721(collection).ownerOf(id_) == msg.sender, "You do not own this NFT");
        
        // do we care if the nft is already in the inventory?

        // todo: approve the nft in the collection on this contract

        // add the NFT to the user and nft inventory
        inventory.users.push(msg.sender);
        inventory.nfts.push(id_);

        // add the nft to the user's deposits
        inventory.deposits[msg.sender].push(id_);

    }

    // Function to remove an NFT from the pool's inventory
    function removeFromInventory(uint256 id_) public {
        require(!auction.active, "Auction is currently active");
        require(inventory.deposits[msg.sender].length > 0, "You do not have any NFTs in the inventory");

        bool found = false;
        uint256[] storage userNFTList = inventory.deposits[msg.sender];

        for (uint256 i = 0; i < userNFTList.length; i++) {
            if (userNFTList[i] == id_) {
                found = true;

                // Remove the NFT from the user's array by shifting elements
                if (i < userNFTList.length - 1) {
                    userNFTList[i] = userNFTList[userNFTList.length - 1];
                }
                userNFTList.pop();
                break;
            }
        }

        require(found, "NFT not found in your inventory");

        // TODO: return the NFT to the user
        // IERC721(nftContract).transferFrom(address(this), address(msg.sender), tokenId);
 
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


// not responsible for lost or stolen items

/*

              _                                         _ _     _       
             | |                                       (_) |   | |      
  _ __   ___ | |_   _ __ ___  ___ _ __   ___  _ __  ___ _| |__ | | ___  
 | '_ \ / _ \| __| | '__/ _ \/ __| '_ \ / _ \| '_ \/ __| | '_ \| |/ _ \ 
 | | | | (_) | |_  | | |  __/\__ \ |_) | (_) | | | \__ \ | |_) | |  __/ 
 |_|_|_|\___/ \__|_|_|  \___||___/ .__/ \___/|_| |_|___/_|_.__/|_|\___| 
  / _|           | |         | | | |                                    
 | |_ ___  _ __  | | ___  ___| |_|_| ___  _ __                          
 |  _/ _ \| '__| | |/ _ \/ __| __|  / _ \| '__|                         
 | || (_) | |    | | (_) \__ \ |_  | (_) | |                            
 |_| \___/|_|  _ |_|\___/|___/\__|  \___/|_|                            
     | |      | |            (_) |                                      
  ___| |_ ___ | | ___ _ __    _| |_ ___ _ __ ___  ___                   
 / __| __/ _ \| |/ _ \ '_ \  | | __/ _ \ '_ ` _ \/ __|                  
 \__ \ || (_) | |  __/ | | | | | ||  __/ | | | | \__ \                  
 |___/\__\___/|_|\___|_| |_| |_|\__\___|_| |_| |_|___/                  
                                                                        
                                                                        
 */

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";


contract Pool {
    // the collectionID 
    address public collection;

    struct Inventory {

        // change this back to an array instead of a mapping?
        mapping(uint256 => bool) nfts;
        address[] users;

        // stores the nft ids that a user has put in the pool
        mapping(address => uint256[]) deposits;

        // stores the rewards accumulated for the active users
        mapping(address => uint256) accumulatedRewards;
    }

    Inventory inventory;

    struct Auction {
        // todo
        bool active;

        uint256 nftID;
        uint256 start;
        uint256 end;
        uint256 duration;

        uint256 currentBid;
        address currentBidder;
    }

    Auction auction;

    constructor(address collection_) {
        collection = collection_;

        // Initialize the inventory and auction structs
        inventory = Inventory({
            users: new address[](0) // Initialize with an empty array of users
        });

        auction = Auction({
            active: false,          // Auction is not active initially
            nftID: 0,
            start: 0,
            end: 0,
            duration: 1 days,
            currentBid: 0,
            currentBidder: address(0)
        });

    }

    // allows a user to add an nft they own to the 
    // the pool's inventory
    function addToInventory(uint256 id_) public {
        // Ensure the NFT is owned by the caller
        require(IERC721(collection).ownerOf(id_) == msg.sender, "You do not own this NFT");
        
        // todo: approve the nft in the collection on this contract

        // add the NFT to the user and nft inventory
        inventory.users.push(msg.sender);
        inventory.nfts[id_] = true;

        // add the nft to the user's deposits
        inventory.deposits[msg.sender].push(id_);

    }

    // allows a user to remove an nft they deposited into the pool
    // from the inventory
    function removeFromInventory(uint256 id_) public {
        require(!auction.active, "Auction is currently active");
        require(inventory.deposits[msg.sender].length > 0, "You do not have any NFTs in the inventory");
        require(inventory.nfts[id_] = true, "Nft not in inventory");

        // TODO
        // got this from chatgpt but i'm not sure i like it
        // maybe should use delete
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

        // remove nftId from nft inventory
        inventory.nfts[id_] = false;
 
    }


    //////// auction management
    // Function to start an auction
    function startAuction() public {
        if(auction.active) return; 
        auction.start = block.timestamp;
        auction.end = auction.start + auction.duration;

        // todo: lockNFT
        auction.nftID = lockNFT();
    }

    // Function to end an auction
    function endAuction() public {
        auction.active = false;
    }


    // 
    function settleAuction() public {
        require(msg.sender == auction.currentBidder, "Only the winner can settle the auction");

        // they need to send enough eth to buy the nft
        require(msg.value >= auction.currentBid, 'Must send at least currentBid');



    }


    // allows anyone to bid on the current nft on auction
    function bid(uint256 newBidAmount) external {
        require(newBidAmount > auction.currentBid, "Bid must be higher than the current bid");
        
        auction.currentBid = newBidAmount;
        auction.currentBidder = msg.sender;
    }
}

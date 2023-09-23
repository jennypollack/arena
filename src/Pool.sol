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
        bool active;

        uint256 nftID;
        uint256 start;
        uint256 end;
        uint256 duration;

        uint256 currentBid;
        address currentBidder;

        address prevOwner;
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
            currentBidder: address(0),
            prevOwner: address(0)
        });

    }

    // allows a user to add an nft they own to the pool's inventory
    function addToInventory(uint256 id_) public {
        // Ensure the NFT is owned by the caller
        require(IERC721(collection).ownerOf(id_) == msg.sender, "You do not own this NFT");
        
        // Transfer the NFT from the owner to the auction contract
        IERC721(collection).safeTransferFrom(msg.sender, address(this), id_);

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

        // return the nft to the user
        IERC721(collection).transferFrom(address(this), address(msg.sender), id_);

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

        // todo: set prev owner
        // auction.prevOwner
    }

    // Function to end an auction
    function endAuction() public {
        auction.active = false;
    }


    // 
    function settleAuction() public {
        // todo:
        // if auction duration is over you can settle the auction

        require(msg.sender == auction.currentBidder, "Only the winner can settle the auction");

        // they need to send enough eth to buy the nft
        require(msg.value >= auction.currentBid, 'Must send at least currentBid');

        // get the owner of the NFT
        // nftid to owner
        // could store this on getting random

        auction.nftID



    }


    // allows anyone to bid on the current nft on auction
    function bid(uint256 newBidAmount) external {
        require(newBidAmount > auction.currentBid, "Bid must be higher than the current bid");
        
        auction.currentBid = newBidAmount;
        auction.currentBidder = msg.sender;
    }


    // msg sender gets paid by the contract for their accumulated value
    // todo:
    function redeem() public {

    }
}

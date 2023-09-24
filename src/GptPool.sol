// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract GptPool {
    address public collection;

    struct Inventory {
        mapping(uint256 => bool) nfts;
        address[] users;
        mapping(address => uint256[]) deposits;
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
    }

    Auction public auction;

    constructor(address collection_) {
        collection = collection_;


    }

    /**
     * @dev Allows a user to add an NFT they own to the pool's inventory.
     * @param id_ The ID of the NFT to add.
     */
    function addToInventory(uint256 id_) public {
        // Ensure the NFT is owned by the caller
        require(IERC721(collection).ownerOf(id_) == msg.sender, "You do not own this NFT");

        // TODO: Implement NFT approval and transfer to this contract

        // Add the NFT to the user and NFT inventory
        inventory.users.push(msg.sender);
        inventory.nfts[id_] = true;

        // Add the NFT to the user's deposits
        inventory.deposits[msg.sender].push(id_);
    }

    /**
     * @dev Allows a user to remove an NFT they deposited into the pool from the inventory.
     * @param id_ The ID of the NFT to remove.
     */
    function removeFromInventory(uint256 id_) public {
        require(!auction.active, "Auction is currently active");
        require(inventory.deposits[msg.sender].length > 0, "You do not have any NFTs in the inventory");
        require(inventory.nfts[id_], "NFT not in inventory");

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

        // TODO: Implement NFT return to the user
        // IERC721(collection).transferFrom(address(this), address(msg.sender), id_);

        // Remove the NFT from the NFT inventory
        inventory.nfts[id_] = false;
    }

    // Function to start an auction
    function startAuction(uint256 duration) public {
        require(!auction.active, "Auction is already active");
        auction.start = block.timestamp;
        auction.end = auction.start + duration;
        auction.duration = duration;

        // TODO: Implement NFT locking and auction initialization
        // auction.nftID = lockNFT();

        auction.active = true;
    }

    // Function to end an auction
    function endAuction() public {
        require(auction.active, "Auction is not active");
        require(block.timestamp >= auction.end, "Auction has not ended yet");
        auction.active = false;

        // TODO: Implement auction winner handling and NFT transfer
        // address winner = auction.currentBidder;
        // uint256 winningBid = auction.currentBid;

        // Transfer NFT to the winner and handle funds
        // ...

        // Reset the auction state
        // auction.nftID = 0;
        // auction.currentBid = 0;
        // auction.currentBidder = address(0);
    }

    /**
     * @dev Allows anyone to bid on the current NFT on auction.
     * @param newBidAmount The new bid amount.
     */
    function bid(uint256 newBidAmount) external {
        require(auction.active, "Auction is not active");
        require(block.timestamp < auction.end, "Auction has ended");

        require(newBidAmount > auction.currentBid, "Bid must be higher than the current bid");

        // TODO: Handle bidding and updating the current bid
        // auction.currentBid = newBidAmount;
        // auction.currentBidder = msg.sender;

        // TODO: Refund the previous bidder's bid
        // ...

        // TODO: Implement additional logic for funds and NFT transfer on winning the auction
        // ...
    }
}

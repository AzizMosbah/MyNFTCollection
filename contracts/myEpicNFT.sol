// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; // tokens that are good for collectibles 
import "@openzeppelin/contracts/utils/Counters.sol"; //to keep track of token_ids
import "hardhat/console.sol"; // to use the console in solidity

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";


contract MyEpicNFT is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter _tokenIds;
    uint256 limit = 50;


    string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["Slimy", "Stubborn", "Flexible", "Misunderstood", "Drunken", "Arrogant", "Rebellious", "Idiotic", "Complacent", "Half-Hearted", "Maniacal", "Narrow-Minded"];
    string[] secondWords = ["Adulterous", "Bat-Shit-Crazy", "Demanding", "Flirting", "Greedy", "Hateful", "Hyperactive", "Naked", "Frisky", "Greedy", "Insecure", "Shaky", "Shivering","Yapping"];
    string[] thirdWords = ["Elephant", "Butterfly", "Mouse", "Pigeon", "Dog", "Fox", "Fly", "Sheep", "Rooster", "Goat", "Horse", "Python", "Baboon", "Zebra", "Alligator", "Buffalo", "Tiger"];
    string[] colors = ["#A52A2A", "#08C2A8", "#000000", "#B8860B", "#6495ED", "#008000", "#8A2BE2", "#FF8C00", "#808000", "#C0C0C0"];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    // pass in name of the NFT token and its symbol
    constructor() ERC721 ("Crazy Animal Cafe", "TRW") {
        console.log("This is my nft contract");
    }

    function totalSupply() public view returns(uint256) {
        console.log(_tokenIds.current() + 1);
        return MyEpicNFT._tokenIds.current() + 1;
    }

    function maxSupply() public view returns(uint256) {
        return limit;
    }

    function random(string memory input) internal pure returns (uint256){
        return uint256(keccak256(abi.encodePacked(input)));

    }

    function pickRandomFirstWord(uint256 tokenId) public view returns(string memory){
        uint256 rand = random(string(abi.encodePacked("FIRST WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }
    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function pickRandomColor(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("a color", Strings.toString(tokenId))));
        rand = rand % colors.length;
        return colors[rand];
    }

    //A function our users will hit to get their NFT
    function makeAnEpicNFT() public {

        //get the current tokenId that starts at 0
        require(_tokenIds.current() <= 49);
        uint256 newItemId = _tokenIds.current();



        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory color = pickRandomColor(newItemId);
        string memory combineWord = string(abi.encodePacked(first, second, third));

        string memory finalSvg = string(abi.encodePacked(svgPartOne, color, svgPartTwo, combineWord,  "</text></svg>"));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combineWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );
        
        string memory finalTokenUri = string(abi.encodePacked("data:application/json;base64,",json));
        //Actually mint the NFT to the sender using msg.sender
        console.log("\n--------------------");
        console.log(
            string(
                abi.encodePacked(
                    "https://nftpreview.0xdev.codes/?code=",
                    finalTokenUri
                )
            )
        );
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        //set the nFTs data
        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();
        
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        
        emit NewEpicNFTMinted(msg.sender, newItemId);

    }
}
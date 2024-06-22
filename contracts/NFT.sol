// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721, Ownable {
    string public baseUri;
    string public fileExtention = ".json";
    using Strings for uint256;

    constructor(string memory _baseuri) ERC721("MyNFT", "MYN") {
        setBaseURI(_baseuri);
    }

    function setBaseURI(string memory _uri) public {
        baseUri = _uri;
    }

    function baseURI() external view returns (string memory) {
        return baseUri;
        //return "ipfs://QmeSrpyEPVGxAfmfkL8R5TSwQgDSgnUSBC165sBFQqkZcF/";
    }

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        // string memory baseURI = baseURI();
        return
            bytes(baseUri).length > 0
                ? string(
                    abi.encodePacked(baseUri, tokenId.toString(), fileExtention)
                )
                : "";
    }
}

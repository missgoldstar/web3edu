// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// OpenZeppelin의 ERC721Enumerable 및 Strings 라이브러리 가져오기
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ERC721Token is ERC721Enumerable, Ownable {
    using Strings for uint256;
    uint256 public nextTokenId;
    string public baseUri;

    mapping(uint256 => string) private _tokenURIs;

    constructor(
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) Ownable(msg.sender) {
        // 컨트랙트 배포자 주소를 관리자로 설정
        setBaseURI("ipfs://");
    }

    function mint(address to) external onlyOwner {
        _safeMint(to, nextTokenId);
        nextTokenId++;
    }

    function lastTokenId() external view returns (uint256) {
        return nextTokenId - 1;
    }

    function setBaseURI(string memory _newuri) public onlyOwner {
        baseUri = _newuri;
    }

    function setTokenURI(uint256 tokenId, string memory _uri) public onlyOwner {
        _isOwned(tokenId);
        _tokenURIs[tokenId] = _uri;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return string.concat(baseUri, _tokenURIs[tokenId]);
    }

    // 토큰 소유자 확인 함수 이름 변경
    function _isOwned(uint256 tokenId) internal view {
        require(
            ownerOf(tokenId) == _msgSender(),
            "ERC721Token: caller is not owner"
        );
    }

    // 특정 주소가 소유한 모든 토큰 ID를 반환하는 함수
    function tokensOfOwner(
        address owner
    ) external view returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(owner);
        uint256[] memory tokenIds = new uint256[](tokenCount);
        for (uint256 i = 0; i < tokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(owner, i);
        }
        return tokenIds;
    }
}

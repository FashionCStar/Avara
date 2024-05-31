
// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity 0.8.4;
// contract AvaraNft is ERC721{
    // uint256 public nftIdPointer;
    // constructor(string memory name, string memory symbol) ERC721(name, symbol) {}
    // function mint(string calldata metaData) public returns(uint256) {
    //     uint256 nftId;
    //     nftId = nftIdPointer;
    //     nftIdPointer = nftIdPointer.add(1);
    //     _safeMint(msg.sender, nftId);
    //     return nftId;
    // }
// }

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract AvaraNft is ERC721 {
    using SafeMath for uint256; 
    uint256 public nftIdPointer;
    string public baseTokenURI;
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}
    function mint(string calldata metaData) public returns(uint256) {
        uint256 nftId;
        nftId = nftIdPointer;
        nftIdPointer = nftIdPointer.add(1);
        _safeMint(msg.sender, nftId);
        return nftId;
    }
    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }
    function setBaseURI(string memory baseURI) public {
        baseTokenURI = baseURI;
    }
    function isApproved(uint256 _tokenId, address _operator) public view returns (bool) {
        return isApprovedForAll(ownerOf(_tokenId), _operator) || getApproved(_tokenId) == _operator;
    }
    function exists(uint256 _tokenId) external view returns (bool) {
        return _exists(_tokenId);
    }
}
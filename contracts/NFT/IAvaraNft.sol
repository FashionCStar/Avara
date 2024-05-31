// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IAvaraNft is IERC721 {
    function setBaseURI(string memory baseURI) external;
    function mint(string calldata _metaData) external returns (uint256);
    function burn(uint256 _tokenId) external returns(bool);
    function isApproved(uint256 _tokenId, address _operator) external view returns (bool);
    function exists(uint256 _tokenId) external view returns (bool);
}
/**
    ***********************************************************
    * Copyright (c) Avara Dev. 2021. (Telegram: @avara_cc)  *
    ***********************************************************

     ▄▄▄·  ▌ ▐· ▄▄▄· ▄▄▄   ▄▄▄·
    ▐█ ▀█ ▪█·█▌▐█ ▀█ ▀▄ █·▐█ ▀█
    ▄█▀▀█ ▐█▐█•▄█▀▀█ ▐▀▀▄ ▄█▀▀█
    ▐█ ▪▐▌ ███ ▐█ ▪▐▌▐█•█▌▐█ ▪▐▌
     ▀  ▀ . ▀   ▀  ▀ .▀  ▀ ▀  ▀  - Binance Smart Chain

    Avara - Always Vivid, Always Rising Above
    https://avara.cc/
    https://github.com/avara-cc
    https://github.com/avara-cc/Avara/wiki
*/

// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity 0.8.4;

import "./abstract/AvaraModule.sol";
import "./library/SafeMath.sol";
import "./NFT/IAvaraNft.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract OwnershipModule is AvaraModule {
    IAvaraNft public AvaraNFT;
    IERC20 public Avara;
    struct SellNft {
        uint256 price;
        address seller;
    }
    mapping(uint256 => SellNft) public sellNftList;
    event SellingNft(uint256 nftId, uint256 price, address seller);
    event BuyingNft(uint256 nftId, address buyer);

    constructor(address cOwner, address baseContract, address avaraNftContract) AvaraModule(cOwner, baseContract, "Ownership", "0.0.1") {
        AvaraNFT = IAvaraNft(avaraNftContract);
        Avara = IERC20(baseContract);
    }

    function selling(uint256 nftId, uint256 price_) public {
        require(AvaraNFT.exists(nftId), "Marketplace.sellingNFT: NftId does not exist");
        require(AvaraNFT.ownerOf(nftId) == _msgSender(), "Marketplace.sellingNFT: Sender has to be the owner of token");
        sellNftList[nftId] = SellNft({
            price: price_,
            seller: _msgSender()
        });

        emit SellingNft(nftId, price_, _msgSender());
    }
    function buying(uint256 nftId) public {
        require(AvaraNFT.exists(nftId), "OwnershipModule.buying: NftId does not exist.");
        require(sellNftList[nftId].price != 0, "OwnershipModule.buying: Token is not in sale list.");
        require(AvaraNFT.ownerOf(nftId) != _msgSender(), "OwnershipModule.buying: Owner of nft can not buy his own nft.");
        SellNft storage sell = sellNftList[nftId];
        require(Avara.allowance(_msgSender(), address(this)) >=  sell.price, "OwnershipModule.buying: ERC20 token allowance is less than selling price.");
        Avara.transferFrom(_msgSender(), sell.seller, sell.price);

        AvaraNFT.safeTransferFrom(AvaraNFT.ownerOf(nftId), _msgSender(), nftId);
        sellNftList[nftId].price = 0;
        sellNftList[nftId].seller = _msgSender();
        emit BuyingNft(nftId, _msgSender());
    }
    /**
    * @dev Occasionally called (only) by the server to make sure that the connection with the module and main contract is granted.
    */
    function ping() external view onlyOwner returns (string memory) {
        return getBaseContract().ping();
    }
}
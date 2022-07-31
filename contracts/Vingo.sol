// SPDX-License-Identifier: UNLICENCED
pragma solidity ^0.8.9;

import "@divergencetech/ethier/contracts/erc721/ERC721ACommon.sol";
import "@divergencetech/ethier/contracts/erc721/BaseTokenURI.sol";
import "@divergencetech/ethier/contracts/sales/FixedPriceSeller.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

/// @title Viking Art Collective NFT
/// @author @odentorp
contract Vingo is ERC721ACommon, BaseTokenURI, ERC2981, FixedPriceSeller {
    using Strings for uint256;

    constructor(
        string memory name,
        string memory symbol,
        address payable beneficiary,
        address payable royaltyReceiver
    )
    ERC721ACommon(name, symbol)
    BaseTokenURI("")
    FixedPriceSeller(
        0.0001 ether,
        // How to white list mints?
        // TODO(odentorp): freeQuota is not working as expected. I was able to mint 5 NFTs even though freeQuota is 2. Similarly, totalInventory is 3, but I was able to mint 5.
        // These issues to be fixed in a separate PR.
        Seller.SellerConfig({
            totalInventory: 100,
            maxPerAddress: 0,
            maxPerTx: 0,
            freeQuota: 10,
            lockFreeQuota: false, // can update quota if needed
            reserveFreeQuota: true,
            lockTotalInventory: true
        }),
        beneficiary
    )
    {
        _setDefaultRoyalty(royaltyReceiver, 750);
    }

    /**
    @notice Internal override of Seller function for handling purchase (i.e. minting).
     */
    function _handlePurchase(
        address to,
        uint256 num,
        bool
    ) internal override {
        _safeMint(to, num);
    }

    /**
    @notice Mint as an address on one of the early-access lists.
     */
     // TODO: handle allow list minting
    // function mint(
    //     address to,
    //     uint256 price,
    //     bytes32 nonce,
    //     bytes calldata sig
    // ) external payable {
    //     signers.requireValidSignature(
    //         signaturePayload(to, price, nonce),
    //         sig,
    //         usedMessages
    //     );
    //     _purchase(to, 1, price);
    // }

    /**
    @notice Flag indicating that public minting is open.
     */
    bool public publicMinting;

    /**
    @notice Set the `publicMinting` flag.
     */
    function setPublicMinting(bool _publicMinting) external onlyOwner {
        publicMinting = _publicMinting;
    }

    /**
    @dev Public minting method only available when public minting is enabled
    */
    function mintPublic(
        address to
    ) external payable {
        require(publicMinting, "Public minting closed");
        console.log(_baseURI());
        _purchase(to, 1);
    }

    /**
    @dev Required override to select the correct baseTokenURI.
     */
    function _baseURI()
        internal
        view
        override(BaseTokenURI, ERC721A)
        returns (string memory)
    {
        return BaseTokenURI._baseURI();
    }

    /**
    @notice If renderingContract is set then returns its tokenURI(tokenId)
    return value, otherwise returns the standard baseTokenURI + tokenId.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    /**
    @notice Sets the contract-wide royalty info.
     */
    function setRoyaltyInfo(address receiver, uint96 feeBasisPoints)
        external
        onlyOwner
    {
        _setDefaultRoyalty(receiver, feeBasisPoints);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721ACommon, ERC2981) returns (bool) {
        // Supports the following `interfaceId`s:
        // - IERC165: 0x01ffc9a7
        // - IERC721: 0x80ac58cd
        // - IERC721Metadata: 0x5b5e139f
        // - IERC2981: 0x2a55205a
        return 
            ERC721A.supportsInterface(interfaceId) || 
            ERC2981.supportsInterface(interfaceId);
    }
}

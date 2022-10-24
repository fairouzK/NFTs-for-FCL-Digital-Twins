// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTMinter is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    // Events
    event NFTmintedForContainer(uint256 id, address b);

    address managerContract;
    modifier onlyManagerContract() {
        require(msg.sender == managerContract);
        _;
    }

    constructor() ERC721("ContainerNFT", "CNFT") {}

    function setManagerContractAddr(address addr) public onlyOwner {
        managerContract = addr;
    }

    function safeMint(address to, string memory uri)
        public
        onlyManagerContract
        returns (uint256)
    {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        // ManageShipment(managerContract).setContainerNFTId(to, requestID, tokenId);
        // emit NFTmintedForContainer(tokenId, to);
        return tokenId;
    }

    // function approveOperator(uint256 nftId) public {
    //     if (getApproved(nftId) != managerContract) {
    //         approve(managerContract, nftId);
    //     }
    // }

    function burnNFT(uint256 tokenId) public onlyManagerContract {
        _burn(tokenId);
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI)
        public
        onlyManagerContract
    {
        require(
            _exists(tokenId),
            "ERC721URIStorage: URI query for nonexistent token"
        );
        _setTokenURI(tokenId, _tokenURI);
        // _tokenURIs[tokenId] = _tokenURI;
    }

    // The following functions are overrides required by Solidity.
    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}

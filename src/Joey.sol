// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "openzeppelin/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin/access/ownable.sol";
import "openzeppelin/utils/Counters.sol";

contract Joey is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }

    function createNft(address _to, string memory _tokenURI)
        public
        onlyOwner
        returns (uint256)
    {
        uint256 newTokenId = _tokenIds.current();

        _safeMint(_to, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);

        _tokenIds.increment();
        return newTokenId;
    }

    function setTokenURI(uint256 _tokenId, string memory _tokenURI)
        external
        onlyOwner
    {
        _setTokenURI(_tokenId, _tokenURI);
    }
}

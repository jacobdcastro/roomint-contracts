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

    function mint(address _to, string memory _tokenURI)
        internal
        returns (uint256)
    {
        uint256 newTokenId = _tokenIds.current();

        _safeMint(_to, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);

        _tokenIds.increment();
        return newTokenId;
    }

    function createNft(address _to, string memory _tokenURI)
        public
        onlyOwner
        returns (uint256)
    {
        uint256 newTokenId = mint(_to, _tokenURI);
        return newTokenId;
    }

    function createBatchNfts(address[] memory _tos, string[] memory _tokenURIs)
        public
        onlyOwner
    {
        require(_tos.length == _tokenURIs.length, "Joey: invalid input");
        for (uint256 i = 0; i < _tos.length; i++) {
            mint(_tos[i], _tokenURIs[i]);
        }
    }

    function setTokenURI(uint256 _tokenId, string memory _tokenURI)
        external
        onlyOwner
    {
        _setTokenURI(_tokenId, _tokenURI);
    }
}

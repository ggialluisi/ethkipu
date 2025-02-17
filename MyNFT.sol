// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract GubaNFT is ERC721 {
    uint256 s_tokenCount;

    /*///////////////////////
            Errors
    ///////////////////////*/
  error GubaNFT_NonExistentNFT();

    constructor() ERC721("GubaNFT", "GUB") {}

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        if(_ownerOf(_tokenId) == address(0)) revert GubaNFT_NonExistentNFT();
        return "<https://ipfs.io/ipfs/bafkreiczxsjobad53aej7jnyshmnncbgiyo6x545en4mzabi5lbftrpga4>";
    }

    function mintNFT(address _to) public
    {
        s_tokenCount  += 1;
        _mint(_to, s_tokenCount);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";



contract LofiClub is ERC721, Ownable {
uint256 public  mintPrice;
uint256 public maxSupply;
uint256 public maxPerWallet;
uint256 public totalSupply;

bool public isPublicMintEnabled;

string public baseTokenUri; 
address payable public withdrawWallet; 

mapping(address => uint256) public walletMints; 

constructor() ERC721("LofiClub", "LOFICLUB") Ownable(msg.sender) {
    mintPrice = 0.001 ether;
    maxSupply = 1000;
    maxPerWallet = 3;
    totalSupply = 0;

}



function setIsPublicMintEnabled(bool _isPublicMintEnabled) external onlyOwner {
    isPublicMintEnabled = _isPublicMintEnabled;
}


function setBaseTokenUri(string calldata _baseTokenUri) external onlyOwner {
    baseTokenUri = _baseTokenUri;


}


function setWithdrawWallet(address payable _withdrawWallet) external onlyOwner {
    withdrawWallet = _withdrawWallet;}


function tokenURI(uint256 _tokenId) public view override returns (string memory) {
    require(_ownerOf(_tokenId) != address(0), "Token does not exist");
    return string(abi.encodePacked(baseTokenUri, Strings.toString(_tokenId), ".json"));
}


function withdraw() external onlyOwner {
    (bool success, ) = withdrawWallet.call{value: address(this).balance}("");
    require(success, "Withdraw failed");
}
function mint() external payable {
    require(isPublicMintEnabled, "Minting is not enabled");
    require(totalSupply < maxSupply, "Max supply reached");
    require(walletMints[msg.sender] < maxPerWallet, "Max per wallet reached");
    require(msg.value >= mintPrice, "Insufficient funds sent");

    uint256 newTokenId = totalSupply + 1;
    totalSupply += 1;
    _safeMint(msg.sender, newTokenId);
     walletMints[msg.sender] += 1;


} 
}


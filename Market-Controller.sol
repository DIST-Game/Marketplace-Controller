pragma solidity ^0.4.4;
import "./common/namespaceInterface.sol";
import "./common/assetControllerInterface.sol";
interface tokeInterface{
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success);
    function approve(address _spender, uint256 _value) public;
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
}
contract MarketplaceControllerContract{
    address internal proxyContractAddress;
    address internal namespaceResolverAddress;
    function MarketplaceControllerContract(address _proxyContractAddress,address _namespaceResolverAddress) public {
        proxyContractAddress = _proxyContractAddress;
        namespaceResolverAddress = _namespaceResolverAddress;
    }
    function pendingOrder(address caller,uint256 itemHash, uint256 prices) public{
        address assetAddress=namespaceResolver(namespaceResolverAddress).getAddress("AssetController");
        assetController(assetAddress).launch(caller,itemHash,prices);//need modify
    }
    function soldOut(address caller,uint256 itemHash) public{
        //require(callerContractAddress == proxyContractAddress);
        address assetAddress=namespaceResolver(namespaceResolverAddress).getAddress("AssetController");
        //mapping(string=>uint256) values;
        //values["status"] = 65533; //todo need define status table;
        //values["prices"] = prices;
        assetController(assetAddress).withdraw(caller,itemHash);//need modify
        
    }
    function buy(address caller,uint256 itemHash,uint256 tokenNum) public{
        //require(callerContractAddress == proxyContractAddress);
        address assetAddress=namespaceResolver(namespaceResolverAddress).getAddress("AssetController");
        //address tokenAddress=namespaceResolver(namespaceResolverAddress).getAddress("Token");
        var prices = assetController(assetAddress).queryAssetPrice(itemHash);
        require(tokenNum >= prices);
        //var seller = assetController(assetAddress).queryAssetOwner(itemHash);
        //tokeInterface(tokenAddress).approve(seller,tokenNum);
        //mapping(string=>address) values;
        //values["owner"] = msg.sender;
        assetController(assetAddress).switchOwner(msg.sender,itemHash);
        //tokeInterface(tokenAddress).transferFrom(caller,seller,tokenNum);
    }
    function listGoods(uint256 gameIndex, uint256 showStartIndex) public constant returns(uint256[100] goodsList,uint8 len){
        address assetAddress=namespaceResolver(namespaceResolverAddress).getAddress("AssetController");
        return assetController(assetAddress).listGoods(gameIndex,showStartIndex);
    }
}

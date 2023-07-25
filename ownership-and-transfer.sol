pragma solidity ^0.8.0;

contract AssetTracking {
    struct Asset {
        uint id;
        address owner;
        bool isAvailable;
    }

    mapping(uint => Asset) public assets;
    uint public totalAssets;

    event AssetCreated(uint indexed id, address indexed owner);
    event AssetTransferred(uint indexed id, address indexed from, address indexed to);

    function createAsset() public returns (uint) {
        uint assetId = totalAssets + 1;
        assets[assetId] = Asset(assetId, msg.sender, true);
        totalAssets++;
        emit AssetCreated(assetId, msg.sender);
        return assetId;
    }

    function transferAsset(uint _id, address _to) public {
        Asset storage asset = assets[_id];
        require(asset.isAvailable, "The asset is not available.");
        require(asset.owner == msg.sender, "You are not the owner of this asset.");

        asset.owner = _to;
        emit AssetTransferred(_id, msg.sender, _to);
    }
}
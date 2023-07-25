pragma solidity ^0.8.0;

contract SubscriptionService {
    struct Subscription {
        uint id;
        address subscriber;
        uint startTimestamp;
        uint endTimestamp;
        uint price;
        bool isActive;
    }

    mapping(uint => Subscription) public subscriptions;
    uint public totalSubscriptions;
    uint public subscriptionDuration;

    event SubscriptionCreated(uint indexed id, address indexed subscriber, uint startTimestamp, uint endTimestamp, uint price);
    event SubscriptionCancelled(uint indexed id, address indexed subscriber);

    constructor(uint _subscriptionDuration) {
        subscriptionDuration = _subscriptionDuration;
    }

    function createSubscription() public payable returns (uint) {
        require(msg.value > 0, "The payment amount is incorrect.");

        uint subscriptionId = totalSubscriptions + 1;
        uint startTimestamp = block.timestamp;
        uint endTimestamp = startTimestamp + subscriptionDuration;
        subscriptions[subscriptionId] = Subscription(subscriptionId, msg.sender, startTimestamp, endTimestamp, msg.value, true);
        totalSubscriptions++;
        emit SubscriptionCreated(subscriptionId, msg.sender, startTimestamp, endTimestamp, msg.value);
        return subscriptionId;
    }

    function cancelSubscription(uint _id) public {
        Subscription storage subscription = subscriptions[_id];
        require(subscription.isActive, "The subscription is not active.");
        require(subscription.subscriber == msg.sender, "You are not the subscriber of this subscription.");

        subscription.isActive = false;
        payable(msg.sender).transfer(subscription.price);
        emit SubscriptionCancelled(_id, msg.sender);
    }

    function getSubscriptionInfo(uint _id) public view returns (address, uint, uint, uint, uint, bool) {
        Subscription storage subscription = subscriptions[_id];
        return (subscription.subscriber, subscription.startTimestamp, subscription.endTimestamp, subscription.price, subscriptionDuration, subscription.isActive);
    }

    function extendSubscription(uint _id) public payable {
        Subscription storage subscription = subscriptions[_id];
        require(subscription.isActive, "The subscription is not active.");
        require(subscription.subscriber == msg.sender, "You are not the subscriber of this subscription.");

        uint extensionLength = msg.value / subscription.price * subscriptionDuration;
        subscription.endTimestamp += extensionLength;
    }
}
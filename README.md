#iOS SDK
The Incentiviral iOS SDK help developers incentivise their apps in unique ways thereby creating a lasting, viral impression on users. For example
- You can offer discount coupons to users when they share an app message on facebook
- You can offer in-app currency when users have spent a certain amount of time in the app

![The LowPrice app using the Incentiviral SDK ](http://s27.postimg.org/xca7v5smr/incentiviral1.png "The LowPrice android app using the Incentiviral SDK")

#Features
- Custom event logging
- Per app and per user incentivisation
- Custom threshold monitoring
- Dynamically change rewards and threshold from the server side
 
##Sample
The sample app "app" included in the repo demonstrates the following features
- Setting up the Incentiviral SDK with the appId and userId
- Logging a simple event for the current user
- Retrieving the current rewards for the same user

##Add Incentiviral to your app
- Download the latest libIncentiViral.a library and corresponding IncentiViral.h file
- Add these files file to your project
- Import the .h file wherever you want to use it and you are ready to go!!

##Setup Incentiviral for your user

To receive async callbacks of the logging and upcoming APIs, user must conform to following protocol
```
@protocol viralDelegate <NSObject>

@required
- (void) didReceiveRewards:(NSDictionary *) rewardsDictionary withError:(NSError *) error;
- (void) didEventLogWithError:(NSError *) error;
- (void) didReceiveRewardsList:(NSArray *) rewardsList withError:(NSError *) error;
@end
```

To initialise Incentiviral call ```initWithAppIdentifier:withUserIdentifier``` which returns an Incentiviral object.
```ios
[[IncentiViral alloc] initWithAppIdentifier:@“xyz” withUserIdentifier:@“xyz”];
```
Here
- **AppIdentifier** is your application id available at the Incentiviral dashboard, this is unique to your application
- **UserIdentifier** is the unique id of the user of the app, incentives will be tracked based on this user id for your application

##Logging events
To log an event, call the ```logEventWithEventName:withCount:withDelegate``` method
```ios
[incentiviralObject logEventWithEventName:@“eventName” withCount:1 withDelegate:self];
```
and implement appropriate protocol method to receive success/failure callback.

##Checking for Rewards
To check for rewards, call the ```checkCurrentRewardsWithDelegate```
```ios
[incentiviralObject checkCurrentRewardsWithDelegate:self];
```
and handle the appropriate protocol method for getting success/failure callback.

##Show all rewards
To fetch a list of all possible rewards, call the ```checkStaticRewardListWithDelegate:``` method
```ios
[incentiviralObject checkStaticRewardListWithDelegate:self];
```
and handle the appropriate protocol method for getting success/failure callback.

For example, if you'd like to log an event that the user visited some screen in your app 10 times, you can
```ios
[incentiviralObject logEventWithEventName:@“eventName” withCount:1 withDelegate:self];

- (void) didEventLogWithError:(NSError *)error
{
    if (error) {
        // Handle error object
    }
    else {
	// Calling checkCurrentRewardsWithDelegate: method only if the Event Logging call succeeds
        [appDelegate.viralObject checkCurrentRewardsWithDelegate:self];
    }
}

- (void) didReceiveRewards:(NSDictionary *)rewardsDictionary withError:(NSError *)error
{
    // Handle NSDictionary data according to use case. In this dictionary user will be getting details about the reward sent from server.
}
```

**Note**
- These call is completely asynchronous in nature, there is no need to add support for threading
- In case there are no active deals, this list will be blank
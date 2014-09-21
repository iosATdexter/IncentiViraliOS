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

To initialise Incentiviral call ```initWithAppIdentifier:withUserIdentifier``` which returns an Incentiviral object.
```ios
[[IncentiViral alloc] initWithAppIdentifier:@“xyz” withUserIdentifier:@“xyz”];
```
Here
- **AppIdentifier** is your application id available at the Incentiviral dashboard, this is unique to your application
- **UserIdentifier** is the unique id of the user of the app, incentives will be tracked based on this user id for your application

##Logging events
To log an event, call the logEventWithEventName:withCount:withDelegate method
```ios
[IncentiviralObject logEventWithEventName:@“eventName” withCount:1 withDelegate:self];
```

For example, if you'd like to log an event that the user has successfully shared the relevant message on facebook, you can
```java
Incentiviral.logEvent("facebookShare", 1, new LogEventListener() {
  @Override
  public void onLogEventSuccess() {
    Toast.makeText(SampleActivity.this, "Event logged successfully", Toast.LENGTH_SHORT).show();
  }

  @Override
  public void onLogEventFailure(String error) {
    Toast.makeText(SampleActivity.this, "Error in event logging: " + error, Toast.LENGTH_SHORT).show();
  }
});
```
**Note**
- There are some callbacks, mainly onLogEventSuccess and onLogEventFailure that let us know the status of the event logging

##Checking for Rewards
To check for rewards, please call the checkCurrentRewards method which is handled **asynchronously**
```java
Incentiviral.checkCurrentRewards(new RewardsListener() {
  @Override
  public void onRewardsReceived(List<Reward> rewards) {
    if(rewards!=null) {
      Toast.makeText(SampleActivity.this, rewards.get(0).getDesc(), Toast.LENGTH_SHORT).show();
    }
  }

  @Override
  public void onRewardsFailed(String error) {
    Toast.makeText(SampleActivity.this, "Error: " + error, Toast.LENGTH_SHORT).show();
  }
});
```
**Note**
- This call is completely asynchronous in nature, there is no need to add support for threading
- A callback to onRewardsReceived is received when information about the deals is received
- In case there are no active deals, this list will be blank
- In case there is an error while retrieving deals, a callback to onRewardsFailed is received

Also available, a **synchronous** call to check rewards, useful when one wants to explicitly wait for the rewards, example:

```java
List<Reward> rewards = Incentiviral.checkCurrentRewardsSync();
```
**Note**
- this should not be called from the UI thread as in might block UI processing
- can be called from an AsyncTask or any non-UI thread

##The Reward object
Once you have a list of rewards that is accessible to the user, you can use the following methods to find details of the reward itself
```java
String title = reward.getTitle();
String description = reward.getDesc();
String code = reward.getCode();
```
With the above information, you can show the incentive to the end user
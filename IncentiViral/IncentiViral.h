//
//  IncentiViral.h
//  IncentiViral
//
//  Created by Ankit Bharadwaj on 20/09/14.
//  Copyright (c) 2014 hacko. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol viralDelegate <NSObject>

@required
- (void) didReceiveRewards:(NSDictionary *) rewardsDictionary withError:(NSError *) error;
- (void) didEventLogWithError:(NSError *) error;
- (void) didReceiveRewardsList:(NSArray *) rewardsList withError:(NSError *) error;
@end

@interface IncentiViral : NSObject <NSURLConnectionDelegate> {
    
    NSMutableData *responseData;
}

/*
 Global variable to store the user's AppID for a single session.
 */
@property (nonatomic, strong) NSString *appID;

/*
 Global variable to store the user's UserID for a single session.
 */
@property (nonatomic, strong) NSString *userID;

/*
 *  Called by the developer for initial setup
 *  Developer needs to send unique AppID(App Identifier) and the UserID. User ID can be anything related to a user like Email-ID, Phone Number etc
 */
- (IncentiViral *) initWithAppIdentifier:(NSString *) appId withUserIdentifier:(NSString *)userID;

/*
 *  Called by developer to log an event
 *  eventName parameter gives developer the flexibility of creating his own triggering logic
 */
- (void) logEventWithEventName:(NSString *)eventName withCount:(NSInteger) count withDelegate:(id) delegate;

- (void) checkCurrentRewardsWithDelegate:(id) delegate;

- (void) checkStaticRewardListWithDelegate: (id) delegate;

@end

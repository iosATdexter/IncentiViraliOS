//
//  IncentiViral.m
//  IncentiViral
//
//  Created by Ankit Bharadwaj on 20/09/14.
//  Copyright (c) 2014 hacko. All rights reserved.
//

#import "IncentiViral.h"

@interface IncentiViral () {
    
    NSURLConnection *myConn_LogEvent;
    NSURLConnection *myConn_checkRewards;
    
    NSDictionary *rewardsDictionary;
    id userDelegate;
}
@end

@implementation IncentiViral

# pragma mark Library method implementations

- (id) init
{
    if (self == [super init]) {
        return self;
    }
    
    return nil;
}

- (IncentiViral *) initWithAppIdentifier:(NSString *)appIdParam withUserIdentifier:(NSString *)userIDParam
{
    self.appID = appIdParam;
    self.userID = userIDParam;
    
    return self;
}

- (IncentiViral *) setupWithAppIdentifier:(NSString *)appIdParam withUserIdentifier:(NSString *)userIDParam
{
    self.appID = appIdParam;
    self.userID = userIDParam;
    
    return self;
}

- (void) logEventWithEventName:(NSString *)eventName withCount:(NSInteger)count withDelegate:(id)delegate
{
    userDelegate = delegate;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://incentiviral.herokuapp.com/api/userEvents"]];
    NSError *error = nil;
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSDictionary *userEventData = @{@"uid":self.userID, @"appId":self.appID, @"type":eventName, @"count":[NSString stringWithFormat:@"%d", (int)count]};
    
    NSData *jsonPostData = [NSJSONSerialization dataWithJSONObject:userEventData options:NSJSONWritingPrettyPrinted error:&error];
    request.HTTPBody = jsonPostData;
    
    // Create url connection and fire request
    myConn_LogEvent = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    [myConn_LogEvent scheduleInRunLoop:[NSRunLoop mainRunLoop]
                               forMode:NSDefaultRunLoopMode];
    [myConn_LogEvent start];
}

- (void) checkCurrentRewardsWithDelegate:(id) delegate
{
    userDelegate = delegate;
    
    NSString *getURLRequest = [NSString stringWithFormat:@"http://incentiviral.herokuapp.com/api/rewards?appId=%@&uid=%@",self.appID, self
                               .userID];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getURLRequest]];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"GET";
    
    // This is how we set header fields
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Create url connection and fire request
    myConn_checkRewards = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    [myConn_checkRewards scheduleInRunLoop:[NSRunLoop mainRunLoop]
                                   forMode:NSDefaultRunLoopMode];
    [myConn_checkRewards start];
}

# pragma mark NSURLConnectionDelegate methods implementation

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    if (connection == myConn_LogEvent) {
        NSLog(@"Successfully logged event");
        
        if ([userDelegate respondsToSelector:@selector(didEventLogWithError:)]) {
            [userDelegate didEventLogWithError:nil];
        }
    }
    else if (connection == myConn_checkRewards) {
        rewardsDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        //NSLog(@"Response - %@", rewardsDictionary);
        
        if ([userDelegate respondsToSelector:@selector(didReceiveRewards:withError:)]) {
            [userDelegate didReceiveRewards:rewardsDictionary withError:nil];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"Fail!!");
    
    if (connection == myConn_LogEvent) {
        NSLog(@"Log event failed");
        
        NSError *err = [NSError errorWithDomain:@"viralDomain" code:100 userInfo:nil];
        
        if ([userDelegate respondsToSelector:@selector(didEventLogWithError:)]) {
            [userDelegate didEventLogWithError:err];
        }
    }
    else if (connection == myConn_checkRewards) {
        
        NSError *err = [NSError errorWithDomain:@"viralDomain" code:101 userInfo:nil];
        
        if ([userDelegate respondsToSelector:@selector(didReceiveRewards:withError:)]) {
            [userDelegate didReceiveRewards:nil withError:err];
        }
    }
}

@end

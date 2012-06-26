//
//  AppDelegate.m
//  ar-project
//
//  Created by Leonel Galan on 6/5/12.
//  Modified by Fadi Qassem
//  Copyright (c) 2012 NCSU. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize data = _data;
@synthesize userLocation = _userLocation;
@synthesize facebook;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    facebook = [[Facebook alloc] initWithAppId:@"351841488223055" andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }

        //check for valid session
    if (![facebook isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"user_likes",
                                @"read_stream",
                                nil];
        [facebook authorize:permissions];
        [facebook authorize:nil];
    }


    _data = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]];
    
    return YES;
}
    // Pre iOS 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url];
}
    // For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url];
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    //TODO
}

- (void)fbDidLogout {
    //TODO
}

- (void)fbDidExtendToken:(NSString*)accessToken
expiresAt:(NSDate*)expiresAt {
    //TODO
}

- (void)fbSessionInvalidated{
    //TODO
}
@end


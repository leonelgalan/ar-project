//
//  AppDelegate.h
//  ar-project
//
//  Created by Leonel Galan on 6/5/12.
//  Copyright (c) 2012 NCSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import "FBConnect.h"

#import "CLLocation+HeadingFromLocation.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate> {
    NSDictionary *data;
    CLLocation *userLocation;
    Facebook* facebook;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) CLLocation *userLocation;
@property (nonatomic, retain) Facebook* facebook;

@end


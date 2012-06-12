//
//  AppDelegate.h
//  ar-project
//
//  Created by Leonel Galan on 6/5/12.
//  Copyright (c) 2012 NCSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSDictionary *data;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *data;

@end

//
//  Picture.h
//  ar-project
//
//  Created by Leonel Galan on 6/13/12.
//  Copyright (c) 2012 NCSU. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

#import "AppDelegate.h"

@interface Picture : NSObject {
    CLLocation *location;
}

@property (nonatomic, retain) CLLocation *location;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

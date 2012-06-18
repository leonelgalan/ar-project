//
//  CLLocation.h
//  ar-project
//
//  Created by Leonel Galan on 6/7/12.
//  Copyright (c) 2012 NCSU. All rights reserved.
//

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define radiansToDegrees(x) ((x) * 180.0/M_PI)

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (HeadingFromLocation)

- (float)bearingFromLocation:(const CLLocation *)location;

@end
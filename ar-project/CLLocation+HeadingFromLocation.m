//
//  CLLocation.m
//  ar-project
//
//  Created by Leonel Galan on 6/7/12.
//  Copyright (c) 2012 NCSU. All rights reserved.
//

#import "CLLocation+HeadingFromLocation.h"

@implementation CLLocation (HeadingFromLocation)

// http://stackoverflow.com/questions/3809337/calculating-bearing-between-two-cllocationcoordinate2ds 
- (float)bearingFromLocation:(const CLLocation *)location {
    float fLat = degreesToRadians(self.coordinate.latitude);
    float fLng = degreesToRadians(self.coordinate.longitude);
    float tLat = degreesToRadians(location.coordinate.latitude);
    float tLng = degreesToRadians(location.coordinate.longitude);
    
    return radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));    
}

@end
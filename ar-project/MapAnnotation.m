//
//  MapAnnotation.m
//  ar-project
//
//  Created by Leonel Galan on 6/21/12.
//  Copyright (c) 2012 NCSU. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation
@synthesize coordinate = _coordinate;
@synthesize titletext = _titletext;
@synthesize subtitletext = _subtitletext;

- (NSString *)subtitle{
    return _subtitletext;
}

- (NSString *)title{
    return _titletext;
}

-(void)setTitle:(NSString*)strTitle {
    _titletext = strTitle;
}

-(void)setSubTitle:(NSString*)strSubTitle {
    _subtitletext = strSubTitle;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c {
    _coordinate = c;
    return self;
}

@end
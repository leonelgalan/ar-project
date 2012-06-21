//
//  Picture.m
//  ar-project
//
//  Created by Leonel Galan on 6/13/12.
//  Copyright (c) 2012 NCSU. All rights reserved.
//

#import "Picture.h"

@implementation Picture

@synthesize title = _title;
@synthesize description = _description;
@synthesize location = _location;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _title = [dictionary objectForKey:@"title"];
        _description= [dictionary objectForKey:@"description"];
        _location = [[CLLocation alloc]
                            initWithLatitude:[((NSNumber *)[dictionary objectForKey:@"latitude"]) doubleValue]
                            longitude:[((NSNumber *)[dictionary objectForKey:@"longitude"]) doubleValue]];
    }
    return self;
}

@end

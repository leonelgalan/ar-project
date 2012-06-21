//
//  UISlider+BiggerThumb.m
//  ar-project
//
//  Created by Leonel Galan on 6/21/12.
//  Copyright (c) 2012 NCSU. All rights reserved.
//

#import "UISlider+BiggerThumb.h"

@implementation UISlider_BiggerThumb


// http://stackoverflow.com/a/3154286/637094
// http://mpatric.blogspot.com/2009/04/more-responsive-sliders-on-iphone.html

#define SIZE_EXTENSION_Y -10

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, 0, SIZE_EXTENSION_Y);
    return CGRectContainsPoint(bounds, point);
}

@end

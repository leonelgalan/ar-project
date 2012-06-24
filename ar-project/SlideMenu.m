//
//  SlideMenu.m
//  ar-project
//
//  Created by Lion User on 16/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SlideMenu.h"

@implementation SlideMenu


@synthesize mapNav = _mapNav;
@synthesize listNav = _listNav;
@synthesize menuView = _menuView;
@synthesize swipeLeft = _swipeLeft;
@synthesize swipeRight = _swipeRight;
@synthesize tapMenu = _tapMenu;
@synthesize arrow = _arrow;

-(void)viewDidLoad
{
    isOpen = NO;

}


-(void)buttonTouched:(id)sender
{
    NSLog(@"button touched");
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    float delta = self.frame.size.height;
    if (self) {
    
        self.frame = CGRectOffset(self.frame, -delta, 0.0);

    }
    return self;
}

- (BOOL)buttonPressed:(UIGestureRecognizer *) gestureRecognizer {
    
    // Get the position of the point tapped in the window co-ordinate system
    CGPoint tapPoint = [gestureRecognizer locationInView:nil];
    
    // If there are no buttons beneath this tap then move to the next page if near the page edge
    UIView *viewAtBottomOfHeirachy = [self.window hitTest:tapPoint withEvent:nil];
    if ([viewAtBottomOfHeirachy isKindOfClass:[UIButton class]]) {
        return NO;
        
    }   
    return YES;
}


-(IBAction)handleMenu:(UIGestureRecognizer*)sender
{
    if(![self buttonPressed:sender])
    {
        NSLog(@"button!");
        return;
    }
    
   
    // get the height of the menu
    float delta = self.frame.size.width;
    
    if(sender == _swipeRight && isOpen == NO)
    { //swiped right
        [self animate:delta];
        NSLog(@"swipe right");

    }
    else if(sender == _swipeLeft && isOpen == YES)
    { //swiped left
        [self animate:(-delta)];
        NSLog(@"swipe left");

    }
    else {
        //tapped
        
        if(isOpen)
        {
            delta *= -1;
        }
    [self animate:delta];

    }
}

-(void)animate:(CGFloat)delta
{
    if(delta > 0){
    _arrow.image = [UIImage imageWithCGImage:_arrow.image.CGImage 
                                                scale:1.0 orientation: UIImageOrientationUpMirrored];
    }
    else {
        _arrow.image = [UIImage imageWithCGImage:_arrow.image.CGImage 
                                           scale:1.0 orientation: UIImageOrientationUp];
    }
    
    
    [UIView animateWithDuration:0.3 delay: 0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = CGRectOffset(self.frame, delta/5, 0.0); self.menuView.frame = CGRectOffset(self.menuView.frame, delta/2.5, 0.0);
    }
                     completion:^(BOOL finished){
                         //if open, set to not open
                         if (isOpen){
                             isOpen = NO;
                         }
                         else {
                             isOpen = YES;
                         }
                     }];

}
     


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



@end

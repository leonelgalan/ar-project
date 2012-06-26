//
//  SlideMenu.h
//  ar-project
//
//  Created by Lion User on 16/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
Easy navigation for the AR view, slide out at thumb level
*/

@interface SlideMenu : UIView 
{
    UIButton* listNav;
    UIButton* mapNav;
    UIImageView* arrow;
    BOOL isOpen;

}

@property (nonatomic, retain) IBOutlet UIButton* listNav;
@property (nonatomic, retain) IBOutlet UIButton* mapNav;
@property (nonatomic, retain) IBOutlet UIView* menuView;
@property (nonatomic, retain) IBOutlet UISwipeGestureRecognizer* swipeRight;
@property (nonatomic, retain) IBOutlet UISwipeGestureRecognizer* swipeLeft;
@property (nonatomic, retain) IBOutlet UITapGestureRecognizer* tapMenu;
@property (nonatomic, retain) IBOutlet UIImageView* arrow;




-(IBAction)handleMenu:(UIGestureRecognizer*)sender;
-(IBAction)buttonTouched:(id)sender;


@end

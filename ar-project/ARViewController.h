//
//  ARViewController.h
//  ar-project
//
//  Created by Leonel Galan on 6/5/12.
//  Copyright (c) 2012 NCSU. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "Picture.h"
<<<<<<< HEAD
=======
#import "SlideMenu.h"
>>>>>>> 012eb3e9730f7d4a64876efd48598fc30d58b70a



@interface ARViewController : UIViewController <CLLocationManagerDelegate>
{
    AVCaptureSession *captureSession;
    UIView *cameraView;
    UIView *radarView;
    NSMutableArray *radarViews;
    NSMutableArray *pictures;
    UIImageView *imageView;
    UISlider *slider;
<<<<<<< HEAD
=======
    SlideMenu* slideMenu;
>>>>>>> 012eb3e9730f7d4a64876efd48598fc30d58b70a
    
    CLLocationManager *locationManager;
    CLLocation *location;
    CLHeading *heading;
    
    // Temporary
    UILabel *headingLabel;
    UILabel *coordinatesLabel;
    UIView *point0;
    
}

@property (nonatomic, retain) IBOutlet UIView *cameraView;
@property (nonatomic, retain) IBOutlet UIView *radarView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UISlider *slider;
<<<<<<< HEAD
=======
@property (nonatomic, retain) IBOutlet SlideMenu *slideMenu;
>>>>>>> 012eb3e9730f7d4a64876efd48598fc30d58b70a

@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) CLHeading *heading;

// Temporary
@property (nonatomic, retain) IBOutlet UILabel *headingLabel;
@property (nonatomic, retain) IBOutlet UILabel *coordinatesLabel;
@property (nonatomic, retain) IBOutlet UIView *point0;

-(IBAction) sliderChanged:(id)sender;
-(IBAction) captureView:(id)sender;

- (void)initCamera;
-(void)touchMenu;

@end
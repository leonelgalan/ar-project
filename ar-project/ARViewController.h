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

#import "CLLocation+HeadingFromLocation.h"

@interface ARViewController : UIViewController <CLLocationManagerDelegate> {
    AVCaptureSession *captureSession;
    UIView* cameraView;
    UIImageView* imageView;
    UISlider* slider;
    
    CLLocationManager *locationManager;
    UILabel *headingLabel;
    UILabel *bearingLabel;
    
    CLLocation *location;
    CLHeading *heading;
    
    UIView *point0;
    UIView *point1;
    UIView *point2;
    
}

@property (nonatomic, retain) IBOutlet UIView *cameraView;
@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UISlider* slider;
@property (nonatomic, retain) IBOutlet UILabel *headingLabel;
@property (nonatomic, retain) IBOutlet UILabel *bearingLabel;
@property (nonatomic, retain) IBOutlet UIView *point0;
@property (nonatomic, retain) IBOutlet UIView *point1;
@property (nonatomic, retain) IBOutlet UIView *point2;

-(IBAction) sliderChanged:(id)sender;

- (void)initCamera;

@end
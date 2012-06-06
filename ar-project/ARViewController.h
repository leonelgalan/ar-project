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

@interface ARViewController : UIViewController <CLLocationManagerDelegate> {
    AVCaptureSession *captureSession;
    UIView* cameraView;
    UIImageView* imageView;
    UISlider* slider;
    
    CLLocationManager *locationManager;
    UITextView *locationTextView;
}

@property (nonatomic, retain) IBOutlet UIView *cameraView;
@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UISlider* slider;
@property (nonatomic, retain) IBOutlet UITextView *locationTextView;

-(IBAction) sliderChanged:(id)sender;

- (void)initCamera;

@end
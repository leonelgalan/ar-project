//
//  ARViewController.m
//  ar-project
//
//  Created by Leonel Galan on 6/5/12.
//  Copyright (c) 2012 NCSU. All rights reserved.
//

#import "ARViewController.h"

@interface ARViewController ()

@end

@implementation ARViewController

@synthesize cameraView = _cameraView;
@synthesize radarView = _radarView;
@synthesize imageView = _imageView;
@synthesize slider = _slider;
@synthesize location = _location;
@synthesize heading = _heading;

@synthesize headingLabel = _headingLabel;
@synthesize bearingLabel = _bearingLabel;
@synthesize point0 = _point0;
@synthesize point1 = _point1;
@synthesize point2 = _point2;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initLocationServices];
    [self initCamera];
    [self initRadar];
}

- (void)initCamera {
    captureSession = [[AVCaptureSession alloc] init];
	
	AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if (videoDevice) { 
		NSError *error;
		AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
		if (!error) {
			if ([captureSession canAddInput:videoIn]) {
				[captureSession addInput:videoIn];
			} else {
				NSLog(@"Couldn't add video input");
			}
		} else {
			NSLog(@"Couldn't create video input");
		}
	} else {
		NSLog(@"Couldn't create video capture device");
	}
	
	[captureSession startRunning];
	
	AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
	previewLayer.frame = _cameraView.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	[[_cameraView layer] addSublayer:previewLayer];
    
    // Vertical Slider, rotates in the center
    _slider.transform = CGAffineTransformRotate(_slider.transform, 270.0/180*M_PI);
}

-(IBAction) sliderChanged:(id)sender {
    [_imageView setAlpha:_slider.value];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma Location Manager
-(void)initLocationServices { 
    if( [CLLocationManager locationServicesEnabled] && [CLLocationManager headingAvailable]) {
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		locationManager.distanceFilter = 1;
		[locationManager startUpdatingLocation];
        
        locationManager.headingFilter = 1;
		[locationManager startUpdatingHeading];	
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    location = newLocation;
    //Override Location to: 35.78528, -78.66330 (Pullen Rd.)
    location = [[CLLocation alloc] initWithLatitude:35.78528 longitude:-78.66330];
    [self redraw];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    heading = newHeading;
    [self redraw];
}

- (void)redraw {
    
    for (int i = 0; i<(int)radarViews.count; i++) {
        UIView *picture_view = [radarViews objectAtIndex:i];
        Picture *picture = [pictures objectAtIndex:i];
        
//        if ([location distanceFromLocation:picture.location] < 75) {
            CLLocationDistance distance = [location distanceFromLocation:picture.location];
            float bearing = [location bearingFromLocation:picture.location];
            
            float x = sin(degreesToRadians(heading.trueHeading - bearing)) * distance / 2;
            float y = cos(degreesToRadians(heading.trueHeading - bearing)) * distance / 2;
            
            picture_view.frame = CGRectMake(_point0.frame.origin.x - round(x), _point0.frame.origin.y - round(y), 10.0, 10.0);
//        }
    }
    
    if (heading.headingAccuracy > 0) {
        [_headingLabel setText:[NSString stringWithFormat:@"%.0f°", heading.trueHeading]];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

#pragma Radar
- (void)initRadar {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    pictures = [[NSMutableArray alloc] initWithCapacity:[[appDelegate.data allValues] count]];
    radarViews = [[NSMutableArray alloc] initWithCapacity:[[appDelegate.data allValues] count]];
    for (NSDictionary *dictionary in [appDelegate.data allValues]) {
        Picture *picture = [[Picture alloc] initWithDictionary:dictionary];
        [pictures addObject:picture];
        
        UIView *picture_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10.0, 10.0)];
        [picture_view setBackgroundColor:[UIColor redColor]];
        
        [radarViews addObject:picture_view];
        [_radarView addSubview:picture_view];
    }
}

@end
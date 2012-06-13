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
@synthesize imageView = _imageView;
@synthesize slider = _slider;
@synthesize headingLabel = _headingLabel;
@synthesize bearingLabel = _bearingLabel;

@synthesize point1 = _point1;
@synthesize point2 = _point2;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initLocationServices];
    [self initCamera];
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
    [self redraw];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    heading = newHeading;
    [self redraw];
}

- (void)redraw {
    CLLocation* location1 = [[CLLocation alloc] initWithLatitude:35.78453 longitude:-78.66633];
    //Bell tower 35.78620, -78.66351
    //35.78448, -78.66503
    //35.78453, -78.66633
    //35.78424, -78.66538



    CLLocation* location2 = [[CLLocation alloc] initWithLatitude:35.78424 longitude:-78.66538];
    
    CLLocationDistance distance1 = [location distanceFromLocation:location1];
    float bearing1 = [location bearingFromLocation:location1];
    CLLocationDistance distance2 = [location distanceFromLocation:location2];
    float bearing2 = [location bearingFromLocation:location2];
    
    NSLog(@"PICTURE: latitude %+.6f, longitude %+.6f", location1.coordinate.latitude, location1.coordinate.longitude);
    NSLog(@"IPAD: latitude %+.6f, longitude %+.6f", location.coordinate.latitude, location.coordinate.longitude);
    NSLog(@"Distance: %lf", distance1);
    NSLog(@"Bearing: %+.6f DEG", bearing1);
    NSLog(@"Distance: %lf", distance2);
    NSLog(@"Bearing: %+.6f DEG", bearing2);
    [_bearingLabel setText:[NSString stringWithFormat:@"%+.0f°", bearing1]];
    
    if (heading.headingAccuracy > 0) {
        NSLog(@"%@", [NSString stringWithFormat:@"Magnetic Heading: %f", heading.magneticHeading]);
        NSLog(@"%@", [NSString stringWithFormat:@"True Heading: %f", heading.trueHeading]);
        [_headingLabel setText:[NSString stringWithFormat:@"%+.0f°", heading.trueHeading]];
    }
    
    //X = SIN(RADIANS(ANGLE))*DISTANCE
    float x1 = sin(degreesToRadians(heading.trueHeading - bearing1)) * distance1;
    float y1 = cos(degreesToRadians(heading.trueHeading - bearing1)) * distance1;
    _point1.frame = CGRectMake(_point0.frame.origin.x - round(x1), _point0.frame.origin.y - round(y1), 10.0, 10.0);
    
    float x2 = sin(degreesToRadians(heading.trueHeading - bearing2)) * distance2;
    float y2 = cos(degreesToRadians(heading.trueHeading - bearing2)) * distance2;
    _point2.frame = CGRectMake(_point0.frame.origin.x - round(x2), _point0.frame.origin.y - round(y2), 10.0, 10.0);
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

@end
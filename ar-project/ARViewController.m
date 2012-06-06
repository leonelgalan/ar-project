//
//  ARViewController.m
//  ar-project
//
//  Created by Leonel Galan on 6/5/12.
//  Copyright (c) 2012 NCSU. All rights reserved.
//

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define radiansToDegrees(x) ((x) * 180.0/M_PI)

#import "ARViewController.h"

@interface ARViewController ()

@end

@implementation ARViewController

@synthesize cameraView = _cameraView;
@synthesize imageView = _imageView;
@synthesize slider = _slider;
@synthesize locationTextView = _locationTextView;

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

//TODO: REFACTOR THIS, MOVE AWAY FROM VIEWCONTROLLER
//http://stackoverflow.com/questions/3809337/calculating-bearing-between-two-cllocationcoordinate2ds 
- (float) getHeadingForDirectionFromCoordinate:(CLLocation *)fromLoc toCoordinate:(CLLocation *)toLoc
{
    float fLat = degreesToRadians(fromLoc.coordinate.latitude);
    float fLng = degreesToRadians(fromLoc.coordinate.longitude);
    float tLat = degreesToRadians(toLoc.coordinate.latitude);
    float tLng = degreesToRadians(toLoc.coordinate.longitude);
    
    return radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocation* pictureLocation = [[CLLocation alloc] initWithLatitude:35.784289 longitude:-78.665167];
    CLLocationDistance distance = [newLocation distanceFromLocation:pictureLocation];
    float bearing = [self getHeadingForDirectionFromCoordinate:newLocation toCoordinate:pictureLocation];

    NSLog(@"PICTURE: latitude %+.6f, longitude %+.6f", pictureLocation.coordinate.latitude, pictureLocation.coordinate.longitude);
    NSLog(@"IPAD: latitude %+.6f, longitude %+.6f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    NSLog(@"Distance: %lf", distance);
    NSLog(@"Bearing: %+.6f DEG", bearing);
    NSLog(@"Bearing: %+.6f RAD", degreesToRadians(bearing));
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy > 0) {
        NSLog(@"%@", [NSString stringWithFormat:@"Magnetic Heading: %f", newHeading.magneticHeading]);
        NSLog(@"%@", [NSString stringWithFormat:@"True Heading: %f", newHeading.trueHeading]);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

@end
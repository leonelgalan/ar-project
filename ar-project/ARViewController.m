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
@synthesize slideMenu = _slideMenu;
@synthesize facebookShare = _facebookShare;
@synthesize headingLabel = _headingLabel;
@synthesize coordinatesLabel = _coordinatesLabel;
@synthesize point0 = _point0;
@synthesize sharedPicture = _sharedPicture;

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


-(IBAction) captureView:(id)sender {
    // http://developer.apple.com/library/ios/#qa/qa1703/_index.html
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    
    // camera image size extended to screen ratio so it captures the entire screen
    //
    CGSize imageSize = CGSizeMake( (CGFloat)self.view.frame.size.width, (CGFloat)self.view.frame.size.height);
    
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    /////////
    // -renderInContext: renders in the coordinate space of the layer,
    // so we must first apply the layer's geometry to the graphics context
    CGContextSaveGState(context);
    // Center the context around the window's anchor point
    CGContextTranslateCTM(context, [_cameraView center].x, [_cameraView center].y);
    // Apply the window's transform about the anchor point
    CGContextConcatCTM(context, [self.view transform]);
    // Offset by the portion of the bounds left of and above the anchor point
    CGContextTranslateCTM(context,
                          -[_cameraView bounds].size.width * [[_cameraView layer] anchorPoint].x,
                          -[_cameraView bounds].size.height * [[_cameraView layer] anchorPoint].y);
    
    // Render the layer hierarchy to the current context
    [[_cameraView layer] renderInContext:context];
    
    // Restore the context
    CGContextRestoreGState(context);
    
    
    /////////
    _sharedPicture = UIGraphicsGetImageFromCurrentImageContext();
    
    [self showMessage];

}
- (void)showMessage{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Share!"
                            message:@"Share image on Facebook?"
                            delegate:self
                            cancelButtonTitle:nil
                            otherButtonTitles:nil];
    
    [message addButtonWithTitle:@"No"];
    [message addButtonWithTitle:@"Yes"];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    [title isEqualToString:@"Yes"]? [self sharePictures] : NSLog(@"No, not sharing.");
}

-(void)sharePictures
{
    
        NSLog(@"sharing pictures whaaaat");
    NSData* imageData = UIImageJPEGRepresentation(_sharedPicture, 90);
    Facebook* fb = [(AppDelegate *)[[UIApplication sharedApplication] delegate] facebook   ];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[fb accessToken],@"access_token",
                                    @"message", @"text",
                                    imageData, @"source",
                                    nil];
    [fb requestWithGraphPath:@"me/photos" 
                   andParams:params 
               andHttpMethod:@"POST" 
                 andDelegate:fb.self];
    
    
}

- (void) image:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary*)info {
    
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
    
    Picture *picture = [pictures objectAtIndex:1];
    CLLocationDistance distance = [location distanceFromLocation:picture.location];
    float bearing = [location bearingFromLocation:picture.location];
    float angle = 34.1;
    float zero = heading.trueHeading - angle / 2;
    if (zero < bearing && bearing < (zero + angle)) {
        float x = round(((bearing - zero) * 768 / angle) -  768 / 2);
        _imageView.frame = CGRectMake(x, _imageView.frame.origin.y, _imageView.frame.size.width, _imageView.frame.size.height);
    } else {
        float x = 1024;
        _imageView.frame = CGRectMake(x, _imageView.frame.origin.y, _imageView.frame.size.width, _imageView.frame.size.height);
    }
    
    
    [_coordinatesLabel setText:[NSString stringWithFormat:@"%+.4f, %+.4f°", location.coordinate.latitude, location.coordinate.longitude]];
    
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
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
@synthesize coordinatesLabel = _coordinatesLabel;
@synthesize point0 = _point0;

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
    CGSize imageSize = CGSizeMake( (CGFloat)480.0, (CGFloat)720.0 );
    
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Start with the view...
    //
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, [self.view center].x, [self.view center].y);
    CGContextConcatCTM(context, [self.view transform]);
    CGContextTranslateCTM(context,-[self.view bounds].size.width * [[self.view layer] anchorPoint].x,-[self.view bounds].size.height * [[self.view layer] anchorPoint].y);
    [[self.view layer] renderInContext:context];
    CGContextRestoreGState(context);
    
    // ...then repeat for every subview from back to front
    //
    for (UIView *subView in [self.view subviews])
    {
        if ( [subView respondsToSelector:@selector(screen)] )
            if ( [(UIWindow *)subView screen] == [UIScreen mainScreen] )
                continue;
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, [subView center].x, [subView center].y);
        CGContextConcatCTM(context, [subView transform]);
        CGContextTranslateCTM(context,-[subView bounds].size.width * [[subView layer] anchorPoint].x,-[subView bounds].size.height * [[subView layer] anchorPoint].y);
        [[subView layer] renderInContext:context];
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();   // autoreleased image
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.userLocation = newLocation;
    
    location = newLocation;
    //Override Location to: 35.78528, -78.66330 (Pullen Rd.)
    //location = [[CLLocation alloc] initWithLatitude:35.78528 longitude:-78.66330];
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
        float x = round(((bearing - zero) * 1368 / angle) -  1368 / 2);
        _imageView.frame = CGRectMake(x - 300, _imageView.frame.origin.y, _imageView.frame.size.width, _imageView.frame.size.height);
//        [UIView animateWithDuration:0.3f
//                              delay:0.0f
//                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
//                         animations:^{
//                             _imageView.frame = CGRectMake(x - 300, _imageView.frame.origin.y, _imageView.frame.size.width, _imageView.frame.size.height);
//                         }
//                         completion:nil];

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
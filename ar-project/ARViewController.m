//
//  ARViewController.m
//  ar-project
//
//  Created by Leonel Galan on 6/5/12.
//  Copyright (c) 2012 NCSU. All rights reserved.
//

#import "ARViewController.h"
#import <ImageIO/ImageIO.h>


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
@synthesize stillImageOutput = _stillImageOutput;
@synthesize captureSession = _captureSession;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLocationServices];
    [self initCamera];
    [self initRadar];
    
    self.navigationController.tabBarController
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

    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    [captureSession addOutput:_stillImageOutput];

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

-(IBAction)captureView:(id)sender
{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections){
        for (AVCaptureInputPort *port in [connection inputPorts]){
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo]){
                
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { 
            break; 
        }
    }
    
    NSLog(@"about to request a capture from: %@", _stillImageOutput);
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error){
        
        CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
        if (exifAttachments){
            
            // Do something with the attachments if you want to. 
            NSLog(@"attachements: %@", exifAttachments);
        }
        else
            NSLog(@"no attachments");
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        
        UIImage *overlay = imageView.image;
        
        UIGraphicsBeginImageContext(image.size);
        
        // Use existing opacity as is
        [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
        
        // Apply supplied opacity if applicable
        [image drawInRect:CGRectMake(0,0,overlay.size.width,overlay.size.height) blendMode:kCGBlendModeNormal alpha:0.8];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        _sharedPicture = newImage;
    }];
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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.userLocation = newLocation;
    
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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
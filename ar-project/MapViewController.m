//
//  MapViewController.m
//  ar-project
//
//  Created by Leonel Galan on 6/12/12.
//  Copyright (c) 2012 NCSU. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView = _mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _mapView.delegate = self;
    [NSThread detachNewThreadSelector:@selector(displayMap) toTarget:self withObject:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)displayMap {
    [_mapView.userLocation  addObserver:self
                            forKeyPath:@"location"  
                            options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)  
                            context:NULL];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (NSDictionary *dictionary in [appDelegate.data allValues]) {
        Picture *picture = [[Picture alloc] initWithDictionary:dictionary];
        MapAnnotation *addAnnotation = [[MapAnnotation alloc] initWithCoordinate:picture.location.coordinate];
        
        [addAnnotation setTitle:picture.title];
        [addAnnotation setSubTitle:picture.description];
        [_mapView addAnnotation:addAnnotation];
    }
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.userLocation = _mapView.userLocation.location;
    // Durham 35.99265, -78.90518
    // NC State 35.78461, -78.66448
    if ([_mapView showsUserLocation]) {
        MKCoordinateSpan span = MKCoordinateSpanMake(0.002389, 0.005681);
        MKCoordinateRegion region = MKCoordinateRegionMake(_mapView.userLocation.location.coordinate, span);
        [_mapView setRegion:region animated:YES];
    }
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

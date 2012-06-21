//
//  MapViewController.h
//  ar-project
//
//  Created by Leonel Galan on 6/12/12.
//  Copyright (c) 2012 NCSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "AppDelegate.h"
#import "MapAnnotation.h"
#import "Picture.h"

@interface MapViewController : UIViewController <MKMapViewDelegate> {
    MKMapView *mapView;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@end

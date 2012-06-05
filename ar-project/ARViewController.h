//
//  ARViewController.h
//  ar-project
//
//  Created by Leonel Galan on 6/5/12.
//  Copyright (c) 2012 NCSU. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface ARViewController : UIViewController {
    AVCaptureSession *captureSession;
    UIView* cameraView;
}

@property (nonatomic, retain) IBOutlet UIView *cameraView;

- (void)initCamera;

@end
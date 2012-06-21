//
//  ListViewController.h
//  ar-project
//
//  Created by Leonel Galan on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "Picture.h"

@interface ListViewController : UITableViewController {
    NSMutableArray *nearby;
    NSMutableArray *rest;
}

@end

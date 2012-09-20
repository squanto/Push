//
//  ProfileBroadcastsViewController.h
//  push
//
//  Created by hugo on 9/20/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileBroadcastsViewController : PFQueryTableViewController

@property (strong) PFUser *user;

@end

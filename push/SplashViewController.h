//
//  SplashViewController.h
//  push
//
//  Created by hugo on 9/7/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface SplashViewController : UIViewController <PFLogInViewControllerDelegate>

@property (strong) UIImageView *pulseView;

@property (strong) PFLogInViewController *loginVC;

@property CGRect logoFrame;

@end

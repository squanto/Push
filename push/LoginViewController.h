//
//  LoginViewController.h
//  push
//
//  Created by hugo on 9/7/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginViewController : PFLogInViewController <PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>

@end

//
//  LoginViewController.m
//  push
//
//  Created by hugo on 9/25/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "TabViewController.h"
#import "SignupViewController.h"

@interface LoginViewController ()<PFLogInViewControllerDelegate>

@end

@implementation LoginViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten;
    [self.logInView.dismissButton setAlpha:0.0];
    
    self.delegate = self;
    self.logInView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pulseSplash.png"]];
    self.logInView.logo.center = CGPointMake(165, 50);
    
    [self setSignUpController:[SignupViewController new]];
    self.signUpController.fields = PFSignUpFieldsDefault;
    self.signUpController.signUpView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pulseSplash.png"]];
}

-(void)viewDidLayoutSubviews
{
    // Lay out the logo frame..
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([PFUser currentUser]) {
        [self presentModalViewController:[TabViewController new] animated:YES];
    }
}


/************
 
 Parse METHODS
 
 ************/

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [[PFUser currentUser] save];
    [self presentModalViewController:[TabViewController new] animated:YES];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}



-(void)viewDidUnload
{
    [super viewDidUnload];
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

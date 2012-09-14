//
//  SplashViewController.m
//  push
//
//  Created by hugo on 9/7/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "SplashViewController.h"
#import "TabViewController.h"
#import "SignupViewController.h"

@interface SplashViewController()



@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shatteredBG.png"]];
    
    // Label Setup
    self.pulseView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pulseSplash.png"]];
    self.pulseView.center = CGPointMake(165, 50);
    [self.view addSubview:self.pulseView];
    [self.view setNeedsDisplay];
    
    
    // Parse Login Screen
    self.loginVC = [PFLogInViewController new];
    self.loginVC.fields = PFLogInFieldsDefault;
    self.loginVC.delegate = self;
    self.loginVC.logInView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pulseSplash.png"]];
    self.logoFrame = self.loginVC.logInView.logo.frame;
    
    [self.loginVC setSignUpController:[SignupViewController new]];
    self.loginVC.signUpController.fields = PFSignUpFieldsDefault;
    self.loginVC.signUpController.signUpView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pulseSplash.png"]];
//    [self.navigationController presentModalViewController:self.loginVC animated:YES];
}


-(void)viewDidAppear:(BOOL)animated
{
    if (![PFUser currentUser]) {
        [self.navigationController presentModalViewController:self.loginVC animated:YES];
    } else {
        NSLog(@"Successfully Signed In: %@", [[PFUser currentUser] email]);
        NSLog(@"USERNAME: %@", [[PFUser currentUser] username]);
        [self presentModalViewController:[TabViewController new] animated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Resize logo if rotated. 
    if ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
        self.loginVC.signUpController.signUpView.logo.frame = CGRectMake(20, 30, 100, 60);
        self.loginVC.logInView.logo.frame = CGRectMake(20, 30, 70, 35);
    } else {
        self.loginVC.logInView.logo.frame = self.logoFrame;
        self.loginVC.signUpController.signUpView.logo.frame = self.logoFrame;
    }
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [[PFUser currentUser] setObject:[[PFTwitterUtils twitter] screenName] forKey:@"username"];
    [[PFUser currentUser] save];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}



// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
//    [[PFUser currentUser] setObject:[[PFTwitterUtils twitter] screenName] forKey:@"twitterName"];
    NSLog(@"Log in VC Called twitter?");
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

@end

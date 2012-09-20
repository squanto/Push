//
//  ProfileViewController.m
//  push
//
//  Created by hugo on 9/9/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "ProfileViewController.h"
#import "RecordViewController.h"
#import <Parse/Parse.h>
#import "PulseStore.h"

@interface ProfileViewController ()

@property (strong) UIImageView *profileImageView;

@end

@implementation ProfileViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
    
    // Record Navigationx
    UIBarButtonItem *recordButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showRecordModally)];
    self.navigationItem.rightBarButtonItem = recordButton;
    
    if (self.user == [PFUser currentUser]) {
        self.navigationItem.title = @"Me";
    } else {
        self.navigationItem.title = self.user.username;
    }
    self.navigationItem.title = @"Me";
    
    // Query for the user's profile picture
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    dispatch_async(dispatch_get_current_queue(), ^{
        UIImage *profileImage = [PulseStore getProfilePictureForUser:self.user];
        self.profileImageView.image = profileImage;
        [self.view addSubview:self.profileImageView];
    });
}




-(void)showRecordModally
{
    UINavigationController *recordNavVC = [[UINavigationController alloc] initWithRootViewController:[RecordViewController new]];
    [self.navigationController presentModalViewController:recordNavVC animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end

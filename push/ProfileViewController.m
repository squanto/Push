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

@property (strong) UILabel *usernameLabel;
@property (strong) UIButton *followButton;

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

-(void)viewDidLayoutSubviews
{
    self.profileImageView.frame = CGRectMake(20, 20, 100, 100);
    self.usernameLabel.frame = CGRectMake(130, 20, 190, 50);
    self.followButton.frame = CGRectMake(20, 130, 100, 60);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // scroll view setup
    CGRect fullScreenRect = [[UIScreen mainScreen] applicationFrame];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:fullScreenRect];
    scrollView.contentSize = CGSizeMake(320, 960);
    self.view = scrollView;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
    
    // Record Navigation
    UIBarButtonItem *recordButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showRecordModally)];
    self.navigationItem.rightBarButtonItem = recordButton;
    
    // Navigation top trick.
    if (self.user == [PFUser currentUser]) {
        self.navigationItem.title = @"Me";
    } else {
        self.navigationItem.title = self.user.username;
    }
    self.navigationItem.title = @"Me";
    
    // Query for the user's profile picture
    self.profileImageView = [UIImageView new];
    dispatch_async(dispatch_get_current_queue(), ^{
        UIImage *profileImage = [PulseStore getProfilePictureForUser:self.user];
        self.profileImageView.image = profileImage;
        [self.view addSubview:self.profileImageView];
    });
    
    // Setting up the username label
    self.usernameLabel = [UILabel new];
    self.usernameLabel.backgroundColor = self.view.backgroundColor;
    self.usernameLabel.text =  [self.user username];
    [self.view addSubview:self.usernameLabel];
    
    
    // Setting up the follow button
    if (![self.user.username isEqualToString:[[PFUser currentUser] username]]) {
        NSLog(@"profileVC username: %@, Current username: %@", self.user.username, [[PFUser currentUser] username]);
        self.followButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.followButton addTarget:self action:@selector(followButtonPressed) forControlEvents:UIControlEventTouchDown];
        [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
        [self.view addSubview:self.followButton];
    }
}

// Toggle Follow Action
-(void)followButtonPressed
{
    if (self.followButton.titleLabel.text == @"Follow") {
        PFObject *followRelationship = [PFObject objectWithClassName:@"followRelationship"];
        [followRelationship setObject:[PFUser currentUser] forKey:@"fromUser"];
        [followRelationship setObject:self.user forKey:@"toUser"];
        [followRelationship saveInBackground];
        [self.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"followRelationship"];
        [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        [query whereKey:@"toUser" equalTo:self.user];
        PFObject *followRelationship = [query getFirstObject];
        [followRelationship deleteInBackground];
        [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
    }
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

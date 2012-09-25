//
//  ProfileViewController.m
//  push
//
//  Created by hugo on 9/9/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileBroadcastsViewController.h"
#import "LoginViewController.h"
#import "RecordingViewController.h"
#import <Parse/Parse.h>
#import "PulseStore.h"

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong) UIImageView *profileImageView;

@property (strong) NSArray *followingUsers;
@property (strong) NSArray *followedUsers;

@property (strong) UILabel *usernameLabel;
@property (strong) UIButton *followButton;
@property (strong) UIButton *followingUsersButton;
@property (strong) UIButton *followedUsersButton;
@property (strong) UIButton *logOutButton;
@property (strong) UIButton *broadcastsButton;

@property (strong) UITableViewController *followingTableVC;
@property (strong) UITableViewController *followedTableVC;

@property (strong) UIBarButtonItem *recordButton;
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
    self.followingUsersButton.frame = CGRectMake(20, 220, 130, 60);
    self.followedUsersButton.frame = CGRectMake(20, 300, 130, 60);
    self.logOutButton.frame = CGRectMake(40, 380, 100, 50);
    self.broadcastsButton.frame = CGRectMake(170, 220, 120, 60);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.followingUsers = [PulseStore getFollowingUsers:self.user];
    self.followedUsers = [PulseStore getFollowedUsers:self.user];
    
    // scroll view setup
    CGRect fullScreenRect = [[UIScreen mainScreen] applicationFrame];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:fullScreenRect];
    scrollView.contentSize = CGSizeMake(320, 450);
    self.view = scrollView;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
    
    // Record Navigation
    self.recordButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showRecordModally)];
    self.navigationItem.rightBarButtonItem = self.recordButton;
    
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
    
    // Broadcast Button Setup
    self.broadcastsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.broadcastsButton addTarget:self action:@selector(broadcastsButtonPressed) forControlEvents:UIControlEventTouchDown];
    [self.broadcastsButton setTitle:@"Broadcasts" forState:UIControlStateNormal];
    [self.view addSubview:self.broadcastsButton];

    // But I really really want to check these things EVERY time the view appears
    // Setting up the follow button
    
    // User - Specific
    if ([self.user.username isEqualToString:[[PFUser currentUser] username]]) {
        self.navigationItem.title = @"Me";
        NSLog(@"I'm the current user!");
        // Log out button setup
        self.logOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.logOutButton addTarget:self action:@selector(logOutButtonPressed) forControlEvents:UIControlEventTouchDown];
        [self.logOutButton setTitle:@"log out" forState:UIControlStateNormal];
        [self.view addSubview:self.logOutButton];
    } else {
        self.navigationItem.title = self.user.username;
        NSLog(@"profileVC username: %@, Current username: %@", self.user.username, [[PFUser currentUser] username]);
        self.followButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.followButton addTarget:self action:@selector(followButtonPressed) forControlEvents:UIControlEventTouchDown];
        
        // Check so that you don't follow someone twice.
        if ([self isUserFollowingUser]) {
            [self.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
        } else {
            [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
        }
        [self.view addSubview:self.followButton];
    }
}

-(BOOL)isUserFollowingUser
{
    for (int i = 0; i < self.followedUsers.count; i++) {
        PFObject *userRelationship = [self.followedUsers objectAtIndex:i];
        [userRelationship fetchIfNeeded];
        if ([[[userRelationship objectForKey:@"toUser"] objectId]  isEqual:self.user.objectId]) {
            return YES;
        }
    }
    return NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
    
    // Set up users I follow button
    self.followingUsersButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.followingUsersButton addTarget:self action:@selector(showFollowingUsers) forControlEvents:UIControlEventTouchDown];
    NSString *followingUsersButtonLabel = [NSString stringWithFormat:@"Following %u users", self.followingUsers.count];
    [self.followingUsersButton setTitle:followingUsersButtonLabel forState:UIControlStateNormal];
    [self.view addSubview:self.followingUsersButton];
    
    // Set up users that follow me button
    self.followedUsersButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.followedUsersButton addTarget:self action:@selector(showFollowedUsers) forControlEvents:UIControlEventTouchDown];
    NSString *followedUserButtonLabel = [NSString stringWithFormat:@"%u following %@", self.followedUsers.count, self.user.username];
    [self.followedUsersButton setTitle:followedUserButtonLabel forState:UIControlStateNormal];
    [self.view addSubview:self.followedUsersButton];
}

-(void)showFollowingUsers
{
    // Present a modal table view
    self.followingTableVC = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.followingTableVC.navigationItem.title = [NSString stringWithFormat:@"Users %@ follows", self.user.username];
    self.followingTableVC.tableView.delegate = self;
    self.followingTableVC.tableView.dataSource = self;
    self.followingTableVC.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
    self.followingTableVC.navigationItem.rightBarButtonItem = self.recordButton;
    [self.navigationController pushViewController:self.followingTableVC animated:YES];
}

-(void)showFollowedUsers
{
    // Present a modal table view
    self.followedTableVC = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.followedTableVC.navigationItem.title = [NSString stringWithFormat:@"Users following %@", self.user.username];
    self.followedTableVC.tableView.delegate = self;
    self.followedTableVC.tableView.dataSource = self;
    self.followedTableVC.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
    self.followedTableVC.navigationItem.rightBarButtonItem = self.recordButton;
    [self.navigationController pushViewController:self.followedTableVC animated:YES];
}

// Toggle Follow Action
-(void)followButtonPressed
{
    NSLog(@"Follow Button Pressed!");
    if ([self.followButton.titleLabel.text isEqualToString:@"Follow"]) {
        PFObject *followRelationship = [PFObject objectWithClassName:@"followRelationship"];
        [followRelationship setObject:[PFUser currentUser] forKey:@"fromUser"];
        [followRelationship setObject:self.user forKey:@"toUser"];
        [followRelationship setObject:[PFUser currentUser].objectId forKey:@"fromUserId"];
        [followRelationship setObject:self.user.objectId forKey:@"toUserId"];
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

-(void)broadcastsButtonPressed
{
    NSLog(@"Broadcasts Button Pressed!");
    ProfileBroadcastsViewController *broadcastsVC = [[ProfileBroadcastsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    broadcastsVC.user = self.user;
    [self.navigationController pushViewController:broadcastsVC animated:YES];
}

-(void)logOutButtonPressed
{
    NSLog(@"Log Out Button Pressed!");
    [PFUser logOut];
    [self.navigationController presentViewController:[LoginViewController new] animated:YES completion:nil];
}

/************
 
 Table Delegate
 
 ************/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // For multiple table views with the same delegate.
    if (tableView == self.followingTableVC.tableView) {
        [PFObject fetchAllIfNeeded:self.followingUsers];
        PFUser *toUser = [[self.followingUsers objectAtIndex:indexPath.row] objectForKey:@"toUser"];
        [toUser fetchIfNeeded];
        cell.textLabel.text = toUser.username;
    }
    if (tableView == self.followedTableVC.tableView) {
        [PFObject fetchAllIfNeeded:self.followedUsers];
        PFObject *userRelationships = [self.followedUsers objectAtIndex:indexPath.row];
        PFUser *fromUser = [userRelationships objectForKey:@"fromUser"];
        [fromUser fetchIfNeeded];
        cell.textLabel.text = fromUser.username;
    }
    
    return cell;
}


-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.followingTableVC.tableView) {
        return self.followingUsers.count;
    }
    if (tableView == self.followedTableVC.tableView) {
        return self.followedUsers.count;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *username = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    ProfileViewController *profileVC = [ProfileViewController new];
    profileVC.user = [PulseStore getUserWithUsername:username];
    [self.navigationController pushViewController:profileVC animated:YES];
}


-(void)showRecordModally
{
    UINavigationController *recordNavVC = [[UINavigationController alloc] initWithRootViewController:[RecordingViewController new]];
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

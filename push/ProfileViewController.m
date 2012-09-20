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

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong) UIImageView *profileImageView;

@property (strong) NSArray *followingUsers;
@property (strong) NSArray *followedUsers;

@property (strong) UILabel *usernameLabel;
@property (strong) UIButton *followButton;
@property (strong) UIButton *followingUsersButton;
@property (strong) UIButton *followedUsersButton;

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
    self.followingUsersButton.frame = CGRectMake(20, 220, 150, 60);
    self.followedUsersButton.frame = CGRectMake(20, 300, 150, 60);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.followingUsers = [PulseStore getFollowingUsers:self.user];
    self.followedUsers = [PulseStore getFollowedUsers:self.user];
    
    // scroll view setup
    CGRect fullScreenRect = [[UIScreen mainScreen] applicationFrame];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:fullScreenRect];
    scrollView.contentSize = CGSizeMake(320, 960);
    self.view = scrollView;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
    
    // Record Navigation
    self.recordButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showRecordModally)];
    self.navigationItem.rightBarButtonItem = self.recordButton;
    
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

    // But I really really want to check these things EVERY time the view appears
    // Setting up the follow button
    if (![self.user.username isEqualToString:[[PFUser currentUser] username]]) {
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
    // Make these view proramatically.
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
    
    if (tableView == self.followingTableVC.tableView) {
        [PFObject fetchAllIfNeeded:self.followingUsers];
        PFUser *user = [[self.followingUsers objectAtIndex:indexPath.row] objectForKey:@"toUser"];
        [user fetchIfNeeded];
        cell.textLabel.text = user.username;
    }
    if (tableView == self.followedTableVC.tableView) {
        [PFObject fetchAllIfNeeded:self.followedUsers];
        PFObject *userRelationships = [self.followedUsers objectAtIndex:indexPath.row];
        PFUser *user = [userRelationships objectForKey:@"fromUser"];
        // ????
        [user fetchIfNeeded];
        NSString *username = user.username;
        cell.textLabel.text = username;
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

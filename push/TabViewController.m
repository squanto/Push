//
//  DashboardViewController.m
//  push
//
//  Created by hugo on 9/7/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "TabViewController.h"
#import <Parse/Parse.h>
#import "RecordingViewController.h"
#import "ProfileViewController.h"
#import "TimelineViewController.h"
#import "DiscoverViewController.h"
#import "ConnectViewController.h"

@interface TabViewController ()

@end

@implementation TabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *recordButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showRecordModally)];
        self.navigationItem.rightBarButtonItem = recordButton;
        
        // Timeline
        UIImage *homeButtonImage = [UIImage imageNamed:@"house.png"];
        UITabBarItem *homeButtonItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:homeButtonImage tag:0];
        UINavigationController *timelineNavVC = [[UINavigationController alloc] initWithRootViewController:[TimelineViewController new]];
        timelineNavVC.tabBarItem = homeButtonItem;
        
        // Connect
        UIImage *connectButtonImage = [UIImage imageNamed:@"letter_closed.png"];
        UITabBarItem *connectButtonItem = [[UITabBarItem alloc] initWithTitle:@"Connect" image:connectButtonImage tag:1];
        UINavigationController *connectNavVC = [[UINavigationController alloc] initWithRootViewController:[ConnectViewController new]];
        connectNavVC.tabBarItem = connectButtonItem;
        
        // Discover.
        UIImage *globeButtonImage = [UIImage imageNamed:@"globe.png"];
        UITabBarItem *globeButtonItem = [[UITabBarItem alloc] initWithTitle:@"Discover" image:globeButtonImage tag:2];
        UINavigationController *discoverNavVC = [[UINavigationController alloc] initWithRootViewController:[DiscoverViewController new]];
        discoverNavVC.tabBarItem = globeButtonItem;
        
        // Profile
        UIImage *profileImage = [UIImage imageNamed:@"pacman.png"];
        UITabBarItem *profileItem = [[UITabBarItem alloc] initWithTitle:@"Me" image:profileImage tag:3];
        ProfileViewController *profileVC = [ProfileViewController new];
        profileVC.user = [PFUser currentUser];
        UINavigationController *profileNavVC = [[UINavigationController alloc] initWithRootViewController:profileVC];
        profileNavVC.tabBarItem = profileItem;
        
        self.viewControllers = [NSArray arrayWithObjects:timelineNavVC, connectNavVC, discoverNavVC, profileNavVC, nil];
    }
    return self;
}

-(void)showRecordModally
{
    UINavigationController *recordNavVC = [[UINavigationController alloc] initWithRootViewController:[RecordingViewController new]];
    [self.navigationController presentModalViewController:recordNavVC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

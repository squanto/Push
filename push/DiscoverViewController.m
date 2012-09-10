//
//  DiscoverViewController.m
//  push
//
//  Created by hugo on 9/10/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "DiscoverViewController.h"
#import "RecordViewController.h"
#import "SearchDiscoverViewController.h"

@interface DiscoverViewController ()<UISearchBarDelegate>

@property (strong) IBOutlet UISearchBar *searchBar;

@end

@implementation DiscoverViewController

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
    UIBarButtonItem *recordButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showRecordModally)];
    self.navigationItem.rightBarButtonItem = recordButton;
    self.navigationItem.title = @"Discover";
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.searchBar.placeholder = @"Find friends, search #hashtags";
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    SearchDiscoverViewController *searchDiscoveryVC = [SearchDiscoverViewController new];
    searchDiscoveryVC.rootVC = self;
    searchDiscoveryVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    searchDiscoveryVC.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentModalViewController:searchDiscoveryVC animated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)showRecordModally
{
    UINavigationController *recordNavVC = [[UINavigationController alloc] initWithRootViewController:[RecordViewController new]];
    [self.navigationController presentModalViewController:recordNavVC animated:YES];
}

// Add a discovery table view with different sections
//  1. Random Cool People To Follow
//  2. Featured Clips From People You Follow
// Add Search functionality for people to follow.
// 

@end

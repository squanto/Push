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

@interface DiscoverViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong) UISearchBar *searchBar;

@end

@implementation DiscoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *recordButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showRecordModally)];
    self.navigationItem.rightBarButtonItem = recordButton;
    self.navigationItem.title = @"Discover";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
    
    // Table customizing.
    CGRect tableFrame = CGRectMake(0, 0, 320, 480);
    self.discoveryTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
    self.discoveryTable.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.discoveryTable];
    
    
    // Search Bar customization
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.searchBar.placeholder = @"Friends, #hashtags";
    self.searchBar.barStyle = UIBarStyleBlack;
    self.searchBar.backgroundImage = [UIImage imageNamed:@"noisy_grid.png"];
    self.searchBar.translucent = YES;
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *textToSearch = searchBar.text;
    NSLog(@"Text To Search: %@", textToSearch);
    [self.searchBar resignFirstResponder];
    
    // Update the custom table view. Make asyncronous calls to parse from here.
    // Present a new view controller via navigation here..
    
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"Began Editing!");
    [self.view endEditing:YES];
    UINavigationController *searchDiscoveryVC = [[UINavigationController alloc] initWithRootViewController: [SearchDiscoverViewController new]];
    searchDiscoveryVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    searchDiscoveryVC.navigationBarHidden = NO;
    [self.navigationController presentModalViewController:searchDiscoveryVC animated:YES];
}

// A Very Useful snippet:
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"Touch Registered!s");
//    [self.view endEditing:YES];
//}


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

//
//  DiscoverViewController.m
//  push
//
//  Created by hugo on 9/10/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableViewController.h"
#import "RecordingViewController.h"
#import "SearchDiscoverViewController.h"

@interface DiscoverViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong) UISearchBar *searchBar;

@end

@implementation DiscoverViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // customize.
    }
    return self;
}

-(void)viewDidLayoutSubviews
{
    // Set frame here
    self.searchBar.frame = CGRectMake(0, 0, 320, 50);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    DiscoverTableViewController *queryVC = [DiscoverTableViewController new];
    [self addChildViewController:queryVC];
    queryVC.view.frame = CGRectMake(0, 50, 320, 430);
    [self.view addSubview:queryVC.view];
    [queryVC didMoveToParentViewController:self];
    
    UIBarButtonItem *recordButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showRecordModally)];
    self.navigationItem.rightBarButtonItem = recordButton;
    self.navigationItem.title = @"Discover";
    
    // View Customization
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];

    // Search bar customization
    self.searchBar = [UISearchBar new];
    self.searchBar.backgroundImage = [UIImage imageNamed:@"noisy_grid.png"];
    self.searchBar.placeholder = @"Search for friends.";
    self.searchBar.barStyle = UIBarStyleBlack;
    self.searchBar.translucent = YES;
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *textToSearch = searchBar.text;
    NSLog(@"Text To Search: %@", textToSearch);
    [self.searchBar resignFirstResponder];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    UINavigationController *searchDiscoveryVC = [[UINavigationController alloc] initWithRootViewController: [[SearchDiscoverViewController alloc] initWithStyle:UITableViewStyleGrouped]];
    searchDiscoveryVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    searchDiscoveryVC.navigationBarHidden = NO;
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
    UINavigationController *recordNavVC = [[UINavigationController alloc] initWithRootViewController:[RecordingViewController new]];
    [self.navigationController presentModalViewController:recordNavVC animated:YES];
}

@end
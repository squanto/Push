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
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.searchBar.showsCancelButton = YES;
    self.searchBar.placeholder = @"Friends, #hashtags";
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

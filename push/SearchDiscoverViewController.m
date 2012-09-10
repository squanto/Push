//
//  SearchDiscoverViewController.m
//  push
//
//  Created by hugo on 9/10/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "SearchDiscoverViewController.h"
#import "DiscoverViewController.h"

@interface SearchDiscoverViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *recentSearchesTable;

@end

@implementation SearchDiscoverViewController
@synthesize recentSearchesTable;
@synthesize searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.recentSearchesTable = [UITableView new];
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        self.searchBar.showsCancelButton = YES;
        self.searchBar.delegate = self;
        [self.view addSubview:self.searchBar];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Cancel Button PRessed");
    [self.presentingViewController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setRecentSearchesTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

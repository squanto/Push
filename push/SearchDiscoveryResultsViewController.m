//
//  SearchDiscoveryResultsViewController.m
//  push
//
//  Created by hugo on 9/11/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "SearchDiscoveryResultsViewController.h"
#import "RecordViewController.h"
#import <Parse/Parse.h>

@interface SearchDiscoveryResultsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong) UITableView *resultsTable;
@property (strong) NSArray *searchResults;

@end

@implementation SearchDiscoveryResultsViewController

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
    
    // Configuring the results table
    CGRect tableFrame = CGRectMake(0, 0, 320, 480);
    self.resultsTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
    self.resultsTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
    self.resultsTable.delegate = self;
    self.resultsTable.dataSource = self;
    [self.view addSubview:self.resultsTable];
    
    // Adding the record button
    UIBarButtonItem *recordButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showRecordModally)];
    self.navigationItem.rightBarButtonItem = recordButton;
    self.navigationItem.title = @"Discover";
    
    // Blast off!
    [self searchQuery];
}

-(void)searchQuery
{
    NSLog(@"Resluts Query made!");
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:self.searchText];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.searchResults = [[NSArray alloc] initWithArray:objects];
        } else {
            NSLog(@"Error error: %@", [error userInfo]);
        }
         [self.resultsTable reloadData];
    }];
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"TABLE COUNT! %u", self.searchResults.count);
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [[self.searchResults objectAtIndex:indexPath.row] username];
    return cell;
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

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
    
    // Adding the record button
    UIBarButtonItem *recordButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showRecordModally)];
    self.navigationItem.rightBarButtonItem = recordButton;
    self.navigationItem.title = @"Discover";
}

-(NSArray *)searchQuery
{
    NSLog(@"Resluts Query made!");
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"username" containsString:self.searchText];
    return [query findObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *searchResults = [self searchQuery];
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
    
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

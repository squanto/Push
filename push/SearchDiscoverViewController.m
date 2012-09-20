//
//  SearchDiscoverViewController.m
//  push
//
//  Created by hugo on 9/10/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "SearchDiscoverViewController.h"
#import "DiscoverViewController.h"
#import "SearchDiscoveryResultsViewController.h"

@interface SearchDiscoverViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation SearchDiscoverViewController
@synthesize searchBar;

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.className = @"userSearches";
        self.pullToRefreshEnabled = NO;
        self.paginationEnabled = NO;
        self.objectsPerPage = 20;
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
        self.tableView.frame = CGRectMake(0, 0, 320, 430);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 320.0, 44.0)];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    [self.view addSubview:self.searchBar];
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    [searchBarView addSubview:searchBar];
    self.navigationItem.titleView = searchBarView;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.searchBar becomeFirstResponder];
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    [query whereKey:@"user" equalTo:[[PFUser currentUser] username]];
    [query orderByDescending:@"createdAt"];
    
    return query;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
                       object:(PFObject *)object
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [object objectForKey:@"searchText"];
    
    return cell;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Cancel Button PRessed");
    [self.searchBar resignFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Save a copy in parse.
    NSLog(@"%@", self.searchBar.text);
    PFObject *search = [PFObject objectWithClassName:@"userSearches"];
    [search setObject:[[PFUser currentUser] username] forKey:@"user"];
    [search setObject:[self.searchBar.text lowercaseString] forKey:@"searchText"];
    [search saveInBackground];
    
    [self pushToResultsVCWithSearchText:self.searchBar.text];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Pushed From  a table view!!");
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self pushToResultsVCWithSearchText:cell.textLabel.text];
}


-(void)pushToResultsVCWithSearchText:(NSString *)queryText
{
    // Make the Results VC and present it.
    SearchDiscoveryResultsViewController *resultsVC = [SearchDiscoveryResultsViewController new];
    resultsVC.searchText = [queryText lowercaseString];
    NSLog(@"About To Push!");
    [self.searchBar endEditing:YES];
    [self.navigationController pushViewController:resultsVC animated:YES];
}






- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end

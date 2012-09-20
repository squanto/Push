//
//  DiscoverTableViewController.m
//  push
//
//  Created by hugo on 9/19/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "DiscoverTableViewController.h"
#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "PulseStore.h"

@interface DiscoverTableViewController()  <UITableViewDataSource, UITableViewDelegate>

@end

@implementation DiscoverTableViewController

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // customize
        self.className = @"User";
        //        self.textKey = @"username";
        //        self.imageKey = @"UserPhotoImage";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 20;
        self.loadingViewEnabled = YES;
        self.isLoading = YES;
    }
    
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

/************
 
 Table Delegate
 
 ************/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [object objectForKey:@"username"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Where the pushing action happens!!
    NSString *username = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    ProfileViewController *profileVC = [ProfileViewController new];
    profileVC.user = [PulseStore getUserWithUsername:username];;
    [self.navigationController pushViewController:profileVC animated:YES];
}


/************
 
 PULSE METHODS
 
 ************/

// Called when Objects are loaded from PArse via PFQquery
-(void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
}

// called before a PFQuery is fired to get more objects
-(void)objectsWillLoad
{
    [super objectsWillLoad];
}


- (PFQuery *)queryForTable {
    PFQuery *query = [PFUser query];
    //    PFQuery *query = [PFQuery queryWithClassName:self.className];
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}




-(void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end

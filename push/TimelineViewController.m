//
//  TimelineViewController.m
//  push
//
//  Created by hugo on 9/10/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "TimelineViewController.h"
#import "RecordingViewController.h"
#import "AudioCell.h"

@interface TimelineViewController ()<AVAudioPlayerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong) AVPlayer *player;

@end

@implementation TimelineViewController

-(id)initWithStyle:(UITableViewStyle)style className:(NSString *)aClassName
{
    self = [super initWithStyle:style className:aClassName];
    if (self) {
        //customize For Parse
        self.className = @"audioObject";
        self.paginationEnabled = YES;
        self.objectsPerPage = 10;
        self.loadingViewEnabled = YES;
        self.isLoading = YES;
        self.textKey = @"title";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Appearance
    self.navigationItem.title = @"Home";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
    
    // The right way to load de;legate / data source
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // ??
    self.textKey = @"user";
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    // REcord button setup.
    UIBarButtonItem *recordButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showRecordModally)];
    self.navigationItem.rightBarButtonItem = recordButton;
    
    
}


/***************
 Parse Methods
 **************/

// Called when Objects are loaded from PArse via PFQquery
-(void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    NSLog(@"Objects Loaded! from timeline!");
}


// called before a PFQuery is fired to get more objects
-(void)objectsWillLoad
{
    [super objectsWillLoad];
    NSLog(@"Objects Will Load");
}


-(PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    
    // Filter for users that you follow
    PFQuery *relationshipQuery = [PFQuery queryWithClassName:@"followRelationship"];
    [relationshipQuery whereKey:@"fromUserId" equalTo:[PFUser currentUser].objectId];
    
    [query whereKey:@"user" matchesKey:@"toUser" inQuery:relationshipQuery];
    
    // Check the (automated) cache first
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    // I can add more constraints here!!!
    [query orderByDescending:@"createdAt"];
    return query;
}

// Overriden to have custom table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
                       object:(PFObject *)object
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [object objectForKey:@"title"];
    PFUser *user = [object objectForKey:@"user"];
    [user fetchIfNeeded];
    cell.detailTextLabel.text = user.username;
    cell.imageView.image = [UIImage imageWithData:[[user objectForKey:@"userPhotoImage"] getData]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected Row At: %@", indexPath);
    if (indexPath.row == self.objects.count) {
        [self loadNextPage];
    } else {
        PFObject *audioObject = [self.objects objectAtIndex:indexPath.row];
        PFFile *audioFile = [audioObject objectForKey:@"audioFile"];
        NSURL *audioURL = [NSURL URLWithString:[audioFile url]];
        self.player = [[AVPlayer alloc] initWithURL:audioURL];
        [self.player play];
    }
}



-(void)showRecordModally
{
    UINavigationController *recordNavVC = [[UINavigationController alloc] initWithRootViewController:[RecordingViewController new]];
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

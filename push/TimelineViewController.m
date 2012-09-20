//
//  TimelineViewController.m
//  push
//
//  Created by hugo on 9/10/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "TimelineViewController.h"
#import "RecordViewController.h"
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
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
    // The right way to load de;legate / data source
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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
}


// called before a PFQuery is fired to get more objects
-(void)objectsWillLoad
{
    [super objectsWillLoad];
}


-(PFQuery *)queryForTable
{
    PFQuery *userQuery = [PFQuery queryWithClassName:@"followRelationship"];
    [userQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    
    // Check the (automated) cache first
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    // I can add more constraints here!!!
    [query orderByDescending:@"createdAt"];
    return query;
}

// Overriden to have custom table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [object objectForKey:@"title"];
    PFUser *userOfAudioBroadcast = [object objectForKey:@"user"];
    [userOfAudioBroadcast refresh];
    NSString *username = [userOfAudioBroadcast username];
    cell.detailTextLabel.text = username;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.objects.count) {
        [self loadNextPage];
    } else {
        PFObject *audioObject = [self.objects objectAtIndex:indexPath.row];
        PFFile *audioFile = [audioObject objectForKey:@"audioFile"];
        NSURL *audioURL = [NSURL URLWithString:[audioFile url]];
//        NSData *audioData = [NSData dataWithContentsOfURL:audioURL];
    
        // https://developer.apple.com/library/mac/#documentation/AVFoundation/Reference/AVPlayer_Class/Reference/Reference.html
        
        // self.player = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
        
        self.player = [[AVPlayer alloc] initWithURL:audioURL];
        NSLog(@"AUDIO URL!   %@", audioURL);
        NSLog(@"Start Playing!");
        [self.player play];
    }
}





 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NextPage";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // ??
    cell.textLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dustBG.png"]];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dustBG.png"]];
    
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.text = @"Load More";
    
    return cell;
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

@end

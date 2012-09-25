//
//  ProfileBroadcastsViewController.m
//  push
//
//  Created by hugo on 9/20/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "ProfileBroadcastsViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ProfileBroadcastsViewController () <UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate>

@property (strong) AVPlayer *player;

@end

@implementation ProfileBroadcastsViewController

-(id)initWithStyle:(UITableViewStyle)style className:(NSString *)aClassName
{
    self = [super initWithStyle:style className:aClassName];
    if (self) {
        //customize For Parse
        self.className = @"audioObject";
        self.pullToRefreshEnabled = NO;
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
    NSString *title = [NSString stringWithFormat:@"%@'s Broadcasts", self.user.username];
    self.navigationItem.title = title;
    
    // ??
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
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
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    
    [query whereKey:@"user" equalTo:self.user];
    
    // Check the (automated) cache first
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    // I can add more constraints here!!!
    [query orderByDescending:@"createdAt"];
    return query;
}


/*******************
 Table View Delegate
 *******************/

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
    [self.user fetchIfNeeded];
    cell.imageView.image = [UIImage imageWithData:[[self.user objectForKey:@"userPhotoImage"] getData]];
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
        self.player = [[AVPlayer alloc] initWithURL:audioURL];
        [self.player play];
    }
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

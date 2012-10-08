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
#import "ProfileCell.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


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
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
    self.tableView.backgroundColor = UIColorFromRGB(0xe9edf0);
    
    
    // The right way to load de;legate / data source
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80.0;
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
    
    NSString *cellIdentifier = @"cell";
    ProfileCell *cell = (ProfileCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // on tableview, register nib.
    if (!cell) {
        // If you didn't get a valid cell reference back, unload a cell from the nib
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:nil options:nil];
        for (id obj in nibArray) {
            if ([obj isMemberOfClass:[ProfileCell class]]) {
                // Assign cell to obj
                cell = (ProfileCell *)obj;
                break;
            }
        }
    }
    
//    @property (strong, nonatomic) IBOutlet UILabel *titleLabel;
//    @property (strong, nonatomic) IBOutlet UILabel *timeLabel;
//    @property (strong, nonatomic) IBOutlet UIButton *playButton;

    // Adding borders.
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor lightGrayColor].CGColor;
    bottomBorder.borderWidth = 0.5;
    bottomBorder.frame = CGRectMake(0, cell.layer.frame.size.height, cell.layer.frame.size.width, 2);
    [cell.contentView.layer addSublayer:bottomBorder];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.borderColor = [UIColor lightGrayColor].CGColor;
    topBorder.borderWidth = 0.5;
    topBorder.frame = CGRectMake(0, 0, cell.layer.frame.size.width, 2);
    [cell.contentView.layer addSublayer:topBorder];
    
    
    cell.audioFile = [object objectForKey:@"audioFile"];
    cell.titleLabel.text = [object objectForKey:@"title"];
    PFUser *user = [object objectForKey:@"user"];
    [user fetchIfNeeded];
    cell.userLabel.text = [user objectForKey:@"username"];
    
    // Message button hack
    UIImage *playBg = [[UIImage imageNamed:@"buttonBg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 5, 20, 5)];
    [cell.playButton setBackgroundImage:playBg forState:UIControlStateNormal];
    
//    cell.imageView.image = [UIImage imageWithData:[[user objectForKey:@"userPhotoImage"] getData]];

    
    // Images coming in have to be the same dimensions.
    // Parse is the loader class (??)
    UIImage *profileImage = [UIImage imageWithData:[[user objectForKey:@"userPhotoImage"] getData]];
    // hmm..., uiscreen main screen scale
    UIImage *cellProfileImage = [UIImage imageWithCGImage:[profileImage CGImage] scale:    [[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:cellProfileImage];
    [imageView setFrame:CGRectMake(13, 13, 43, 43)];
    imageView.layer.cornerRadius = 21.0;
    imageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:imageView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *username = [(ProfileCell*)[tableView cellForRowAtIndexPath:indexPath] userLabel].text;
    NSLog(@"User selected: %@", username);
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

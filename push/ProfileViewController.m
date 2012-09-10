//
//  ProfileViewController.m
//  push
//
//  Created by hugo on 9/9/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>

@interface ProfileViewController ()<AVAudioPlayerDelegate>

@property (strong) AVAudioPlayer *audioPlayer;

@end

@implementation ProfileViewController

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
}

-(void)viewDidAppear:(BOOL)animated
{
    // add a table view of audio files. When you click on one, it plays.
    PFQuery *profileQuery = [PFQuery queryWithClassName:@"audioObject"];
    NSString *username = [[PFUser currentUser] username];
    [profileQuery whereKey:@"user" equalTo:username];
    NSArray *audioFiles = [profileQuery findObjects];
    NSLog(@"AUDIO ARRAY!: %@", audioFiles);
    PFFile *audioFile = [[audioFiles objectAtIndex:0] objectForKey:@"audioFile"];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:[audioFile getData] error:nil];
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
    NSLog(@"%@", audioFile);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player
                      successfully:(BOOL)flag {
    NSLog(@"Finished Playing successfully!!");
}

@end

//
//  TimelineViewController.m
//  push
//
//  Created by hugo on 9/10/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "TimelineViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RecordViewController.h"

@interface TimelineViewController ()<AVAudioPlayerDelegate>

@end

@implementation TimelineViewController

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
    UIBarButtonItem *recordButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showRecordModally)];
    self.navigationItem.rightBarButtonItem = recordButton;
    self.navigationItem.title = @"Home";
}


// Make this happen when you click on a message of someone you're following. 
//-(void)viewDidAppear:(BOOL)animated
//{
//    // add a table view of audio files. When you click on one, it plays.
//    PFQuery *profileQuery = [PFQuery queryWithClassName:@"audioObject"];
//    NSString *username = [[PFUser currentUser] username];
//    [profileQuery whereKey:@"user" equalTo:username];
//    NSArray *audioFiles = [profileQuery findObjects];
//    NSLog(@"AUDIO ARRAY!: %@", audioFiles);
//    PFFile *audioFile = [[audioFiles objectAtIndex:0] objectForKey:@"audioFile"];
//    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:[audioFile getData] error:nil];
//    self.audioPlayer.delegate = self;
//    [self.audioPlayer play];
//    NSLog(@"%@", audioFile);
//}

// Finish Playing Action!
//-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player
//                      successfully:(BOOL)flag {
//    NSLog(@"Finished Playing successfully!!");
//}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

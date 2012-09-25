//
//  RecordViewController.m
//  push
//
//  Created by hugo on 9/7/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordMetaDataViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PulseStore.h"

@interface RecordViewController ()<AVAudioRecorderDelegate>

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (strong) PFObject *audioObject;
@property (strong) AVAudioRecorder *recorder;

@end

@implementation RecordViewController
@synthesize nameLabel;


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
    // Navigation Things
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelNavVC)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.title = @"Broadcast";
    
    
    // Recording things
    NSURL* documentDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    self.audioURL = [documentDir URLByAppendingPathComponent:@"audio.wav"];
    
    NSDictionary* options = @{
    AVFormatIDKey : [NSNumber numberWithInt:kAudioFormatLinearPCM],
    AVSampleRateKey : [NSNumber numberWithDouble:48000],
    AVNumberOfChannelsKey : [NSNumber numberWithInt:2]
    };
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.audioURL settings:options error:nil];
    self.recorder.delegate = self;
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)cancelNavVC
{
    [self dismissModalViewControllerAnimated:YES];
}



- (IBAction)recordTouchDown:(id)sender
{
    [self.recorder record];
}



- (IBAction)recordButtonPressed
{
    if (!self.recorder.recording) {
        [self.recorder record];
    } else {
        [self.recorder stop];
    }
}


-(void)audioRecorderDidFinishRecording:(AVAudioRecorder*)recorder
                          successfully:(BOOL)flag {
    
    RecordMetaDataViewController *metaDataVC = [RecordMetaDataViewController new];
    
    PFObject *audioObject = [PFObject objectWithClassName:@"audioObject"];
    PFFile *audioFile = [PFFile fileWithName:@"audio.wav" contentsAtPath:[self.audioURL path]];
    
    [audioFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [audioObject setObject:audioFile forKey:@"audioFile"];
        [audioObject setObject:[PFUser currentUser] forKey:@"user"];
        [audioObject setObject:[[NSDate date] description] forKey:@"title"];
        [audioObject saveInBackground];
    }];
    metaDataVC.audioURL = self.audioURL;
    metaDataVC.audioObject = audioObject;
    
    [self.navigationController pushViewController:metaDataVC animated:YES];
}



@end

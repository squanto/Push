//
//  RecordingViewController.m
//  push
//
//  Created by hugo on 9/7/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "RecordingViewController.h"
#import "RecordMetaDataViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PulseStore.h"

@interface RecordingViewController ()<AVAudioRecorderDelegate>

@property (strong) PFObject *audioObject;
@property (strong) AVAudioRecorder *recorder;
@property (strong) UIButton *recordButton;

@end

@implementation RecordingViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
    
    // Navigation Things
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelNavVC)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.title = @"Broadcast";
    
    
    // Recording things
    NSURL* documentDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    self.audioURL = [documentDir URLByAppendingPathComponent:@"audio.wav"];
    
    NSDictionary *settings = @{
    AVFormatIDKey : [NSNumber numberWithInt:kAudioFormatLinearPCM],
    AVSampleRateKey : [NSNumber numberWithDouble:48000],
    AVNumberOfChannelsKey : [NSNumber numberWithInt:2]
    };
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.audioURL settings:settings error:nil];
    self.recorder.delegate = self;
    
    self.recordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.recordButton addTarget:self action:@selector(recordTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.recordButton addTarget:self action:@selector(recordTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [self.recordButton setTitle:@"Hold To Record" forState:UIControlStateNormal];
    [self.view addSubview:self.recordButton];
}

-(void)viewDidLayoutSubviews
{
    // Lay out button!
    self.recordButton.frame = CGRectMake(85, 100, 150, 150);
}

-(void)cancelNavVC
{
    [self dismissModalViewControllerAnimated:YES];
}

// start recording
-(void)recordTouchDown
{
    if([self.recorder prepareToRecord]) {
        [self.recorder record];
    }
    NSLog(@"Now it's recording %c <==", self.recorder.recording);
}


// stop recording
-(void)recordTouchUp
{
    [self.recorder stop];
    NSLog(@"Stop Recording, %c", self.recorder.recording);
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


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
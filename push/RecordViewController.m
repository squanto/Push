//
//  RecordViewController.m
//  push
//
//  Created by hugo on 9/7/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "RecordViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface RecordViewController ()<AVAudioPlayerDelegate, AVAudioRecorderDelegate>
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@property (strong) AVAudioRecorder *recorder;
@property (strong) AVAudioPlayer *player;

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
    NSURL* documentDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSURL* audioURL = [documentDir URLByAppendingPathComponent:@"audio.wav"];
    
    NSDictionary* options = @{
    AVFormatIDKey : [NSNumber numberWithInt:kAudioFormatLinearPCM],
    AVSampleRateKey : [NSNumber numberWithDouble:48000],
    AVNumberOfChannelsKey : [NSNumber numberWithInt:2]
    };
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:audioURL settings:options error:nil];
    self.recorder.delegate = self;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
    self.player.delegate = self;
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



- (IBAction)recordButtonPressed
{
    if (!self.recorder.recording) {
        if (self.player.playing) {
            [self playButtonPressed];
        }
        [self.recorder record];
    } else {
        [self.recorder stop];
    }
//    [self resetRecordingTitles];
}

- (IBAction)playButtonPressed
{
    if (!self.player.playing) {
        if (self.recorder.recording) {
            [self recordButtonPressed];
        }
        [self.player play];
    } else {
        [self.player stop];
    }
//    [self resetPlayingTitles];
}

- (IBAction)sendButtonPressed
{
    
}

-(void)resetPlayingTitles {
    if (self.player.playing) {
        [self.playButton setTitle:@"End Playing" forState:UIControlStateNormal];
        [self.playButton setTitle:@"End Playing" forState:UIControlStateHighlighted];
    } else {
        [self.playButton setTitle:@"Begin Playing" forState:UIControlStateNormal];
        [self.playButton setTitle:@"Begin Playing" forState:UIControlStateHighlighted];
    }
}

-(void)resetRecordingTitles {
    if (self.recorder.recording) {
        [self.recordButton setTitle:@"End Recording" forState:UIControlStateNormal];
        [self.recordButton setTitle:@"End Recording" forState:UIControlStateHighlighted];
    } else {
        [self.recordButton setTitle:@"Begin Recording" forState:UIControlStateNormal];
        [self.recordButton setTitle:@"Begin Recording" forState:UIControlStateHighlighted];
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player
                      successfully:(BOOL)flag {
//    [self resetPlayingTitles];
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder*)recorder
                          successfully:(BOOL)flag {
//    [self resetRecordingTitles];
}



@end

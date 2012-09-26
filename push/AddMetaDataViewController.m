//
//  AddMetaDataViewController.m
//  push
//
//  Created by hugo on 9/25/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "AddMetaDataViewController.h"
#import "RecordingViewController.h"
#import "PulseStore.h"
#import <AVFoundation/AVFoundation.h>

@interface AddMetaDataViewController ()<UITextFieldDelegate, AVAudioPlayerDelegate>

@property (strong) UITextField *titleField;
@property (strong) UIButton *playButton;
@property (strong) UIButton *broadcastButton;
@property (strong) AVAudioPlayer *player;

@end

@implementation AddMetaDataViewController

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
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
    
    // set up title field
    self.titleField = [UITextField new];
    self.titleField.placeholder = @"Title";
    self.titleField.borderStyle = UITextBorderStyleRoundedRect;
    self.titleField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.titleField.delegate = self;
    [self.view addSubview:self.titleField];
    
    // set up broadcast button.
    self.broadcastButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.broadcastButton addTarget:self action:@selector(broadcastButtonPressed) forControlEvents:UIControlEventTouchDown];
    [self.broadcastButton setTitle:@"Broadcast" forState:UIControlStateNormal];
    [self.view addSubview:self.broadcastButton];
    
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.audioURL error:&error];
    self.player.delegate = self;
    
    if (error) {
         NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [self.player prepareToPlay];
    }
    
    // set up play button
    self.playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.playButton addTarget:self action:@selector(playButtonPressed) forControlEvents:UIControlEventTouchDown];
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    [self.view addSubview:self.playButton];
}

-(void)viewDidLayoutSubviews
{
    self.titleField.frame = CGRectMake(15, 20, 200, 40);
    self.playButton.frame = CGRectMake(230, 20, 75, 40);
    self.broadcastButton.frame = CGRectMake(110, 100, 100, 100);
}

-(void)playButtonPressed
{
    if (!self.player.playing)
        [self.player play];
    else
        [self.player stop];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"Finished Playing Successfully!");
}

- (void)broadcastButtonPressed
{
    [self broadcast];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self broadcast];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.titleField resignFirstResponder];
}

-(void)broadcast
{
    
    PFObject *audioObject = [PFObject objectWithClassName:@"audioObject"];
    PFFile *audioFile = [PFFile fileWithName:@"audio.wav" contentsAtPath:[self.audioURL path]];
    
    [audioFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [audioObject setObject:audioFile forKey:@"audioFile"];
        [audioObject setObject:[PFUser currentUser] forKey:@"user"];
        if (self.titleField.text) {
            [audioObject setObject:self.titleField.text forKey:@"title"];
        } else {
            [audioObject setObject:[[NSDate date] description] forKey:@"title"];
        }
        [audioObject saveInBackground];
    }];
    
    [self dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

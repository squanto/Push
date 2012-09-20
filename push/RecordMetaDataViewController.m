//
//  RecordMetaDataViewController.m
//  push
//
//  Created by hugo on 9/10/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "RecordMetaDataViewController.h"
#import "RecordViewController.h"
#import "PulseStore.h"
#import <AVFoundation/AVFoundation.h>

@interface RecordMetaDataViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *titleField;

@property (strong) AVAudioPlayer *player;

@end

@implementation RecordMetaDataViewController
@synthesize titleField = _titleField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.audioURL error:nil];
    self.titleField.delegate = self;
}


-(IBAction)playButtonPressed
{
    if (!self.player.playing)
        [self.player play];
    else
        [self.player stop];
}

- (IBAction)broadcastButtonPressed
{
    [self broadcast];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self broadcast];
    return YES;
}


-(void)broadcast
{
    [PulseStore updateAudioObjectWithTitle:self.titleField.text];
    [self dismissModalViewControllerAnimated:YES];
}





- (void)viewDidUnload
{
    [self setTitleField:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

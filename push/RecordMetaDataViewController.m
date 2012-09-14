//
//  RecordMetaDataViewController.m
//  push
//
//  Created by hugo on 9/10/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "RecordMetaDataViewController.h"
#import "RecordViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface RecordMetaDataViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UITextField *friendTagField;

@property (strong) AVAudioPlayer *player;

@end

@implementation RecordMetaDataViewController
@synthesize titleField = _titleField;
@synthesize friendTagField = _friendTagField;

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
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.audioURL error:nil];
    
    
    self.titleField.delegate = self;
    self.friendTagField.delegate = self;
}



// Make it all have default values though.
// Add current location
// Add a title
// Add hash tags
// Geotag it.
    // CLLocation Object!
// Tag someone in it.
-(IBAction)playButtonPressed
{
    if (!self.player.playing)
        [self.player play];
    else
        [self.player stop];
}

- (IBAction)broadcastButtonPressed
{
    // Set object instead of add object....
    NSMutableArray *friends = [[self.friendTagField.text componentsSeparatedByString:@","] copy];
    [self.audioObject setObject:self.titleField.text forKey:@"title"];
    [self.audioObject addObject:friends forKey:@"friendsTagged"];
    [self.audioObject saveInBackground];
    NSLog(@"Finish Broadcast Upload");
    [self dismissModalViewControllerAnimated:YES];
}


-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag
{
    NSLog(@"Finished Playing Successfully!");
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    
    return YES;
}


- (void)viewDidUnload
{
    [self setTitleField:nil];
    [self setFriendTagField:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

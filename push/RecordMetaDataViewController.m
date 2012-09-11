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
@property (strong, nonatomic) IBOutlet UITextField *hashTagField;
@property (strong, nonatomic) IBOutlet UITextField *friendTagField;
@property (strong, nonatomic) IBOutlet UISwitch *geoTagOption;



@property (strong) AVAudioPlayer *player;

@end

@implementation RecordMetaDataViewController
@synthesize titleField = _titleField;
@synthesize hashTagField = _hashTagField;
@synthesize friendTagField = _friendTagField;
@synthesize geoTagOption = _geoTagOption;

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
    self.friendTagField.delegate = self;
}

- (void)viewDidUnload
{
    [self setTitleField:nil];
    [self setHashTagField:nil];
    [self setFriendTagField:nil];
    [self setGeoTagOption:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    // Take the metadata from the text fields and add them to the audioObject
    [self broadcast];
}


-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player
                      successfully:(BOOL)flag {
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)broadcast
{
    [self.audioObject addObject:self.titleField.text forKey:@"title"];
    [self.audioObject addObject:self.friendTagField.text forKey:@"friendsTagged"];
    [self.audioObject addObject:self.hashTagField.text forKey:@"hashTags"];
    [self.audioObject addObject:[NSString stringWithFormat:@"%c", self.geoTagOption.on] forKey:@"geotag"];
    [self.audioObject saveInBackground];
    NSLog(@"Finish Broadcast Upload");
    //[self.navigationController dismissModalViewControllerAnimated:YES];
}

@end

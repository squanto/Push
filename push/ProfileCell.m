//
//  ProfileCell.m
//  Backplane
//
//  Created by hugo on 9/28/12.
//  Copyright (c) 2012 Hugo Melo. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "ProfileCell.h"

@interface ProfileCell()

@property (strong) AVPlayer *player;

@end

@implementation ProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
-(IBAction)playButtonPressed:(id)sender
{
    NSLog(@"Play Button Pressed!");
    NSURL *audioURL = [NSURL URLWithString:[self.audioFile url]];
    self.player = [[AVPlayer alloc] initWithURL:audioURL];
    [self.player play];
}


-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end

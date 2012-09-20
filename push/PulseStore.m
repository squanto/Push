//
//  PulseStore.m
//  push
//
//  Created by hugo on 9/19/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import <Parse/Parse.h>
#import "PulseStore.h"

static PFObject *audioTransitionObject;

@implementation PulseStore


+(RecordMetaDataViewController *)prepareMetaDataWithAudioURL:(NSURL *)audioURL
{
    RecordMetaDataViewController *metaDataVC = [RecordMetaDataViewController new];
    
    PFObject *audioObject = [PFObject objectWithClassName:@"audioObject"];
    PFFile *audioFile = [PFFile fileWithName:@"audio.wav" contentsAtPath:[audioURL path]];
    
    [audioFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [audioObject setObject:audioFile forKey:@"audioFile"];
        [audioObject setObject:[PFUser currentUser] forKey:@"user"];
        [audioObject setObject:[[NSDate date] description] forKey:@"title"];
        [audioObject saveInBackground];
    }];
    metaDataVC.audioURL = audioURL;
    
    audioTransitionObject = audioObject;
    
    return metaDataVC;
}

+(void)updateAudioObjectWithTitle:(NSString *)title
{
    [audioTransitionObject setObject:title forKey:@"title"];
    [audioTransitionObject saveInBackground];
    audioTransitionObject = nil;
}

+(UIImage *)getProfilePictureForUser:(PFUser *)user
{
    PFObject *userPhotoObject = [user objectForKey:@"userPhoto"];
    [userPhotoObject fetchIfNeeded];
    PFFile *photoFile = [userPhotoObject objectForKey:@"imageFile"];
    NSData *photoData = [photoFile getData];
    UIImage *photo = [UIImage imageWithData:photoData];
    
    return photo;
}


+(PFUser *)getUserWithUsername:(NSString *)username
{
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:username];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    PFUser *user = [[query findObjects] objectAtIndex:0];
    return user;
}

@end

//
//  PulseStore.m
//  push
//
//  Created by hugo on 9/19/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import <Parse/Parse.h>
#import "PulseStore.h"

@implementation PulseStore

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

+(NSArray *)getFollowedUsers:(PFUser *)user
{
    PFQuery *query = [PFQuery queryWithClassName:@"followRelationship"];
    [query whereKey:@"toUser" equalTo:user];
    NSArray *results = [query findObjects];
    return results;
}

+(NSArray *)getFollowingUsers:(PFUser *)user
{
    PFQuery *query = [PFQuery queryWithClassName:@"followRelationship"];
    [query whereKey:@"fromUser" equalTo:user];
    NSArray *results = [query findObjects];
    return results;
}
@end

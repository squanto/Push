//
//  PulseStore.h
//  push
//
//  Created by hugo on 9/19/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface PulseStore : NSObject <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

+(UIImage *)getProfilePictureForUser:(PFUser *)user;
+(PFUser *)getUserWithUsername:(NSString *)username;
+(NSArray *)getFollowedUsers:(PFUser *)user;
+(NSArray *)getFollowingUsers:(PFUser *)user;

@end

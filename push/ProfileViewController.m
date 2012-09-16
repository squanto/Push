//
//  ProfileViewController.m
//  push
//
//  Created by hugo on 9/9/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "ProfileViewController.h"
#import "RecordViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()

@property (strong) UIImageView *profileImageView;

@end

@implementation ProfileViewController

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
    // Query for the user's profile picture
    
    
    
    
//    [[PFUser currentUser] refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//        if (!error) {
//            self.profileImageView = [PFImageView new];
//            self.profileImageView.image = [UIImage imageNamed:@"shatteredBG.png"];
//            self.profileImageView.frame = CGRectMake(20, 20, 100, 100);
//            PFFile *imageFile = [object objectForKey:@"profilePicture"];
//            self.profileImageView.file = imageFile;
//            [self.profileImageView loadInBackground:^(UIImage *image, NSError *error) {
//                self.profileImageView.image = image;
//                NSLog(@"IMAGE DATA: %@", UIImageJPEGRepresentation(image, 0.7));
//                [self.view addSubview:self.profileImageView];
//            }];
//        } else {
//            NSLog(@"Error: %@, %@", error, [error userInfo]);
//        }
//    }];
//    UIImage *profileImage = [UIImage imageWithData:[[[PFUser currentUser] objectForKey:@"profilePicture"] getData]];
//    PFQuery *profileImageQuery = [PFUser query];
//    [profileImageQuery getObjectWithId:[PFUser currentUser].objectId];
//    [profileImageQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//        self.profileImageView.image = [UIImage imageWithData:[[object objectForKey:@"profilePicture"] getData]];
//    }];
//    self.profileImageView.image = profileImage;
//    [self.view addSubview:self.profileImageView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
    
    // Record Navigationx
    UIBarButtonItem *recordButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showRecordModally)];
    self.navigationItem.rightBarButtonItem = recordButton;
    self.navigationItem.title = @"Me";
//    
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    PFObject *userPhotoObject = [[PFUser currentUser] objectForKey:@"userPhoto"];
    
    // :)   
    dispatch_async(dispatch_get_current_queue(), ^{
        NSLog(@"Dispatch MADE!!!!!");
        [userPhotoObject fetchIfNeeded];
        PFFile *photoFile = [userPhotoObject objectForKey:@"imageFile"];
        NSData *photoData = [photoFile getData];
        UIImage *photo = [UIImage imageWithData:photoData];
        self.profileImageView.image = photo;
        [self.view addSubview:self.profileImageView];
    });
}




-(void)showRecordModally
{
    UINavigationController *recordNavVC = [[UINavigationController alloc] initWithRootViewController:[RecordViewController new]];
    [self.navigationController presentModalViewController:recordNavVC animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end

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

@property (strong) PFImageView *profileImageView;

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
    [[PFUser currentUser] refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            self.profileImageView = [PFImageView new];
            self.profileImageView.image = [UIImage imageNamed:@"shatteredBG.png"];
            self.profileImageView.frame = CGRectMake(20, 20, 100, 100);
            PFFile *imageFile = [object objectForKey:@"profilePicture"];
            self.profileImageView.file = imageFile;
            [self.profileImageView loadInBackground:^(UIImage *image, NSError *error) {
                self.profileImageView.image = image;
                NSLog(@"IMAGE DATA: %@", UIImageJPEGRepresentation(image, 0.7));
                [self.view addSubview:self.profileImageView];
            }];
        } else {
            NSLog(@"Error: %@, %@", error, [error userInfo]);
        }
    }];
//    UIImage *profileImage = [UIImage imageWithData:[[[PFUser currentUser] objectForKey:@"profilePicture"] getData]];
//    PFQuery *profileImageQuery = [PFUser query];
//    [profileImageQuery getObjectWithId:[PFUser currentUser].objectId];
//    [profileImageQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//        self.profileImageView.image = [UIImage imageWithData:[[object objectForKey:@"profilePicture"] getData]];
//    }];
//    self.profileImageView.image = profileImage;
//    [self.view addSubview:self.profileImageView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
    
    // Record Navigation
    UIBarButtonItem *recordButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showRecordModally)];
    self.navigationItem.rightBarButtonItem = recordButton;
    self.navigationItem.title = @"Me";

    
//    PFQuery *profilePictureQuery = [PFUser query];
//    [profilePictureQuery whereKey:@"username" equalTo:[object objectForKey:@"user"]];
//
//    cell.imageView.image = [UIImage imageWithData:[[[profilePictureQuery getFirstObject] objectForKey:@"profilePicture"] getData]];
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

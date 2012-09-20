//
//  SignupViewController.m
//  push
//
//  Created by hugo on 9/12/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "SignupViewController.h"
#import "TabViewController.h"

@interface SignupViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,PFSignUpViewControllerDelegate>

@property (strong) UIButton *choosePhotoButton;
@property (strong) UIActionSheet *photoPickerActionSheet;
@property (strong) UIImage *profileImage;
@property (strong) UIImageView *profileImageView;

@end

@implementation SignupViewController

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
    self.delegate = self;
    
    // Initializing the photo picker button
    self.choosePhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.choosePhotoButton addTarget:self action:@selector(choosePhotoButtonPressed) forControlEvents:UIControlEventTouchDown];
    [self.choosePhotoButton setTitle:@"Profile Pic" forState:UIControlStateNormal];
    self.choosePhotoButton.frame = CGRectMake(110, 290, 105, 105);
    [self.view addSubview:self.choosePhotoButton];
    
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 320, 100, 100)];
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.profileImageView];
    
    
    // Setting up the action sheet.
    self.photoPickerActionSheet =[[UIActionSheet alloc] initWithTitle:@"Choose a photo"
                                                             delegate:self
                                                    cancelButtonTitle:@"cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take New Photo", @"Chose From Library", nil];
}

-(void)viewDidLayoutSubviews
{
    self.signUpView.signUpButton.frame = CGRectMake(35, 395, 250, 60);
}


-(void)choosePhotoButtonPressed
{
    [self.photoPickerActionSheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        imagePicker.sourceType = UIImagePickerControllerCameraDeviceFront;
        imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:imagePicker animated:YES];
        
    } else if (buttonIndex == 1) {
        UIImagePickerController* imagePicker = [UIImagePickerController new];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:imagePicker animated:YES];
        
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.profileImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.choosePhotoButton setImage:self.profileImage forState:UIControlStateNormal];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:NO];
}


// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    if (!self.profileImage) {
        informationComplete = NO;
    }
    
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}


// Sent to the delegate when a PFUser is signed up.
-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    NSLog(@"Self.profileimageview.image == %@", self.profileImage);
    NSData *imageData = UIImageJPEGRepresentation(self.profileImage, 0.7);
    PFFile *imageFile = [PFFile fileWithName:@"profilePic.jpeg" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The association magic.
            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            [userPhoto setObject:user.objectId forKey:@"user"];
            [userPhoto setObject:user.username forKey:@"username"];
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    // These lines do bad things.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[PFUser currentUser] setObject:userPhoto forKey:@"userPhoto"];
                        [[PFUser currentUser] setObject:imageFile forKey:@"userPhotoImage"];
                        NSLog(@"Succes Reached FOr IMAGE USER !!?!?!");
                        [[PFUser currentUser] saveInBackground];
                    });
                } else {
                    NSLog(@"Error: %@, %@", error, [error userInfo]);
                }
            }];
        } else {
            NSLog(@"Error %@, %@", error, [error userInfo]);
        }
    }];
    [self presentViewController:[TabViewController new] animated:YES completion:nil];
}

// Sent to the delegate when the sign up attempt fails.
-(void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error
{
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
-(void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    NSLog(@"User dismissed the signUpViewController");
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

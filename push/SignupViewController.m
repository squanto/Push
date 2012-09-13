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
        // Custom initialization
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
    
    // Hacked!
//    self.signUpView.additionalField.placeholder = @"Choose a Photo!";
//    self.signUpView.additionalField.frame = CGRectMake(0, 30, 100, 100);
//    
//    self.signUpView.additionalField.layer.shadowOpacity = 0.0;
//    self.signUpView.additionalField.textColor = [UIColor blackColor];
//    self.signUpView.additionalField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid.png"]];
    
    // Setting up the photo picker action sheet
    self.photoPickerActionSheet =[[UIActionSheet alloc] initWithTitle:@"Choose a photo" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take New Photo", @"Chose From Library", @"Import From Twitter", nil];
}

-(void)viewDidLayoutSubviews
{
    self.signUpView.signUpButton.frame = CGRectMake(35, 395, 250, 60);
}


-(void)choosePhotoButtonPressed
{
    NSLog(@"Choose Photo Button Pressed!");
    // Present a modal controller
    [self.photoPickerActionSheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Clicked button at index: %d", buttonIndex);
    if (buttonIndex == 0) {
        NSLog(@"Time To take a new photo!");
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        imagePicker.sourceType = UIImagePickerControllerCameraDeviceFront;
        imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:imagePicker animated:YES];
    } else if (buttonIndex == 1) {
        NSLog(@"Time to choose from the library of photos!");
        UIImagePickerController* imagePicker = [UIImagePickerController new];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:imagePicker animated:YES];
    } else if (buttonIndex == 2) {
        NSLog(@"Time to import from twitter!");
        // Import and use twitter.
        
    }
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    // It automatically dismisses itself.
    NSLog(@"Cancel Button Pressed!");
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.profileImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
//    self.profileImageView.image = self.profileImage;
//    self.profileImageView.frame = CGRectMake(110, 310, 100, 50);
    [self.choosePhotoButton setImage:self.profileImage forState:UIControlStateNormal];
//    self.choosePhotoButton.alpha = 0.0;
//    [self.choosePhotoButton removeFromSuperview];
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
    
    // Check for a profile image.
    if (!self.profileImage) {
        informationComplete = NO;
    }
    
    // Display an alert if a field wasn't completed
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
    //Add photo imformation here??
    // Check that it exists again..
    // Make a user images table... (gets the user photo based on their username...
    //        PFObject *userPhotoMap = [PFObject objectWithClassName:@"userPhotoMap"];
    //        [userPhotoMap setObject:userPhoto forKey:@"userPhoto"];
    //        NSLog(@"Starting to save pic!");
    //        [userPhotoMap saveInBackground];
    
    PFFile *userPhoto = [PFFile fileWithName:@"profilePic.jpeg"
                                        data:UIImageJPEGRepresentation(self.profileImageView.image, 0.7)];
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:user.objectId];
    PFObject *userObject = [query getFirstObject];
    [userObject setObject:userPhoto forKey:@"profilePicture"];
    [userObject saveInBackground];

    // ??
    [self dismissModalViewControllerAnimated:YES]; // Dismiss the PFSignUpViewController
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

//
//  ProfileCell.h
//  Backplane
//
//  Created by hugo on 9/28/12.
//  Copyright (c) 2012 Hugo Melo. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface ProfileCell : UITableViewCell

@property (strong) PFFile *audioFile;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) IBOutlet UIButton *playButton;

@end

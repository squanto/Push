//
//  RecordMetaDataViewController.h
//  push
//
//  Created by hugo on 9/10/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RecordMetaDataViewController : UIViewController

@property (strong) PFObject *audioObject;
@property (strong) NSURL *audioURL;

@end

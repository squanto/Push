//
//  DashboardViewController.m
//  push
//
//  Created by hugo on 9/7/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import "DashboardViewController.h"
#import <Parse/Parse.h>
#import "RecordViewController.h"
#import "SettingsViewController.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization- Record Button
        UIImage *recordButtonImage = [UIImage imageNamed:@"record.png"];
        UITabBarItem *recordItem = [[UITabBarItem alloc] initWithTitle:@"Record" image:recordButtonImage tag:0];
        RecordViewController *recordVC = [RecordViewController new];
        recordVC.tabBarItem = recordItem;
        
        UIImage *settingsButtonImage = [UIImage imageNamed:@"cog.png"];
        UITabBarItem *settingsItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:settingsButtonImage tag:1];
        SettingsViewController *settingsVC = [SettingsViewController new];
        settingsVC.tabBarItem = settingsItem;
        
        self.viewControllers = [NSArray arrayWithObjects:recordVC, settingsVC, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

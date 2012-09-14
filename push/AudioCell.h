//
//  AudioCell.h
//  push
//
//  Created by hugo on 9/13/12.
//  Copyright (c) 2012 HugoMelo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioCell : UITableViewCell

// features
@property (strong) NSString *title;


// buttons
@property (strong) UIButton *play;

// Second views (twitter style, that recognizes a swipe sideways gesture).

/*
 Makes a gesture recognizer- pan gesture recognizer.
 Swipe changes the opacity of the top view in that particular cell.
 
 Play with the gesture recognizer 
    Play with the swipe view first. 
        REd view and blue view first.
        Make a seperate repo
        Start off with flipping the opacity, then animate the change in opacity.
        
        Make a core animation to make each of the little buttons animate and bounce as you slide across.
 */

@end

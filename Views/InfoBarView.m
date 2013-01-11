//
//  InfoBarView.m
//  Bull Run
//
//  Created by Dave Townsend on 1/4/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "InfoBarView.h"
#import "Unit.h"

@implementation InfoBarView

- (void)showInfoForUnit:(Unit*)unit {
    if (unit) {
        [unitName setText:[unit name]];
        [originalStrength setText:[[NSString alloc] initWithFormat:@"%d", [unit originalStrength]]];
        [currentStrength setProgress:(float)[unit strength] / (float)[unit originalStrength]];
        [currentStrength setHidden:NO];
        
    } else { // no unit selected, just erase the info box
        [unitName setText:@""];
        [originalStrength setText:@""];
        [currentStrength setHidden:YES];
    }
}

@end

//
//  InfoBarView.m
//  Bull Run
//
//  Created by Dave Townsend on 1/4/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "BAGame.h"
#import "BAUnit.h"
#import "InfoBarView.h"

#define NUM_ELTS(ARRAY_NAME) (sizeof(ARRAY_NAME) / sizeof(ARRAY_NAME[0]))

static NSString* modeLabelStrings[] = {
    @"Charge",
    @"Attack",
    @"Skirmish",
    @"Defend",
    @"Withdraw",
    @"Routed"
};
static BOOL modeLabelIsChoosable[] = {
    YES,  // Charge
    YES,  // Attack
    YES,  // Skirmish
    YES,  // Defend
    YES,  // Withdraw
    NO    // Routed
};

@implementation InfoBarView (Private)

- (int)modeFromMenuIndex:(int)idx {
    // 0 normally means |Charge|, and so on down the line, but
    // if |Charge| is disabled then 0 means |Defend|.
    return modeLabelIsChoosable[CHARGE] ? idx : DEFEND + idx;
}

@end

@implementation InfoBarView

- (void)showInfoForUnit:(BAUnit*)unit {
    if (unit) {
        [currentStrength setHidden:NO];
        [unitMode setHidden:NO];
        [unitImage setHidden:NO];
        
        
        [unitName setText:[unit name]];
        [originalStrength setText:[[NSString alloc] initWithFormat:@"%d men", [unit originalStrength]]];
        [currentStrength setProgress:(float)[unit strength] / (float)[unit originalStrength]];
        [unitMode setTitle:modeLabelStrings[[unit mode]] forState:UIControlStateNormal];

        // Cell size: 55w x 64h
        [[unitImage layer] setContentsRect:CGRectMake(54.0 * [unit imageXIdx] / 702.0,  // TODO: get rid of constant; this is width of source image
                                                      64.0 * [unit imageYIdx] / 128.0,  // TODO: get rid of constant; this is height of source image
                                                      54.0 / 702.0, 0.5)];

        BOOL isWrecked = [unit isWrecked];
        for (int i = 0; i < NUM_ELTS(modeLabelStrings); ++i)
            if (IsOffensiveMode(i))
                modeLabelIsChoosable[i] = isWrecked ? NO : YES;

        currentUnit = unit;
        
    } else { // no unit selected, just erase the info box
        [unitName setText:@""];
        [originalStrength setText:@""];
        [currentStrength setHidden:YES];
        [unitMode setHidden:YES];
        [unitImage setHidden:YES];
        
        currentUnit = nil;
    }
}

- (IBAction)moveToLowerLeftCorner:(id)sender {
    CGSize parentSize = [[self superview] bounds].size;
    CGSize mySize = [self bounds].size;
    
    CGPoint newCenter = CGPointMake(mySize.width / 2.0f, parentSize.height - mySize.height / 2.0f);
    
    [UIView animateWithDuration:0.5 animations:^{
            [self setCenter:newCenter];
        }];
}

- (IBAction)moveToUpperRight:(id)sender {
    CGSize parentSize = [[self superview] bounds].size;
    CGSize mySize = [self bounds].size;
    
    CGPoint newCenter = CGPointMake(parentSize.width - mySize.width / 2.0f, mySize.height / 2.0f);

    [UIView animateWithDuration:0.5 animations:^{
        [self setCenter:newCenter];
    }];
}

- (IBAction)changeMode:(id)sender {
    UIActionSheet* menu = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:nil, nil];
    
    for (int i = 0; i < NUM_ELTS(modeLabelStrings); ++i)
        if (modeLabelIsChoosable[i])
            [menu addButtonWithTitle:modeLabelStrings[i]];
    
    [menu setDelegate:self];
    
    [menu showFromRect:[unitMode frame] inView:self animated:YES];
}

- (IBAction)nextTurn:(id)sender {
    [game doNextTurn];
}

#pragma mark - UIActionSheetDelegate Implementation

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIdx {
    if (0 <= buttonIdx && buttonIdx < NUM_ELTS(modeLabelStrings)) {
        int newMode = [self modeFromMenuIndex:buttonIdx];
        [unitMode setTitle:modeLabelStrings[newMode] forState:UIControlStateNormal];
        [currentUnit setMode:(Mode)newMode];
    }
}

@end

//
//  InfoBarView.m
//  Bull Run
//
//  Created by Dave Townsend on 1/4/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "InfoBarView.h"
#import "Unit.h"

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

@implementation InfoBarView

- (void)showInfoForUnit:(Unit*)unit {
    if (unit) {
        [currentStrength setHidden:NO];
        [unitMode setHidden:NO];
        [unitImage setHidden:NO];
        
        
        [unitName setText:[unit name]];
        [originalStrength setText:[[NSString alloc] initWithFormat:@"%d", [unit originalStrength]]];
        [currentStrength setProgress:(float)[unit strength] / (float)[unit originalStrength]];
        [unitMode setTitle:modeLabelStrings[[unit mode]] forState:UIControlStateNormal];
        
        CGSize cellSize = CGSizeMake(54.0, 64.0);  // the size of one image cell in the source image
        CGSize normalizedSize = CGSizeMake(cellSize.width / [unitImage bounds].size.width, cellSize.height / [unitImage bounds].size.height);
        [[unitImage layer] setContentsRect:CGRectMake(54.0 * [unit imageXIdx]/702.0, 0, normalizedSize.width, normalizedSize.height)];
        
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
    
    for (int i = 0; i < sizeof(modeLabelStrings) / sizeof(NSString*); ++i)
        if (modeLabelIsChoosable[i])
            [menu addButtonWithTitle:modeLabelStrings[i]];
    
    [menu setDelegate:self];
    
    [menu showFromRect:[unitMode frame] inView:self animated:YES];
}

#pragma mark - UIActionSheetDelegate Implementation

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [unitMode setTitle:modeLabelStrings[buttonIndex] forState:UIControlStateNormal];
    [currentUnit setMode:(Mode)buttonIndex];
}

@end

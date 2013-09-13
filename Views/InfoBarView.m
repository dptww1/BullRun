//
//  InfoBarView.m
//  Bull Run
//
//  Created by Dave Townsend on 1/4/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "BattleAt.h"
#import "DPTSysUtil.h"
#import "InfoBarView.h"

@implementation InfoBarView (Private)

- (NSArray*)unitControls {
    return @[originalStrength,
             currentStrength,
             unitImage,
             unitName,
             unitMode];
}

/*
 * The portrait source image is a concatenation of all the individual portrait
 * images, in two rows with the CSA leaders on the top row and the USA leaders
 * on the bottom row.  Within a row, the leaders are arranged alphabetically by
 * last name. The unit itself tells us the X,Y coordinates of the image in
 * /portrait/ terms, i.e. "3rd image in the 1st row"; this method converts
 * those coordinates to values usable by the portrait UIView.contents, 
 * which wants percentages. Oh, iOS, you so wacky.
 */
- (CGRect)getContentRectForUnit:(BATUnit*)unit {
    // The dimensions of the window onto the portraits, sized so that only
    // one portrait shows at a time.
    CGSize viewFrameSize = [unitImage frame].size;

    // The dimensions of the portraits src image; much bigger than viewFrameSize!
    CGSize srcImageSize = [unitImage image].size;

    float x = viewFrameSize.width  * [unit imageXIdx] / srcImageSize.width;
    float y = viewFrameSize.height * [unit imageYIdx] / srcImageSize.height;
    float w = viewFrameSize.width / srcImageSize.width;
    float h = 0.5f;

    return CGRectMake(x, y, w, h);
}

@end

@implementation InfoBarView

- (void)showInfoForUnit:(BATUnit*)unit {
    if (unit) {
        for (UIView* ctl in [self unitControls])
            [ctl setHidden:NO];
        
        [unitName setText:[unit name]];
        [originalStrength setText:[[NSString alloc] initWithFormat:@"%d men", [unit originalStrength]]];
        [currentStrength setProgress:(float)[unit strength] / (float)[unit originalStrength]];
        [unitMode setTitle:[[game delegate] getCurrentModeStringForUnit:unit]
                  forState:UIControlStateNormal];

        [[unitImage layer] setContentsRect:[self getContentRectForUnit:unit]];

        currentUnit = unit;
        
    } else { // no unit selected, just erase the info box
        for (UIView* ctl in [self unitControls])
            [ctl setHidden:YES];

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
    
    NSArray* possibleModes = [[game delegate] getPossibleModesForUnit:currentUnit];
    for (NSString* modeStr in possibleModes)
        [menu addButtonWithTitle:modeStr];
    
    [menu setDelegate:self];
    
    [menu showFromRect:[unitMode frame] inView:self animated:YES];
}

- (IBAction)nextTurn:(id)sender {
    for (UIView* ctl in [self unitControls])
        [ctl setHidden:YES];

    [processingTurn startAnimating];

    [game processTurn];
}

- (void)updateCurrentTimeForTurn:(int)turn {
    NSString* timeStr = [[game delegate] convertTurnToString:turn];

    [UIView
     animateWithDuration:0.5
     animations:^{
         [currentTime layer].transform = CATransform3DRotate(CATransform3DIdentity, DEGREES_TO_RADIANS(90), 1, 0, 0);
     }
     completion:^(BOOL finished){
         [currentTime setText:timeStr];
         [UIView
          animateWithDuration:0.5
          animations:^{
              [currentTime layer].transform = CATransform3DRotate([currentTime layer].transform, DEGREES_TO_RADIANS(-90), 1, 0, 0);
          }];
     }];

    [processingTurn stopAnimating];
}

#pragma mark - UIActionSheetDelegate Implementation

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIdx {
    NSString* newModeStr = [actionSheet buttonTitleAtIndex:buttonIdx];
    int newMode = [[game delegate] getModeIndexForUnit:currentUnit inMode:newModeStr];

    DEBUG_MODES(@"Changing %@'s mode from %d to %d", [currentUnit name], [currentUnit mode], newMode);
    
    [unitMode setTitle:newModeStr forState:UIControlStateNormal];
    [currentUnit setMode:newMode];
}

@end

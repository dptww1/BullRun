//
//  InfoBarView.h
//  Bull Run
//
//  Created by Dave Townsend on 1/4/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BATUnit;

/**
 * The Info Bar view, the game display where various information about
 * the game state is shown to the user.
 */
@interface InfoBarView : UIView <UIActionSheetDelegate> {
    /** Widget showing original strength of the current unit. */
    __weak IBOutlet UILabel*                 originalStrength;

    /** Widget showing the current strength of the current unit. */
    __weak IBOutlet UIProgressView*          currentStrength;

    /** Widget showing commander portrait of the current unit. */
    __weak IBOutlet UIImageView*             unitImage;

    /** Widget showing name of the current unit. */
    __weak IBOutlet UILabel*                 unitName;

    /** Widget showing mode of the current unit. */
    __weak IBOutlet UIButton*                unitMode;

    /** Widget starting orders resolution and advancing to the next turn. */
    __weak IBOutlet UIButton*                nextTurn;

    /** Widget showing the current turn. */
    __weak IBOutlet UILabel*                 currentTime;

    /** Widget indicating that turn resolution is in progress. */
    __weak IBOutlet UIActivityIndicatorView* processingTurn;

    /** The currently selected unit, possibly nil. */
    __weak BATUnit*                          currentUnit;
}

/**
 * Shows the details of the given unit.
 *
 * @param unit the unit to show; if `nil` then clear the Info Bar
 */
- (void)showInfoForUnit:(BATUnit*)unit;

/**
 * Shows the Change Mode menu. Called automatically when the user clicks
 * unit mode.
 *
 * @param sender standard IB parameter (unused)
 */
- (IBAction)changeMode:(id)sender;

/**
 * Begins processing of the current orders. Called automatically
 * when the user clicks the turn marker.
 *
 * @param sender standard IB parameter (unused)
 */
- (IBAction)nextTurn:(id)sender;

/**
 * Updates the current turn display.
 */
- (void)updateCurrentTimeForTurn:(int)turn;


@end

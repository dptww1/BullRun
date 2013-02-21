//
//  InfoBarView.h
//  Bull Run
//
//  Created by Dave Townsend on 1/4/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BAUnit;

@interface InfoBarView : UIView <UIActionSheetDelegate> {
    __weak IBOutlet UILabel*        originalStrength;
    __weak IBOutlet UIProgressView* currentStrength;
    __weak IBOutlet UIImageView*    unitImage;
    __weak IBOutlet UILabel*        unitName;
    __weak IBOutlet UIButton*       unitMode;
    __weak IBOutlet UIButton*       nextTurn;
    __weak IBOutlet UILabel*        currentTime;

    __weak BAUnit* currentUnit;
}

- (void)showInfoForUnit:(BAUnit*)unit;
- (IBAction)changeMode:(id)sender;
- (IBAction)nextTurn:(id)sender;
- (void)updateCurrentTimeForTurn:(int)turn;


@end

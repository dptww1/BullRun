//
//  InfoBarView.h
//  Bull Run
//
//  Created by Dave Townsend on 1/4/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Unit;

@interface InfoBarView : UIView {
    __weak IBOutlet UILabel*        originalStrength;
    __weak IBOutlet UIProgressView* currentStrength;
    __weak IBOutlet UIImageView*    unitImage;
    __weak IBOutlet UILabel*        unitName;
}

- (void)showInfoForUnit:(Unit*)unit;

@end

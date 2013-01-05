//
//  InfoBarView.h
//  Bull Run
//
//  Created by Dave Townsend on 1/4/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoBarView : UIView {
    __weak IBOutlet UILabel*        originalStrength;
    __weak IBOutlet UILabel*        unitName;
    __weak IBOutlet UIProgressView* currentStrength;
    __weak IBOutlet UIImageView*    unitImage;
}

@end

//
//  UnitLabel.m
//
//  Created by Dave Townsend on 8/29/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BattleAt.h"
#import "CALayer+DPTUtil.h"
#import "NSString+DPTUtil.h"
#import "UnitLabel.h"


#define kBATLabelFontName @"GillSans"
#define kBATLabelFontSize 12


@implementation UnitLabel

+ (UnitLabel*)labelForUnit:(BATUnit*)unit {
    UnitLabel* lbl = [[UnitLabel alloc] init];

    if (lbl) {
        UIFont* font = [UIFont fontWithName:kBATLabelFontName
                                       size:kBATLabelFontSize];

        CGRect bounds = [[unit name] dpt_integralBoundsUsingFont:font];

        [lbl setBounds:bounds];
        [lbl setString:[unit name]];
        [lbl setFontSize:kBATLabelFontSize];
        [lbl setFont:kBATLabelFontName];
        [lbl setForegroundColor:[[UIColor whiteColor] CGColor]];
        [lbl dpt_setShadowColor:[UIColor blackColor]
                        opacity:1.f
                         offset:CGSizeMake(2.f, 2.f)
                         radius:0.f];
    }

    return lbl;
}

@end

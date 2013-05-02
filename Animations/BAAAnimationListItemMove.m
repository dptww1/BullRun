//
//  BAAAnimationListItemMove.m
//  Bull Run
//
//  Created by Dave Townsend on 4/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BAAAnimationList.h"
#import "BAAAnimationListItemMove.h"
#import "BAUnit.h"
#import "HMCoordinateTransformer.h"
#import "UnitView.h"

@implementation BAAAnimationListItemMove

+ (id)itemMoving:(BAUnit*)unit toHex:(HMHex)hex {
    BAAAnimationListItemMove* o = [[BAAAnimationListItemMove alloc] init];

    if (o) {
        [o setActor:unit];
        [o setStartHex:[unit location]];
        [o setEndHex:hex];
    }

    return o;
}

- (void)runWithParent:(BAAAnimationList*)list {
    DEBUG_ANIMATION(@"running animation %@", self);

    HMCoordinateTransformer* xformer = [list xformer];
    UnitView* v = [UnitView createForUnit:[self actor]];
    CGPoint endPoint = [xformer hexCenterToScreen:[self endHex]];

    [CATransaction begin];

    [CATransaction setCompletionBlock:^{
            [list run:nil];
        } ];

    CAAnimation* anim = [self createMoveAnimationFor:[self actor]
                                          movingFrom:[self startHex]
                                                  to:[self endHex]
                                          usingXform:xformer];

    [v setPosition:endPoint];
    [v addAnimation:anim forKey:@"position"]; //[[self actor] name]];

    [CATransaction commit];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MOVE actor:%@ from:%02d%02d to:%02d%02d",
            [[self actor] name],
            [self startHex].column,
            [self startHex].row,
            [self endHex].column,
            [self endHex].row
            ];
}

@end
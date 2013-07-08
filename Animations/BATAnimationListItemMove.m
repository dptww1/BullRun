//
//  BATAnimationListItemMove.m
//
//  Created by Dave Townsend on 4/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BATAnimationList.h"
#import "BATAnimationListItemMove.h"
#import "BATUnit.h"
#import "UnitView.h"

//==============================================================================
@interface BATAnimationListItemMove ()

@property (nonatomic, strong) BATUnit* actor;
@property (nonatomic)         HXMHex   startHex;
@property (nonatomic)         HXMHex   endHex;

@end

//==============================================================================
@implementation BATAnimationListItemMove

+ (id)itemMoving:(BATUnit*)unit toHex:(HXMHex)hex {
    BATAnimationListItemMove* o = [[BATAnimationListItemMove alloc] init];

    if (o) {
        [o setActor:unit];
        [o setStartHex:[unit location]];
        [o setEndHex:hex];
    }

    return o;
}

- (void)runWithParent:(BATAnimationList*)list {
    DEBUG_ANIMATION(@"running animation %@", self);

    HXMCoordinateTransformer* xformer = [list xformer];
    UnitView* v = [UnitView viewForUnit:_actor];
    CGPoint endPoint = [xformer hexCenterToScreen:_endHex];

    [CATransaction begin];

    [CATransaction setCompletionBlock:^{
            [list run:nil];
        } ];

    CAAnimation* anim = [self createMoveAnimationFor:_actor
                                          movingFrom:_startHex
                                                  to:_endHex
                                          usingXform:xformer];

    [v setPosition:endPoint];
    [v addAnimation:anim forKey:@"position"]; //[[self actor] name]];

    [CATransaction commit];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MOVE actor:%@ from:%02d%02d to:%02d%02d",
            [_actor name],
            _startHex.column,
            _startHex.row,
            _endHex.column,
            _endHex.row];
}

@end

//
//  BATAnimationListItemCombat.m
//
//  Created by Dave Townsend on 4/9/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BATAnimationListItemCombat.h"
#import "BATAnimationList.h"
#import "BATAnimationGunfire.h"
#import "BATGame.h"
#import "BATUnit.h"
#import "DPTSysUtil.h"
#import "HXMCoordinateTransformer.h"
#import "UnitView.h"

static CGPoint shiftPoint(CGPoint pt, float dx, float dy) { // TODO: move to global location
    CGPoint p = pt;
    p.x += dx;
    p.y += dy;
    return p;
}

//==============================================================================
@interface BATAnimationListItemCombat ()

// Copies of class init method parameters
@property (nonatomic, strong) BATUnit*             attacker;
@property (nonatomic, strong) BATUnit*             defender;
@property (nonatomic)         HXMHex               retreatHex;
@property (nonatomic)         HXMHex               advanceHex;

// Convenience parameters
@property (nonatomic, strong) BATAnimationGunfire* attackerGunfire;
@property (nonatomic)         HXMHex               attackerHex;
@property (nonatomic)         HXMHex               defenderHex;

@end

//==============================================================================
@implementation BATAnimationListItemCombat (Private)

- (void)showRetreatAndAdvance:(BATAnimationList*)list {
    DEBUG_ANIMATION(@"running animation %@ (advance/retreat)", self);
    
    [[self attackerGunfire] stop];
    [self setAttackerGunfire:nil];

    if ([[game board] isHexOnMap:[self retreatHex]]) {
        [CATransaction begin];

        [CATransaction setAnimationDuration:SECONDS_PER_HEX_MOVE];
        [CATransaction setCompletionBlock:^{
                [self endCombat:list];
            } ];

        HXMCoordinateTransformer* xformer = [list xformer];

        CAAnimation* dAnim = [self createMoveAnimationFor:[self defender]
                                               movingFrom:[self defenderHex]
                                                       to:[self retreatHex]
                                               usingXform:xformer];

        UnitView* dv = [UnitView viewForUnit:[self defender]];
        [dv setPosition:[xformer hexCenterToScreen:[self retreatHex]]];
        [dv addAnimation:dAnim forKey:@"position"];

        if ([[game board] isHexOnMap:[self advanceHex]]) {
            CAAnimation* aAnim = [self createMoveAnimationFor:[self attacker]
                                                   movingFrom:[self attackerHex]
                                                           to:[self defenderHex]
                                                   usingXform:xformer];

            UnitView* av = [UnitView viewForUnit:[self attacker]];
            [av setPosition:[xformer hexCenterToScreen:[self defenderHex]]];
            [av addAnimation:aAnim forKey:@"position"];
        }

        [CATransaction commit];

    } else {
        [self endCombat:list];
    }
}

- (void)endCombat:(BATAnimationList*)list {
    DEBUG_ANIMATION(@"running animation %@ (end)", self);
    [list run:nil];
}

@end

//==============================================================================
@implementation BATAnimationListItemCombat

+ (id)itemWithAttacker:(BATUnit*)attacker
              defender:(BATUnit*)defender
             retreatTo:(HXMHex)retreatHex
             advanceTo:(HXMHex)advanceHex {
    BATAnimationListItemCombat* o = [[BATAnimationListItemCombat alloc] init];

    if (o) {
        [o setAttacker:attacker];
        [o setDefender:defender];
        [o setRetreatHex:retreatHex];
        [o setAdvanceHex:advanceHex];

        // attackerGunfire filled in later
        [o setAttackerHex:[attacker location]];
        [o setDefenderHex:[defender location]];
    }

    return o;
}

- (void)runWithParent:(BATAnimationList*)list {
    DEBUG_ANIMATION(@"running animation %@ (gunfire)", self);

    HXMCoordinateTransformer* xformer = [list xformer];

    [CATransaction begin];

    [CATransaction setCompletionBlock:^{
            [self showRetreatAndAdvance:list];
        } ];

    // Attacker animation computation
    CGPoint centerPt = [xformer hexCenterToScreen:_attackerHex];

    CAKeyframeAnimation* anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [anim setValues:@[
                      [NSValue valueWithCGPoint:centerPt],
                      [NSValue valueWithCGPoint:shiftPoint(centerPt, -5.0f, 0.0f)],
                      [NSValue valueWithCGPoint:centerPt],
                      [NSValue valueWithCGPoint:shiftPoint(centerPt, +5.0f, 0.0f)],
                      [NSValue valueWithCGPoint:centerPt]
                      ]
     ];
    [anim setKeyTimes:@[ @0.0f, @0.2f, @0.6f, @0.8f, @1.0f ]];
    [anim setDuration:SECONDS_PER_HEX_MOVE];

    UnitView* v = [UnitView viewForUnit:_attacker];
    [v addAnimation:anim forKey:[_attacker name]];

    [CATransaction commit];

    int dirAToD = [[game board] directionFrom:_attackerHex
                                           to:_defenderHex];
    // 0 degrees longitude is straight to the right, but direction 0 in
    // HMHexMap terms is straight to the top.  So subtract 90 degrees from
    // the game logic angle to get the animation logic angle.
    CGFloat angleAToD = DEGREES_TO_RADIANS((dirAToD * 60) - 90);

    [self setAttackerGunfire:[BATAnimationGunfire gunfireFrom:v withAzimuth:angleAToD]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"COMBAT attacker:%@ defender:%@ retreatHex:%02d%02d advanceHex:%02d%02d",
            [_attacker name],
            [_defender name],
            _retreatHex.column,
            _retreatHex.row,
            _advanceHex.column,
            _advanceHex.row];
}

@end

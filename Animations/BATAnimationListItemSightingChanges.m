//
//  BATAnimationListItemSightingChanges.m
//
//  Created by Dave Townsend on 7/7/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//


#import "BATAnimationList.h"
#import "BATAnimationListItemSightingChanges.h"
#import "BATUnit.h"
#import "UnitView.h"


//==============================================================================
@interface BATAnimationListItemSightingChanges ()

@property (nonatomic, strong) NSSet* sightedUnits;
@property (nonatomic, strong) NSSet* hiddenUnits;

@end


//==============================================================================
@implementation BATAnimationListItemSightingChanges

+ (id)itemSightingChangesWithNowSightedUnits:(NSSet*)sightedUnits
                           andNowHiddenUnits:(NSSet*)hiddenUnits  {
    BATAnimationListItemSightingChanges* o = [[BATAnimationListItemSightingChanges alloc] init];

    if (o) {
        [o setSightedUnits:sightedUnits];
        [o setHiddenUnits:hiddenUnits];
    }

    return o;
}

- (void)runWithParent:(BATAnimationList*)list {
    DEBUG_ANIMATION(@"running animation %@", self);

    HXMCoordinateTransformer* xformer = [list xformer];

    // Newly-sighted units might have their layers out of position; get the
    // layer in place and don't bother animating it when we do so
    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    for (BATUnit* unit in _sightedUnits) {
        CALayer* unitLayer = [UnitView viewForUnit:unit];
        [unitLayer setPosition:[xformer hexCenterToScreen:[unit location]]];
        [unitLayer setNeedsDisplay];
    }

    [CATransaction commit];

    // The opacity changes, on the other hand, do get animated
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{ [list run:nil]; }];

    for (BATUnit* unit in _sightedUnits) {
        CALayer* unitLayer = [UnitView viewForUnit:unit];
        [unitLayer setHidden:NO];
        [unitLayer setOpacity:1.0f];
    }

    for (BATUnit* unit in _hiddenUnits)
        [[UnitView viewForUnit:unit] setOpacity:0.0f];

    [CATransaction commit];

    for (BATUnit* unit in _hiddenUnits)
        [[UnitView viewForUnit:unit] setHidden:YES];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SIGHTED newSighted:%@ newHidden %@",
            _sightedUnits,
            _hiddenUnits];
}

@end

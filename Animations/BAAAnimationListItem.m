//
//  BAAAnimationListItem.m
//  Bull Run
//
//  Created by Dave Townsend on 4/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BAAAnimationListItem.h"
#import "BAAAnimationList.h"
#import "BAUnit.h"

@implementation BAAAnimationListItem

+ (id)itemMoving:(BAUnit*)unit toHex:(HMHex)hex {
    BAAAnimationListItem* o = [[BAAAnimationListItem alloc] init];

    if (o) {
        [o setType:LIT_MOVE];
        [o setActor:unit];
        [o setDestination:hex];
    }

    return o;
}

- (void)runWithParent:(BAAAnimationList*)list {
    DEBUG_ANIMATION(@"running animation %@", self);
    [list run:nil];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"type:%d actor:%@ hex:%02d%02d",
            [self type],
            [[self actor] name],
            [self destination].column,
            [self destination].row
            ];
}

@end

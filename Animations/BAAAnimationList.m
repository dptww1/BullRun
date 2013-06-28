//
//  BAAAnimationList.m
//  Bull Run
//
//  Created by Dave Townsend on 4/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BAAAnimationList.h"
#import "BAAAnimationListItemCombat.h"
#import "BAAAnimationListItemMove.h"
#import "BAGame.h"

//==============================================================================
@interface BAAAnimationList ()

@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic, assign) int             nextItemIdx;
@property (nonatomic, copy)   void            (^completionBlock)(void);
@property (nonatomic, weak, readwrite)        HXMCoordinateTransformer* xformer;

@end

//==============================================================================
@implementation BAAAnimationList

+ (BAAAnimationList*) listWithCoordXFormer:(HXMCoordinateTransformer *)xformer {
    BAAAnimationList* o = [[BAAAnimationList alloc] init];

    if (o) {
        [o setItems:[NSMutableArray array]];
        [o setNextItemIdx:-1];
        [o setXformer:xformer];
    }

    return o;
}

- (void)addItem:(BAAAnimationListItem *)item {
    [[self items] addObject:item];
}

- (void)reset {
    [[self items] removeAllObjects];
    [self setNextItemIdx:-1];
}

- (void)run:(void (^)(void))completionBlock {
    if (completionBlock)
        [self setCompletionBlock:completionBlock];
    else
        [game doSighting:[game userSide]];

    if ([self nextItemIdx] == -1)
        DEBUG_ANIMATION(@"BAAAnimationList run() BEGIN");

    // Are we done?
    if ([self nextItemIdx] >= (int)([[self items] count] - 1)) {
        DEBUG_ANIMATION(@"BAAAnimationList run() END, calling completion block");
        if ([self completionBlock])
            [self completionBlock]();
        return;
    }

    // Need to increment index before running the current list item,
    // since runWithParent might recurse here.
    [self setNextItemIdx:[self nextItemIdx] + 1];

    [[[self items] objectAtIndex:[self nextItemIdx]] runWithParent:self];
}

@end

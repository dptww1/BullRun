//
//  BATAnimationList.m
//
//  Created by Dave Townsend on 4/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BATAnimationList.h"
#import "BATAnimationListItemCombat.h"
#import "BATAnimationListItemMove.h"
#import "BATGame.h"

//==============================================================================
@interface BATAnimationList ()

@property (nonatomic, strong)          NSMutableArray*           items;
@property (nonatomic, assign)          int                       nextItemIdx;
@property (nonatomic, copy)            void                     (^completionBlock)(void);
@property (nonatomic, weak, readwrite) HXMCoordinateTransformer* xformer;

@end

//==============================================================================
@implementation BATAnimationList

+ (BATAnimationList*) listWithCoordXFormer:(HXMCoordinateTransformer *)xformer {
    BATAnimationList* o = [[BATAnimationList alloc] init];

    if (o) {
        [o setItems:[NSMutableArray array]];
        [o setNextItemIdx:-1];
        [o setXformer:xformer];
    }

    return o;
}

- (void)addItem:(BATAnimationListItem *)item {
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
        DEBUG_ANIMATION(@"BATAnimationList run() BEGIN");

    // Are we done?
    if ([self nextItemIdx] >= (int)([[self items] count] - 1)) {
        DEBUG_ANIMATION(@"BATAnimationList run() END, calling completion block");
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

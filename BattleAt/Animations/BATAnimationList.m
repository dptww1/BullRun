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
    [_items addObject:item];
}

- (void)reset {
    [_items removeAllObjects];
    [self setNextItemIdx:-1];
}

- (void)run:(void (^)(void))completionBlock {
    if (completionBlock)
        [self setCompletionBlock:completionBlock];
    else
        [game doSighting:[game userSide]];

    if (_nextItemIdx == -1)
        DEBUG_ANIMATION(@"BATAnimationList run() BEGIN");

    // Are we done?
    if (_nextItemIdx >= (int)([_items count] - 1)) {
        DEBUG_ANIMATION(@"BATAnimationList run() END, calling completion block");
        if (_completionBlock)
            _completionBlock();
        return;
    }

    // Need to increment index before running the current list item,
    // since runWithParent might recurse here.
    [self setNextItemIdx:_nextItemIdx + 1];

    [_items[_nextItemIdx] runWithParent:self];
}

@end

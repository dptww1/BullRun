//
//  BAAAnimationListItem.h
//  Bull Run
//
//  Created by Dave Townsend on 4/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHex.h"

@class BAUnit;
@class BAAAnimationList;

typedef enum {
    LIT_MOVE,
    LIT_ATTACK
} BAAAnimationListItemType;

@interface BAAAnimationListItem : NSObject

@property (nonatomic)         BAAAnimationListItemType type;
@property (nonatomic, strong) BAUnit*                  actor;
@property (nonatomic)         HMHex                    destination;

+ (id)itemMoving:(BAUnit*)unit toHex:(HMHex)hex;

- (void)runWithParent:(BAAAnimationList*)list;

@end

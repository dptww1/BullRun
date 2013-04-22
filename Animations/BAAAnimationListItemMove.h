//
//  BAAAnimationListItemMove.h
//  Bull Run
//
//  Created by Dave Townsend on 4/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAAAnimationListItem.h"
#import "HMHex.h"

@class BAUnit;
@class BAAAnimationList;

@interface BAAAnimationListItemMove : BAAAnimationListItem

@property (nonatomic, strong) BAUnit*                  actor;
@property (nonatomic)         HMHex                    startHex;
@property (nonatomic)         HMHex                    endHex;

+ (id)itemMoving:(BAUnit*)unit toHex:(HMHex)hex;

- (void)runWithParent:(BAAAnimationList*)list;

@end

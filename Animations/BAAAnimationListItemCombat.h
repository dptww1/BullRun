//
//  BAAAnimationListItemCombat.h
//  Bull Run
//
//  Created by Dave Townsend on 4/9/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHex.h"

@class BAUnit;
@class BAAAnimationList;

@interface BAAAnimationListItemCombat : NSObject

@property (nonatomic, strong) BAUnit* attacker;
@property (nonatomic, strong) BAUnit* defender;
@property (nonatomic)         HMHex   retreatHex;
@property (nonatomic)         BOOL    advance;

+ (id)itemWithAttacker:(BAUnit*)attacker defender:(BAUnit*)defender retreatTo:(HMHex)retreatHex advance:(BOOL)advance;

- (void)runWithParent:(BAAAnimationList*)list;

@end

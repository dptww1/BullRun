//
//  BAAIInfluenceMap.h
//  Bull Run
//
//  Created by Dave Townsend on 5/24/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHex.h"

@class HMMap;

@interface BAAIInfluenceMap : NSObject

+ (BAAIInfluenceMap*)mapFrom:(HMMap*)board;

- (void)addValue:(float)value atHex:(HMHex)hex;
- (void)dump;
- (void)setValue:(float)value atHex:(HMHex)hex;
- (float)valueAt:(HMHex)hex;
- (void)zeroOut;

@end

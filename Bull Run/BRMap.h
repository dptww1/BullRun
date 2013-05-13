//
//  BRMap.h
//  Bull Run
//
//  Created by Dave Townsend on 5/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "HMMap.h"

@interface BRMap : HMMap

- (BOOL)isEnemy:(HMHex)hex of:(PlayerSide)side;  // TODO:BR-specific

@end

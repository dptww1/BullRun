//
//  HMPathFinder.h
//  Bull Run
//
//  Created by Dave Townsend on 5/29/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHex.h"

@class HMMap;

typedef float (^HMPathFinderEvalFn)(HMHex, HMHex to);

@interface HMPathFinder : NSObject

+ (HMPathFinder*)pathFinderOnMap:(HMMap*)map;

// Designated Initializer
- initForMap:(HMMap*)map;

// Returns array of NSValue-wrapped HMHexes, with [0] == start
// and [n] = end.  Will be empty if no path is possible, or start == end.
- (NSArray*)findPathFrom:(HMHex)start to:(HMHex)end using:(HMPathFinderEvalFn)fn;

@end

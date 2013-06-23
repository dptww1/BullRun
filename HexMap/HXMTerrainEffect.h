//
//  HXMTerrainEffect.h
//
//  Created by Dave Townsend on 2/4/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Collects the information related to a single type of terrain.
 */
@interface HXMTerrainEffect : NSObject <NSCoding>

/** The bit number (0-31) used by this terrain type in the map data. */
@property (nonatomic,assign) int bitNum;

/** The name of this terrain type: "Clear", "Forest", etc. */
@property (nonatomic,strong) NSString* name;

/** The number of movement points required to enter a hex of this type. */
@property (nonatomic,assign) float mpCost;

/**
 * Designated initializer.
 */
- (id)initWithBitNum:(int)bitNum name:(NSString*)name mpCost:(float)cost;

@end

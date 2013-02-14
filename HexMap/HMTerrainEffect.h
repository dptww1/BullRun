//
//  HMTerrainEffect.h
//  Bull Run
//
//  Created by Dave Townsend on 2/4/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMTerrainEffect : NSObject <NSCoding>

@property (nonatomic)         int       bitNum; // 0-31
@property (strong, nonatomic) NSString* name;   // "Clear", "Forest", etc.
@property (nonatomic)         float     mpCost;

- (id)initWithBitNum:(int)bitNum name:(NSString*)name mpCost:(float)cost;

@end

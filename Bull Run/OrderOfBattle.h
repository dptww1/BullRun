//
//  OrderOfBattle.h
//  Bull Run
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BullRun.h"
#import "HMHex.h"

@class BAReinforcementInfo;
@class Unit;

@interface OrderOfBattle : NSObject

// Array of Unit*
@property (nonatomic, strong) NSArray* units;

// Array of BAReinforcementInfo*
@property (nonatomic, strong) NSMutableArray* reinforcements;

+ (OrderOfBattle*)createFromFile:(NSString*)filepath;

- (BOOL)saveToFile:(NSString*)filename;
- (NSArray*)unitsForSide:(PlayerSide)side;
- (void)addReinforcementInfo:(BAReinforcementInfo*)reinforcementInfo;
@end

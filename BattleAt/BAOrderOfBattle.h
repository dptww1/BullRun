//
//  BAOrderOfBattle.h
//  Bull Run
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BullRun.h"
#import "HMHex.h"

@class BAReinforcementInfo;
@class BAUnit;

@interface BAOrderOfBattle : NSObject

// Array of Unit*
@property (nonatomic, strong) NSArray* units;

// Array of BAReinforcementInfo*
@property (nonatomic, strong) NSMutableArray* reinforcements;

+ (BAOrderOfBattle*)createFromFile:(NSString*)filepath;

- (BOOL)saveToFile:(NSString*)filename;

- (BAUnit*)unitByName:(NSString*)name;
- (NSArray*)unitsForSide:(PlayerSide)side;

- (void)addReinforcementInfo:(BAReinforcementInfo*)reinforcementInfo;

@end

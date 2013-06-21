//
//  BAOrderOfBattle.m
//  Bull Run
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BAGame.h"
#import "BAOrderOfBattle.h"
#import "BAReinforcementInfo.h"
#import "BAUnit.h"
#import "BullRun.h"
#import "DPTSysUtil.h"
#import "HXMHex.h"
#import "NSArray+DPTUtil.h"

@implementation BAOrderOfBattle

#pragma mark - Init Methods

- (id)init {
    self = [super init];

    if (self) {
        _reinforcements = [NSMutableArray array];
    }

    return self;
}

#pragma mark - Persistence Methods

+ (BAOrderOfBattle*)createFromFile:(NSString *)filepath {
    BAOrderOfBattle* oob = [[BAOrderOfBattle alloc] init];

    if (oob) {
        [oob setUnits:[NSKeyedUnarchiver unarchiveObjectWithFile:filepath]];

        // Handle reinforcements
        [[oob units] enumerateObjectsUsingBlock:^(BAUnit* unit, NSUInteger idx, BOOL* stop) {
            // Nothing to do if unit starts on map
            if ([unit turn] == 0)
                return;

            BAReinforcementInfo* ri = [BAReinforcementInfo createWithUnit:unit];
            DEBUG_REINFORCEMENTS(@"Reinforcement: %@ arrives at %02d%02d on turn %d",
                                 [ri unitName],
                                 [ri entryLocation].column,
                                 [ri entryLocation].row,
                                 [ri entryTurn]);
            [oob addReinforcementInfo:ri];
            [unit setLocation:HXMHexMake(-1, -1)];
        }];
    }

    return oob;
}

- (BOOL)saveToFile:(NSString *)filename {
    NSString* path = [[DPTSysUtil applicationFileDir] stringByAppendingPathComponent:filename];

    BOOL success = [NSKeyedArchiver archiveRootObject:[self units] toFile:path];
    
    NSLog(@"Wrote file [%d] %@", success, path);
    
    return success;
}

#pragma mark - Behaviors

- (BAUnit*)unitByName:(NSString*)name {
    return (BAUnit*)
        [_units dpt_find:^BOOL(BAUnit* u) {
            return [[u name] isEqualToString:name];
        }];
}

- (NSArray*)unitsForSide:(PlayerSide)side {
    return [_units dpt_grep:^BOOL(BAUnit* u) { return [u side] == side; }];
}

- (void)addReinforcementInfo:(BAReinforcementInfo*)reinforcementInfo {
    [_reinforcements addObject:reinforcementInfo];
}


@end

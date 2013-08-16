//
//  BATOrderOfBattle.m
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BATGame.h"
#import "BATOrderOfBattle.h"
#import "BATReinforcementInfo.h"
#import "BATUnit.h"
#import "DPTSysUtil.h"
#import "NSArray+DPTUtil.h"

@implementation BATOrderOfBattle

#pragma mark - Init Methods

- (id)init {
    self = [super init];

    if (self) {
        _reinforcements = [NSMutableArray array];
    }

    return self;
}

#pragma mark - Persistence Methods

+ (BATOrderOfBattle*)createFromFile:(NSString*)filepath {
    BATOrderOfBattle* oob = [[BATOrderOfBattle alloc] init];

    if (oob) {
        [oob setUnits:[NSKeyedUnarchiver unarchiveObjectWithFile:filepath]];

        // Handle reinforcements
        [[oob units] enumerateObjectsUsingBlock:^(BATUnit* unit, NSUInteger idx, BOOL* stop) {
            // Nothing to do if unit starts on map
            if ([unit turn] == 0)
                return;

            [oob addReinforcingUnit:[unit name] atHex:[unit location] onTurn:[unit turn]];
            [unit setLocation:HXMHexMake(-1, -1)];
        }];
    }

    return oob;
}

- (BOOL)saveToFile:(NSString*)filename {
    NSString* path = [[DPTSysUtil applicationFileDir] stringByAppendingPathComponent:filename];

    BOOL success = [NSKeyedArchiver archiveRootObject:[self units] toFile:path];
    
    NSLog(@"Wrote file [%d] %@", success, path);
    
    return success;
}

#pragma mark - Behaviors

- (BATUnit*)unitByName:(NSString*)name {
    return (BATUnit*)
        [_units dpt_find:^BOOL(BATUnit* u) {
            return [[u name] isEqualToString:name];
        }];

    // I can't think of a reason why we would want to allow queries
    // for units which aren't actually in the game.
    @throw [NSException exceptionWithName:@"unitByName illegal state"
                                   reason:name
                                 userInfo:nil];
}

- (NSArray*)unitsForSide:(PlayerSide)side {
    return [_units dpt_grep:^BOOL(BATUnit* u) { return [u side] == side; }];
}

- (void)deleteReinforcementInfoForUnitName:(NSString*)unitName {
    for (NSUInteger i = 0; i < [_reinforcements count]; ++i) {
        BATReinforcementInfo* info = [_reinforcements objectAtIndex:i];
        if ([[info unitName] isEqualToString:unitName]) {
            [_reinforcements removeObjectAtIndex:i];
            DEBUG_REINFORCEMENTS(@"Deleting reinforcement %@ at index %d",
                                 unitName, i);
            return;
        }
    }

    DEBUG_REINFORCEMENTS(@"Deleting reinforcement %@ but there was none to remove", unitName);
}

- (void)removeFromGame:(NSString*)unitName {
    [[self unitByName:unitName] setLocation:HXMHexMake(-1, -1)];
    [self deleteReinforcementInfoForUnitName:unitName];
    // TODO: notifications?
}

- (void)addStartingUnit:(NSString*)unitName atHex:(HXMHex)hex {
    [[self unitByName:unitName] setLocation:hex];
    [self deleteReinforcementInfoForUnitName:unitName];
    // TODO: notifications?
}

- (void)addReinforcingUnit:(NSString*)unitName atHex:(HXMHex)hex onTurn:(int)turn {
    // Prevent multiple reinforcement entries for the same unit
    [self deleteReinforcementInfoForUnitName:unitName];

    BATUnit* unit = [self unitByName:unitName];
    [unit setLocation:HXMHexMake(-1, -1)];

    BATReinforcementInfo* rInfo = [BATReinforcementInfo createWithUnit:unit];
    [rInfo setEntryLocation:hex];
    [rInfo setEntryTurn:turn];

    [_reinforcements addObject:rInfo];
}

@end

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
#import "DPTSysUtil.h"
#import "HMHex.h"
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
    }

    return oob;
}

- (BOOL)saveToFile:(NSString *)filename {
    NSString* path = [[DPTSysUtil applicationFileDir] stringByAppendingPathComponent:filename];

    //    NSMutableDictionary* oob = [NSMutableDictionary dictionary];
    //    [oob setObject:units forKey:@"units"];

    BOOL success = [NSKeyedArchiver archiveRootObject:[self units] toFile:path];
    
    NSLog(@"Wrote file [%d] %@", success, path);
    
    return success;
}

#pragma mark - Behaviors

- (BAUnit*)unitByName:(NSString*)name {
    return (BAUnit*)
        [self.units dpt_find:^BOOL(BAUnit* u) {
                             return [[u name] isEqualToString:name];
                         }];
}

- (NSArray*)unitsForSide:(PlayerSide)side {
    return [self.units dpt_grep:^BOOL(BAUnit* u) { return [u side] == side; }];
}

- (void)addReinforcementInfo:(BAReinforcementInfo*)reinforcementInfo {
    [[self reinforcements] addObject:reinforcementInfo];
}


@end

//
//  OrderOfBattle.m
//  Bull Run
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BAReinforcementInfo.h"
#import "CollectionUtil.h"
#import "HMHex.h"
#import "OrderOfBattle.h"
#import "SysUtil.h"
#import "Unit.h"

@implementation OrderOfBattle

#pragma mark - Init Methods

- (id)init {
    self = [super init];

    if (self) {
        _reinforcements = [NSMutableArray array];
    }

    return self;
}

#pragma mark - Persistence Methods

+ (OrderOfBattle*)createFromFile:(NSString *)filepath {
    OrderOfBattle* oob = [[OrderOfBattle alloc] init];

    if (oob) {
        [oob setUnits:[NSKeyedUnarchiver unarchiveObjectWithFile:filepath]];
    }

    return oob;
}

- (BOOL)saveToFile:(NSString *)filename {
    NSString* path = [[SysUtil applicationFileDir] stringByAppendingPathComponent:filename];

    //    NSMutableDictionary* oob = [NSMutableDictionary dictionary];
    //    [oob setObject:units forKey:@"units"];


    BOOL success = [NSKeyedArchiver archiveRootObject:[self units] toFile:path];
    
    NSLog(@"Wrote file [%d] %@", success, path);
    
    return success;
}

#pragma mark - Behaviors

- (NSArray*)unitsForSide:(PlayerSide)side {
    return [self.units grep:^BOOL(Unit* u) { return [u side] == side; }];
}

- (void)addReinforcementInfo:(BAReinforcementInfo*)reinforcementInfo {
    [[self reinforcements] addObject:reinforcementInfo];
}

@end

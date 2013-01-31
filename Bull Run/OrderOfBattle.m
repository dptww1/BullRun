//
//  OrderOfBattle.m
//  Bull Run
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "OrderOfBattle.h"
#import "Hex.h"
#import "Unit.h"
#import "SysUtil.h"

@implementation OrderOfBattle

#pragma mark - Persistence Methods

+ (OrderOfBattle*)createFromFile:(NSString *)filepath {
    OrderOfBattle* oob = [[OrderOfBattle alloc] init];

    if (oob) {
        NSArray* fsUnitList = [NSArray arrayWithContentsOfFile:filepath];
        
        NSMutableArray* realUnitList = [NSMutableArray arrayWithCapacity:[fsUnitList count]];
                                 
        [fsUnitList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
            NSDictionary* d = obj;
            Unit* u = [[Unit alloc] initWithName:[d valueForKey:@"name"]
                                           side:[[d valueForKey:@"side"] intValue]
                                     leadership:[[d valueForKey:@"leadership"] intValue]
                                       strength:[[d valueForKey:@"strength"] intValue]
                                         morale:[[d valueForKey:@"morale"] intValue]
                                        location:HexMake([[d valueForKey:@"location_col"] intValue], [[d valueForKey:@"location_row"] intValue])
                                          imageX:[[d valueForKey:@"imageX"] intValue]
                                          imageY:[[d valueForKey:@"imageY"] intValue]];
            
            [realUnitList addObject:u];
        }];
        
        [oob setUnits:realUnitList];
    }

    return oob;
}

- (BOOL)saveToFile:(NSString *)filename {
    // Construct the pure Objective-C data structure to store
    NSMutableArray* ocArray = [NSMutableArray arrayWithCapacity:[_units count]];
    [_units enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        Unit* u = obj;
        NSDictionary* d = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInt:[u side]],             @"side",
                           [NSNumber numberWithInt:[u leadership]],       @"leadership",
                           [NSNumber numberWithInt:[u location].column],  @"location_col",
                           [NSNumber numberWithInt:[u location].row],     @"location_row",
                           [NSNumber numberWithInt:[u morale]],           @"morale",
                                                   [u name],              @"name",
                           [NSNumber numberWithInt:[u originalStrength]], @"original_strength",
                           [NSNumber numberWithInt:[u strength]],         @"strength",
                           [NSNumber numberWithInt:[u imageXIdx]],        @"imageX",
                           [NSNumber numberWithInt:[u imageYIdx]],        @"imageY",
                           nil];
        [ocArray addObject:d];
    }];
    
    // Now actually save that
    NSString* path = [[SysUtil applicationFileDir] stringByAppendingPathComponent:filename];
    BOOL success = [ocArray writeToFile:path atomically:YES];
    
    NSLog(@"Wrote file [%d] %@", success, path);
    
    return success;
}

#pragma mark - Behaviors

- (Unit*)unitInHex:(Hex)hex {
    NSUInteger idx = [_units indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL* stop) {
                                                          return HexEquals(((Unit*) obj).location, hex);
                                                      }];
    return idx != NSNotFound ? [_units objectAtIndex:idx] : nil;
}

- (NSArray*)unitsForSide:(PlayerSide)side {
    return nil; // TODO:
}

@end

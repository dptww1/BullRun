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

static NSArray* units;

@implementation OrderOfBattle

- (id)init {
    units = [NSArray arrayWithObjects:[[Unit alloc] initWithName:@"Evans" strength:1500 location:HexMake(1, 0)],
                                      [[Unit alloc] initWithName:@"Cocke" strength:1800 location:HexMake(2, 0)],
                                      nil];
    
    return self;
}

- (Unit*)unitInHex:(Hex)hex {
    NSUInteger idx = [units indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL* stop) {
                                                         return HexEquals(((Unit*) obj).location, hex);
                                                     }];
    return idx != NSNotFound ? [units objectAtIndex:idx] : nil;
}

@end

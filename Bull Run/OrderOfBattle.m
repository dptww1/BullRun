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
    units = [NSArray arrayWithObjects:
                        [[Unit alloc] initWithName:@"Bartow"     strength:1200 location:HexMake(11, 10)],
                        [[Unit alloc] initWithName:@"Bee"        strength:1800 location:HexMake(10, 10)],
                        [[Unit alloc] initWithName:@"Bonham"     strength:3300 location:HexMake(12,  9)],
                        [[Unit alloc] initWithName:@"Cocke"      strength:2700 location:HexMake( 8,  7)],
                        [[Unit alloc] initWithName:@"Early"      strength:1800 location:HexMake(13, 10)],
                        [[Unit alloc] initWithName:@"Evans"      strength:1500 location:HexMake( 7,  5)],
                        [[Unit alloc] initWithName:@"Ewell"      strength:2500 location:HexMake(15, 12)],
                        [[Unit alloc] initWithName:@"Holmes"     strength:1200 location:HexMake(14, 12)],
                        [[Unit alloc] initWithName:@"Jackson"    strength:3000 location:HexMake(12, 10)],
                        [[Unit alloc] initWithName:@"Jones"      strength:2100 location:HexMake(14, 10)],
                        [[Unit alloc] initWithName:@"Kershaw"    strength:1400 location:HexMake(11,  8)],
                        [[Unit alloc] initWithName:@"Longstreet" strength:3000 location:HexMake(13,  9)],
                        [[Unit alloc] initWithName:@"Smith"      strength:3000 location:HexMake(-1, 13)],
             
                        [[Unit alloc] initWithName:@"Blenker"    strength:2700 location:HexMake(15, 4)],
                        [[Unit alloc] initWithName:@"Burnside"   strength:3000 location:HexMake( 8, 2)],
                        [[Unit alloc] initWithName:@"Davies"     strength:2400 location:HexMake(13, 4)],
                        [[Unit alloc] initWithName:@"Franklin"   strength:2400 location:HexMake(10, 2)],
                        [[Unit alloc] initWithName:@"Howard"     strength:2700 location:HexMake(12, 3)],
                        [[Unit alloc] initWithName:@"Keyes"      strength:2700 location:HexMake(10, 4)],
                        [[Unit alloc] initWithName:@"Militia"    strength:2500 location:HexMake(14, 4)],
                        [[Unit alloc] initWithName:@"Porter"     strength:3000 location:HexMake( 9, 2)],
                        [[Unit alloc] initWithName:@"Richardson" strength:3000 location:HexMake(14, 8)],
                        [[Unit alloc] initWithName:@"Schenck"    strength:2100 location:HexMake( 8, 5)],
                        [[Unit alloc] initWithName:@"Sherman"    strength:3000 location:HexMake( 9, 4)],
                        [[Unit alloc] initWithName:@"Volunteers" strength:2500 location:HexMake(14, 5)],
                        [[Unit alloc] initWithName:@"Willcox"    strength:2100 location:HexMake(11, 2)],
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

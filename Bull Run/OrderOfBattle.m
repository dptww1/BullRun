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

@implementation OrderOfBattle

- (id)init {
    _units = [NSArray arrayWithObjects:
                        [[Unit alloc] initWithName:@"Bartow"     side:CSA leadership: 33 strength:1200 morale:15 location:HexMake(12, 10)],
                        [[Unit alloc] initWithName:@"Bee"        side:CSA leadership: 37 strength:1800 morale:15 location:HexMake(11, 10)],
                        [[Unit alloc] initWithName:@"Bonham"     side:CSA leadership: 23 strength:3300 morale:10 location:HexMake(11,  8)],
                        [[Unit alloc] initWithName:@"Cocke"      side:CSA leadership: 16 strength:2700 morale:10 location:HexMake( 7,  6)],
                        [[Unit alloc] initWithName:@"Early"      side:CSA leadership: 45 strength:1800 morale:20 location:HexMake(12,  9)],
                        [[Unit alloc] initWithName:@"Evans"      side:CSA leadership: 49 strength:1500 morale:20 location:HexMake( 6,  4)],
                        [[Unit alloc] initWithName:@"Ewell"      side:CSA leadership: 20 strength:2500 morale:10 location:HexMake(14, 11)],
                        [[Unit alloc] initWithName:@"Holmes"     side:CSA leadership: 12 strength:1200 morale:10 location:HexMake(13, 11)],
                        [[Unit alloc] initWithName:@"Jackson"    side:CSA leadership: 59 strength:3000 morale:20 location:HexMake(11,  9)],
                        [[Unit alloc] initWithName:@"Jones"      side:CSA leadership: 26 strength:2100 morale:10 location:HexMake(13,  9)],
                        [[Unit alloc] initWithName:@"Kershaw"    side:CSA leadership: 39 strength:1400 morale:10 location:HexMake(10,  7)],
                        [[Unit alloc] initWithName:@"Longstreet" side:CSA leadership: 60 strength:3000 morale:15 location:HexMake(12,  8)],
                        [[Unit alloc] initWithName:@"Smith"      side:CSA leadership: 40 strength:3000 morale:10 location:HexMake(-1, 12)],
             
                        [[Unit alloc] initWithName:@"Blenker"    side:USA leadership: 14 strength:2700 morale:10 location:HexMake(14, 3)],
                        [[Unit alloc] initWithName:@"Burnside"   side:USA leadership: 17 strength:3000 morale:10 location:HexMake( 7, 1)],
                        [[Unit alloc] initWithName:@"Davies"     side:USA leadership: 30 strength:2400 morale:10 location:HexMake(12, 3)],
                        [[Unit alloc] initWithName:@"Franklin"   side:USA leadership: 36 strength:2400 morale:10 location:HexMake( 9, 1)],
                        [[Unit alloc] initWithName:@"Howard"     side:USA leadership: 35 strength:2700 morale:10 location:HexMake(11, 2)],
                        [[Unit alloc] initWithName:@"Keyes"      side:USA leadership: 29 strength:2700 morale:10 location:HexMake( 9, 3)],
                        [[Unit alloc] initWithName:@"Militia"    side:USA leadership: 10 strength:2500 morale:10 location:HexMake(13, 3)],
                        [[Unit alloc] initWithName:@"Porter"     side:USA leadership: 47 strength:3000 morale:15 location:HexMake( 8, 1)],
                        [[Unit alloc] initWithName:@"Richardson" side:USA leadership: 38 strength:3000 morale:15 location:HexMake(13, 6)],
                        [[Unit alloc] initWithName:@"Schenck"    side:USA leadership: 13 strength:2100 morale:10 location:HexMake( 7, 4)],
                        [[Unit alloc] initWithName:@"Sherman"    side:USA leadership: 50 strength:3000 morale:20 location:HexMake( 8, 3)],
                        [[Unit alloc] initWithName:@"Volunteers" side:USA leadership: 19 strength:2500 morale:10 location:HexMake(13, 4)],
                        [[Unit alloc] initWithName:@"Willcox"    side:USA leadership: 43 strength:2100 morale:10 location:HexMake(10, 1)],
                        nil];
    
    return self;
}

- (Unit*)unitInHex:(Hex)hex {
    NSUInteger idx = [_units indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL* stop) {
                                                          return HexEquals(((Unit*) obj).location, hex);
                                                      }];
    return idx != NSNotFound ? [_units objectAtIndex:idx] : nil;
}

@end

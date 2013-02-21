//
//  MoveOrdersTests.m
//  Bull Run
//
//  Created by Dave Townsend on 1/18/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "MoveOrders.h"
#import "MoveOrdersTests.h"

static BOOL compareHex(HMHex h1, HMHex h2) {
    return h1.row == h2.row && h1.column == h2.column;
}

@implementation MoveOrdersTests

- (void)testInit {
    MoveOrders* mo = [[MoveOrders alloc] init];
    STAssertNotNil(mo, nil);
}

- (void)testAddHex {
    MoveOrders* mo = [[MoveOrders alloc] init];
    
    [mo addHex:HMHexMake(2, 3)];
    STAssertTrue([mo numHexes] == 1, nil);
    STAssertTrue(compareHex([mo lastHex], HMHexMake(2, 3)), nil);
    
    [mo addHex:HMHexMake(3, 4)];
    STAssertTrue([mo numHexes] == 2, nil);
    STAssertTrue(compareHex([mo lastHex], HMHexMake(3, 4)), nil);
}

- (void)testAddHexForceRealloc {
    MoveOrders* mo = [[MoveOrders alloc] init];
    
    for (int i = 0; i < 100; ++i) {
        [mo addHex:HMHexMake(i, i + 2)];
        STAssertTrue([mo numHexes] == i + 1, nil);
        STAssertTrue(compareHex([mo lastHex], HMHexMake(i, i + 2)), nil);
    }
    
    STAssertEquals([mo numHexes], 100, nil);
}

- (void)testClear {
    MoveOrders* mo = [[MoveOrders alloc] init];
    
    [mo addHex:HMHexMake(7, 3)];
    [mo addHex:HMHexMake(8, 2)];
    STAssertFalse([mo isEmpty], nil);
    
    [mo clear];
    STAssertTrue([mo isEmpty], nil);
    STAssertEquals([mo numHexes], 0, nil);
    STAssertTrue(compareHex([mo lastHex], HMHexMake(-1, -1)), nil);
    STAssertTrue(compareHex([mo firstHexAndRemove:NO], HMHexMake(-1, -1)), nil);
}

- (void)testFirstHexNoRemove {
    MoveOrders* mo = [[MoveOrders alloc] init];
    
    [mo addHex:HMHexMake(7, 3)];
    [mo addHex:HMHexMake(8, 2)];
    STAssertTrue(compareHex([mo firstHexAndRemove:NO], HMHexMake(7, 3)), nil);
    STAssertTrue(compareHex([mo firstHexAndRemove:NO], HMHexMake(7, 3)), nil);
    STAssertTrue(compareHex([mo firstHexAndRemove:NO], HMHexMake(7, 3)), nil);
    STAssertEquals([mo numHexes], 2, nil);
}

- (void)testFirstHexRemove {
    MoveOrders* mo = [[MoveOrders alloc] init];
    
    [mo addHex:HMHexMake(7, 3)];
    [mo addHex:HMHexMake(8, 2)];
    [mo addHex:HMHexMake(9, 5)];
    
    STAssertTrue(compareHex([mo firstHexAndRemove:YES], HMHexMake(7, 3)), nil);
    STAssertEquals([mo numHexes], 2, nil);
    STAssertTrue(compareHex([mo firstHexAndRemove:NO], HMHexMake(8, 2)), nil);
    STAssertTrue(compareHex([mo lastHex], HMHexMake(9, 5)), nil);
    
    STAssertTrue(compareHex([mo firstHexAndRemove:YES], HMHexMake(8, 2)), nil);
    STAssertEquals([mo numHexes], 1, nil);
    STAssertTrue(compareHex([mo firstHexAndRemove:NO], HMHexMake(9, 5)), nil);
    STAssertTrue(compareHex([mo lastHex], HMHexMake(9, 5)), nil);
}

- (void)testCopy {
    MoveOrders* mo = [[MoveOrders alloc] init];
    
    [mo addHex:HMHexMake(7, 5)];
    [mo addHex:HMHexMake(8, 2)];
    [mo addHex:HMHexMake(9, 1)];
    
    MoveOrders* copy = [mo copy];
    STAssertEquals([copy numHexes], 3, nil);
    
    // Removing from source shouldn't affect copy
    [mo firstHexAndRemove:YES];
    STAssertEquals([copy numHexes], 3, nil);
    
    // Verify contents of copy
    STAssertTrue(compareHex([copy firstHexAndRemove:YES], HMHexMake(7, 5)), nil);
    STAssertTrue(compareHex([copy firstHexAndRemove:YES], HMHexMake(8, 2)), nil);
    STAssertTrue(compareHex([copy firstHexAndRemove:YES], HMHexMake(9, 1)), nil);
    STAssertTrue([copy isEmpty], nil);
    
    // Removing from copy shouldn't affect source
    STAssertEquals([mo numHexes], 2, nil);
}

@end

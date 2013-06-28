//
//  BATMoveOrdersTests.m
//
//  Created by Dave Townsend on 1/18/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BATMoveOrders.h"
#import "BATMoveOrdersTests.h"

static BOOL compareHex(HXMHex h1, HXMHex h2) {
    return h1.row == h2.row && h1.column == h2.column;
}

@implementation BATMoveOrdersTests

- (void)testInit {
    BATMoveOrders* mo = [[BATMoveOrders alloc] init];
    STAssertNotNil(mo, nil);
}

- (void)testAddHex {
    BATMoveOrders* mo = [[BATMoveOrders alloc] init];
    
    [mo addHex:HXMHexMake(2, 3)];
    STAssertTrue([mo numHexes] == 1, nil);
    STAssertTrue(compareHex([mo lastHex], HXMHexMake(2, 3)), nil);
    
    [mo addHex:HXMHexMake(3, 4)];
    STAssertTrue([mo numHexes] == 2, nil);
    STAssertTrue(compareHex([mo lastHex], HXMHexMake(3, 4)), nil);
}

- (void)testAddHexForceRealloc {
    BATMoveOrders* mo = [[BATMoveOrders alloc] init];
    
    for (int i = 0; i < 100; ++i) {
        [mo addHex:HXMHexMake(i, i + 2)];
        STAssertTrue([mo numHexes] == i + 1, nil);
        STAssertTrue(compareHex([mo lastHex], HXMHexMake(i, i + 2)), nil);
    }
    
    STAssertEquals([mo numHexes], 100, nil);
}

- (void)testClear {
    BATMoveOrders* mo = [[BATMoveOrders alloc] init];
    
    [mo addHex:HXMHexMake(7, 3)];
    [mo addHex:HXMHexMake(8, 2)];
    STAssertFalse([mo isEmpty], nil);
    
    [mo clear];
    STAssertTrue([mo isEmpty], nil);
    STAssertEquals([mo numHexes], 0, nil);
    STAssertTrue(compareHex([mo lastHex], HXMHexMake(-1, -1)), nil);
    STAssertTrue(compareHex([mo firstHexAndRemove:NO], HXMHexMake(-1, -1)), nil);
}

- (void)testFirstHexNoRemove {
    BATMoveOrders* mo = [[BATMoveOrders alloc] init];
    
    [mo addHex:HXMHexMake(7, 3)];
    [mo addHex:HXMHexMake(8, 2)];
    STAssertTrue(compareHex([mo firstHexAndRemove:NO], HXMHexMake(7, 3)), nil);
    STAssertTrue(compareHex([mo firstHexAndRemove:NO], HXMHexMake(7, 3)), nil);
    STAssertTrue(compareHex([mo firstHexAndRemove:NO], HXMHexMake(7, 3)), nil);
    STAssertEquals([mo numHexes], 2, nil);
}

- (void)testFirstHexRemove {
    BATMoveOrders* mo = [[BATMoveOrders alloc] init];
    
    [mo addHex:HXMHexMake(7, 3)];
    [mo addHex:HXMHexMake(8, 2)];
    [mo addHex:HXMHexMake(9, 5)];
    
    STAssertTrue(compareHex([mo firstHexAndRemove:YES], HXMHexMake(7, 3)), nil);
    STAssertEquals([mo numHexes], 2, nil);
    STAssertTrue(compareHex([mo firstHexAndRemove:NO], HXMHexMake(8, 2)), nil);
    STAssertTrue(compareHex([mo lastHex], HXMHexMake(9, 5)), nil);
    
    STAssertTrue(compareHex([mo firstHexAndRemove:YES], HXMHexMake(8, 2)), nil);
    STAssertEquals([mo numHexes], 1, nil);
    STAssertTrue(compareHex([mo firstHexAndRemove:NO], HXMHexMake(9, 5)), nil);
    STAssertTrue(compareHex([mo lastHex], HXMHexMake(9, 5)), nil);
}

- (void)testCopy {
    BATMoveOrders* mo = [[BATMoveOrders alloc] init];
    
    [mo addHex:HXMHexMake(7, 5)];
    [mo addHex:HXMHexMake(8, 2)];
    [mo addHex:HXMHexMake(9, 1)];
    
    BATMoveOrders* copy = [mo copy];
    STAssertEquals([copy numHexes], 3, nil);
    
    // Removing from source shouldn't affect copy
    [mo firstHexAndRemove:YES];
    STAssertEquals([copy numHexes], 3, nil);
    
    // Verify contents of copy
    STAssertTrue(compareHex([copy firstHexAndRemove:YES], HXMHexMake(7, 5)), nil);
    STAssertTrue(compareHex([copy firstHexAndRemove:YES], HXMHexMake(8, 2)), nil);
    STAssertTrue(compareHex([copy firstHexAndRemove:YES], HXMHexMake(9, 1)), nil);
    STAssertTrue([copy isEmpty], nil);
    
    // Removing from copy shouldn't affect source
    STAssertEquals([mo numHexes], 2, nil);
}

@end

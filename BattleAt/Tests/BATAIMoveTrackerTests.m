//
//  BATAIMoveTrackerTests.m
//  Bull Run
//
//  Created by Dave Townsend on 1/18/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BATAIMoveTracker.h"
#import "BATAIMoveTrackerTests.h"
#import "BAUnit.h"


@implementation BATAIMoveTrackerTests

- (void)testTracker {
    BATAIMoveTracker* mt = [BATAIMoveTracker tracker];
    STAssertNotNil(mt, nil);
}

- (void)testInit {
    BATAIMoveTracker* mt = [[BATAIMoveTracker alloc] init];
    STAssertNotNil(mt, nil);
}

- (void)testEmpty {
    BATAIMoveTracker* mt = [BATAIMoveTracker tracker];

    BAUnit* u = [mt unitIn:HXMHexMake(1, 2) onImpulse:1];
    STAssertNil(u, nil);

    u = [mt unitIn:HXMHexMake(1, 2) onImpulse:2];
    STAssertNil(u, nil);
}

- (void)testCaching {
    BAUnit* unit1 = [[BAUnit alloc] init];
    BAUnit* unit2 = [[BAUnit alloc] init];

    BATAIMoveTracker* mt = [BATAIMoveTracker tracker];

    [mt track:unit1 movingTo:HXMHexMake(1, 2) onImpulse:1];
    [mt track:unit1 movingTo:HXMHexMake(2, 2) onImpulse:2];
    [mt track:unit1 movingTo:HXMHexMake(3, 1) onImpulse:3];

    [mt track:unit2 movingTo:HXMHexMake(7, 6) onImpulse:1];
    [mt track:unit2 movingTo:HXMHexMake(7, 5) onImpulse:2];

    STAssertEquals([mt unitIn:HXMHexMake(1, 2) onImpulse:1], unit1, nil);
    STAssertEquals([mt unitIn:HXMHexMake(2, 2) onImpulse:2], unit1, nil);
    STAssertEquals([mt unitIn:HXMHexMake(3, 1) onImpulse:3], unit1, nil);

    STAssertEquals([mt unitIn:HXMHexMake(7, 6) onImpulse:1], unit2, nil);
    STAssertEquals([mt unitIn:HXMHexMake(7, 5) onImpulse:2], unit2, nil);

    // Now do a few intentional cache misses

    STAssertNil([mt unitIn:HXMHexMake(1, 2) onImpulse:2], nil);
    STAssertNil([mt unitIn:HXMHexMake(1, 2) onImpulse:3], nil);
    STAssertNil([mt unitIn:HXMHexMake(1, 2) onImpulse:4], nil);
    STAssertNil([mt unitIn:HXMHexMake(3, 1) onImpulse:1], nil);
}

- (void)testClear {
    BAUnit* unit1 = [[BAUnit alloc] init];
    BAUnit* unit2 = [[BAUnit alloc] init];

    BATAIMoveTracker* mt = [BATAIMoveTracker tracker];

    [mt track:unit1 movingTo:HXMHexMake(1, 2) onImpulse:1];
    [mt track:unit1 movingTo:HXMHexMake(2, 2) onImpulse:2];
    [mt track:unit1 movingTo:HXMHexMake(3, 1) onImpulse:3];

    [mt track:unit2 movingTo:HXMHexMake(7, 6) onImpulse:1];
    [mt track:unit2 movingTo:HXMHexMake(7, 5) onImpulse:2];

    [mt clear];

    STAssertNil([mt unitIn:HXMHexMake(1, 2) onImpulse:1], nil);
    STAssertNil([mt unitIn:HXMHexMake(2, 2) onImpulse:2], nil);
    STAssertNil([mt unitIn:HXMHexMake(3, 1) onImpulse:3], nil);

    STAssertNil([mt unitIn:HXMHexMake(7, 6) onImpulse:1], nil);
    STAssertNil([mt unitIn:HXMHexMake(7, 5) onImpulse:2], nil);

    STAssertNil([mt unitIn:HXMHexMake(1, 2) onImpulse:2], nil);
    STAssertNil([mt unitIn:HXMHexMake(1, 2) onImpulse:3], nil);
    STAssertNil([mt unitIn:HXMHexMake(1, 2) onImpulse:4], nil);
    STAssertNil([mt unitIn:HXMHexMake(3, 1) onImpulse:1], nil);
}

@end
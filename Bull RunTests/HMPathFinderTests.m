//
//  HMPathFinderTests.m
//  Bull Run
//
//  Created by Dave Townsend on 5/31/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "HMGeometry.h"
#import "HMHex.h"
#import "HMMap.h"
#import "HMPathFinder.h"
#import "HMPathFinderTests.h"
#import "NSValue+HMHex.h"

//==============================================================================
@interface HMPathFinderTests ()

@property (nonatomic,strong) HMMap* map;

@end

//==============================================================================
@implementation HMPathFinderTests (Private)

- (BOOL)hexIn:(NSArray*)array at:(int)idx is:(HMHex)hex {
    if (idx >= [array count])
        return NO;
    
    NSValue* v = [array objectAtIndex:idx];
    return HMHexEquals(hex, [v hexValue]);
}

@end

//==============================================================================
@implementation HMPathFinderTests (CostFns)

- (HMPathFinderCostFn)trivialCostFn {
    return ^(HMHex from, HMHex to) { return 1.0f; };
}

- (HMPathFinderCostFn)barrier0604CostFn {
    return ^(HMHex from, HMHex to) {
        return HMHexEquals(to, HMHexMake(6, 4)) ? 10.0f : 1.0f;
    };
}

- (HMPathFinderCostFn)blockedCostFn {
    return ^(HMHex from, HMHex to) {
        return to.row == 4 ? -1.0f : 1.0f;
    };
}

- (HMPathFinderCostFn)shortcutCostFn {
    return ^(HMHex from, HMHex to) {
        if (   (HMHexEquals(HMHexMake(1,2), from) && HMHexEquals(HMHexMake(1,1), to))
            || (HMHexEquals(HMHexMake(1,1), from) && HMHexEquals(HMHexMake(2,0), to))
            || (HMHexEquals(HMHexMake(2,0), from) && HMHexEquals(HMHexMake(3,1), to))
            || (HMHexEquals(HMHexMake(3,1), from) && HMHexEquals(HMHexMake(3,2), to))
            || (HMHexEquals(HMHexMake(3,2), from) && HMHexEquals(HMHexMake(3,3), to))
            || (HMHexEquals(HMHexMake(3,3), from) && HMHexEquals(HMHexMake(3,4), to))
            || (HMHexEquals(HMHexMake(3,4), from) && HMHexEquals(HMHexMake(3,5), to))
            || (HMHexEquals(HMHexMake(3,5), from) && HMHexEquals(HMHexMake(3,6), to))
            || (HMHexEquals(HMHexMake(3,6), from) && HMHexEquals(HMHexMake(3,7), to))
            || (HMHexEquals(HMHexMake(3,7), from) && HMHexEquals(HMHexMake(4,6), to))
            || (HMHexEquals(HMHexMake(4,6), from) && HMHexEquals(HMHexMake(5,6), to))
            || (HMHexEquals(HMHexMake(5,6), from) && HMHexEquals(HMHexMake(6,5), to))
            || (HMHexEquals(HMHexMake(6,5), from) && HMHexEquals(HMHexMake(6,4), to))
            || (HMHexEquals(HMHexMake(6,4), from) && HMHexEquals(HMHexMake(5,4), to))
           )
           return 1.0f;

         return 5.0f;
    };
}

- (HMPathFinderCostFn)scaledShortcutCostFn {
    return ^(HMHex from, HMHex to) {
        return [self shortcutCostFn](from, to) / 2.0f;
    };
}

@end


//==============================================================================
@implementation HMPathFinderTests

- (void)setUp {
    [super setUp];
    HMGeometry* g = [[HMGeometry alloc] initWithLongGrain:NO
                                        firstColumnIsLong:NO
                                                  numRows:10
                                               numColumns:9];
    _map = [[HMMap alloc] initWithGeometry:g];
}

//------------------------------------------------------------------------------
// start == end
- (void)testCoincidentHexes {
    HMPathFinder* pf = [HMPathFinder pathFinderOnMap:_map withMinCost:1.0f];
    NSArray* path = [pf findPathFrom:HMHexMake(3,3) to:HMHexMake(3,3) using:nil];
    STAssertEquals([path count], 1u, nil);
    STAssertTrue([self hexIn:path at:0 is:HMHexMake(3,3)], nil);
}

//------------------------------------------------------------------------------
// start is next to end
- (void)testAdjacent {
    HMPathFinder* pf = [HMPathFinder pathFinderOnMap:_map withMinCost:1.0f];
    NSArray* path = [pf findPathFrom:HMHexMake(3,3) to:HMHexMake(4,2) using:[self trivialCostFn]];
    STAssertEquals([path count], 2u, nil);
    STAssertTrue([self hexIn:path at:0 is:HMHexMake(3,3)], nil);
    STAssertTrue([self hexIn:path at:1 is:HMHexMake(4,2)], nil);
}

//------------------------------------------------------------------------------
// end is 4 hexes away from start in direction 2
- (void)testStraightLine {
    HMPathFinder* pf = [HMPathFinder pathFinderOnMap:_map withMinCost:1.0f];
    NSArray* path = [pf findPathFrom:HMHexMake(3,3) to:HMHexMake(7,5) using:[self trivialCostFn]];
    STAssertEquals([path count], 5u, nil);
    STAssertTrue([self hexIn:path at:0 is:HMHexMake(3,3)], nil);
    STAssertTrue([self hexIn:path at:1 is:HMHexMake(4,3)], nil);
    STAssertTrue([self hexIn:path at:2 is:HMHexMake(5,4)], nil);
    STAssertTrue([self hexIn:path at:3 is:HMHexMake(6,4)], nil);
    STAssertTrue([self hexIn:path at:4 is:HMHexMake(7,5)], nil);
}

//------------------------------------------------------------------------------
// end is 4 hexes away from start in direction 2, but a hex in the direct path
// has a prohibitive cost, so the optimal path routes around it
- (void)testCrooked {
    HMPathFinder* pf = [HMPathFinder pathFinderOnMap:_map withMinCost:1.0f];
    NSArray* path = [pf findPathFrom:HMHexMake(3,3) to:HMHexMake(7,5) using:[self barrier0604CostFn]];
    STAssertEquals([path count], 6u, nil);
    STAssertTrue([self hexIn:path at:0 is:HMHexMake(3,3)], nil);
    STAssertTrue([self hexIn:path at:1 is:HMHexMake(4,3)], nil);
    STAssertTrue([self hexIn:path at:2 is:HMHexMake(5,4)], nil);
    STAssertTrue([self hexIn:path at:3 is:HMHexMake(6,3)], nil);
    STAssertTrue([self hexIn:path at:4 is:HMHexMake(7,4)], nil);
    STAssertTrue([self hexIn:path at:5 is:HMHexMake(7,5)], nil);
}

//------------------------------------------------------------------------------
// end is 4 hexes away from start in direction 2, but moving hex to hex costs
// 5 except for moving along the following path, which is just 1 per hex.
//     __    __    __    __    __
//  __/  \__/  \__/  \__/  \__/  \
// /  \__/2 \__/  \__/  \__/  \__/
// \__/1 \__/3 \__/  \__/  \__/  \
// /  \__/  \__/  \__/  \__/  \__/
// \__/0 \__/4 \__/  \__/  \__/  \
// /  \__/  \__/  \__/  \__/  \__/
// \__/  \__/5 \__/  \__/  \__/  \
// /  \__/  \__/  \__/  \__/  \__/
// \__/  \__/6 \__/14\__/  \__/  \
// /  \__/  \__/  \__/13\__/  \__/
// \__/  \__/7 \__/  \__/  \__/  \
// /  \__/  \__/  \__/12\__/  \__/
// \__/  \__/8 \__/11\__/  \__/  \
// /  \__/  \__/10\__/  \__/  \__/
// \__/  \__/9 \__/  \__/  \__/  \
//    \__/  \__/  \__/  \__/  \__/
//
// This makes the direct path cost 20 and the shortcut cost 14, so the shortcut
// is the optimal path despite the number of hexes.
//
// Because of the (intentional) circuitous nature of the optimal route, the
// default cost has to be pretty high relative to the optimal cost to prevent
// the algorithm from shortcutting directly from 5 -> 14.
- (void)testShortcut {
    HMPathFinder* pf = [HMPathFinder pathFinderOnMap:_map withMinCost:1.0f];
    NSArray* path = [pf findPathFrom:HMHexMake(1,2) to:HMHexMake(5,4) using:[self shortcutCostFn]];
    STAssertEquals([path count], 15u, nil);
    STAssertTrue([self hexIn:path at:0 is:HMHexMake(1,2)], nil);
    STAssertTrue([self hexIn:path at:1 is:HMHexMake(1,1)], nil);
    STAssertTrue([self hexIn:path at:2 is:HMHexMake(2,0)], nil);
    STAssertTrue([self hexIn:path at:3 is:HMHexMake(3,1)], nil);
    STAssertTrue([self hexIn:path at:4 is:HMHexMake(3,2)], nil);
    STAssertTrue([self hexIn:path at:5 is:HMHexMake(3,3)], nil);
    STAssertTrue([self hexIn:path at:6 is:HMHexMake(3,4)], nil);
    STAssertTrue([self hexIn:path at:7 is:HMHexMake(3,5)], nil);
    STAssertTrue([self hexIn:path at:8 is:HMHexMake(3,6)], nil);
    STAssertTrue([self hexIn:path at:9 is:HMHexMake(3,7)], nil);
    STAssertTrue([self hexIn:path at:10 is:HMHexMake(4,6)], nil);
    STAssertTrue([self hexIn:path at:11 is:HMHexMake(5,6)], nil);
    STAssertTrue([self hexIn:path at:12 is:HMHexMake(6,5)], nil);
    STAssertTrue([self hexIn:path at:13 is:HMHexMake(6,4)], nil);
    STAssertTrue([self hexIn:path at:14 is:HMHexMake(5,4)], nil);
}

//------------------------------------------------------------------------------
// Same as testShortcut, but using a different scaling
- (void)testShortcutWithScaling {
    HMPathFinder* pf = [HMPathFinder pathFinderOnMap:_map withMinCost:0.5f];
    NSArray* path = [pf findPathFrom:HMHexMake(1,2) to:HMHexMake(5,4) using:[self scaledShortcutCostFn]];
    STAssertEquals([path count], 15u, nil);
    STAssertTrue([self hexIn:path at:0 is:HMHexMake(1,2)], nil);
    STAssertTrue([self hexIn:path at:1 is:HMHexMake(1,1)], nil);
    STAssertTrue([self hexIn:path at:2 is:HMHexMake(2,0)], nil);
    STAssertTrue([self hexIn:path at:3 is:HMHexMake(3,1)], nil);
    STAssertTrue([self hexIn:path at:4 is:HMHexMake(3,2)], nil);
    STAssertTrue([self hexIn:path at:5 is:HMHexMake(3,3)], nil);
    STAssertTrue([self hexIn:path at:6 is:HMHexMake(3,4)], nil);
    STAssertTrue([self hexIn:path at:7 is:HMHexMake(3,5)], nil);
    STAssertTrue([self hexIn:path at:8 is:HMHexMake(3,6)], nil);
    STAssertTrue([self hexIn:path at:9 is:HMHexMake(3,7)], nil);
    STAssertTrue([self hexIn:path at:10 is:HMHexMake(4,6)], nil);
    STAssertTrue([self hexIn:path at:11 is:HMHexMake(5,6)], nil);
    STAssertTrue([self hexIn:path at:12 is:HMHexMake(6,5)], nil);
    STAssertTrue([self hexIn:path at:13 is:HMHexMake(6,4)], nil);
    STAssertTrue([self hexIn:path at:14 is:HMHexMake(5,4)], nil);
}

//------------------------------------------------------------------------------
// No path is possible because impassable hexes block any possible row
- (void)testNoPathPossibleBarrier {
    HMPathFinder* pf = [HMPathFinder pathFinderOnMap:_map withMinCost:1.0f];
    NSArray* path = [pf findPathFrom:HMHexMake(1,1) to:HMHexMake(7,5) using:[self blockedCostFn]];
    STAssertEquals([path count], 0u, nil);
}

//------------------------------------------------------------------------------
// No path possible because destination hex isn't on grid.
- (void)testNoPathPossibleIllegalHex {
    HMPathFinder* pf = [HMPathFinder pathFinderOnMap:_map withMinCost:1.0f];
    NSArray* path = [pf findPathFrom:HMHexMake(1,1) to:HMHexMake(100,100) using:[self trivialCostFn]];
    STAssertEquals([path count], 0u, nil);
}

@end

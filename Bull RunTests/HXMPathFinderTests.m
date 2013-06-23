//
//  HMPathFinderTests.m
//  Bull Run
//
//  Created by Dave Townsend on 5/31/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "HXMGeometry.h"
#import "HXMHex.h"
#import "HXMMap.h"
#import "HXMPathFinder.h"
#import "HXMPathFinderTests.h"
#import "NSValue+HXMHex.h"

//==============================================================================
@interface HXMPathFinderTests ()

@property (nonatomic,strong) HXMMap* map;

@end

//==============================================================================
@implementation HXMPathFinderTests (Private)

- (BOOL)hexIn:(NSArray*)array at:(int)idx is:(HXMHex)hex {
    if (idx >= [array count])
        return NO;
    
    NSValue* v = [array objectAtIndex:idx];
    return HXMHexEquals(hex, [v hexValue]);
}

@end

//==============================================================================
@implementation HXMPathFinderTests (CostFns)

- (HXMPathFinderCostFn)trivialCostFn {
    return ^(HXMHex from, HXMHex to) { return 1.0f; };
}

- (HXMPathFinderCostFn)barrier0604CostFn {
    return ^(HXMHex from, HXMHex to) {
        return HXMHexEquals(to, HXMHexMake(6, 4)) ? 10.0f : 1.0f;
    };
}

- (HXMPathFinderCostFn)blockedCostFn {
    return ^(HXMHex from, HXMHex to) {
        return to.row == 4 ? -1.0f : 1.0f;
    };
}

- (HXMPathFinderCostFn)shortcutCostFn {
    return ^(HXMHex from, HXMHex to) {
        if (   (HXMHexEquals(HXMHexMake(1,2), from) && HXMHexEquals(HXMHexMake(1,1), to))
            || (HXMHexEquals(HXMHexMake(1,1), from) && HXMHexEquals(HXMHexMake(2,0), to))
            || (HXMHexEquals(HXMHexMake(2,0), from) && HXMHexEquals(HXMHexMake(3,1), to))
            || (HXMHexEquals(HXMHexMake(3,1), from) && HXMHexEquals(HXMHexMake(3,2), to))
            || (HXMHexEquals(HXMHexMake(3,2), from) && HXMHexEquals(HXMHexMake(3,3), to))
            || (HXMHexEquals(HXMHexMake(3,3), from) && HXMHexEquals(HXMHexMake(3,4), to))
            || (HXMHexEquals(HXMHexMake(3,4), from) && HXMHexEquals(HXMHexMake(3,5), to))
            || (HXMHexEquals(HXMHexMake(3,5), from) && HXMHexEquals(HXMHexMake(3,6), to))
            || (HXMHexEquals(HXMHexMake(3,6), from) && HXMHexEquals(HXMHexMake(3,7), to))
            || (HXMHexEquals(HXMHexMake(3,7), from) && HXMHexEquals(HXMHexMake(4,6), to))
            || (HXMHexEquals(HXMHexMake(4,6), from) && HXMHexEquals(HXMHexMake(5,6), to))
            || (HXMHexEquals(HXMHexMake(5,6), from) && HXMHexEquals(HXMHexMake(6,5), to))
            || (HXMHexEquals(HXMHexMake(6,5), from) && HXMHexEquals(HXMHexMake(6,4), to))
            || (HXMHexEquals(HXMHexMake(6,4), from) && HXMHexEquals(HXMHexMake(5,4), to))
           )
           return 1.0f;

         return 5.0f;
    };
}

- (HXMPathFinderCostFn)scaledShortcutCostFn {
    return ^(HXMHex from, HXMHex to) {
        return [self shortcutCostFn](from, to) / 2.0f;
    };
}

@end


//==============================================================================
@implementation HXMPathFinderTests

- (void)setUp {
    [super setUp];
    HXMGeometry* g = [[HXMGeometry alloc] initWithLongGrain:NO
                                          firstColumnIsLong:NO
                                                    numRows:10
                                                 numColumns:9];
    _map = [[HXMMap alloc] initWithGeometry:g];
}

//------------------------------------------------------------------------------
// start == end
- (void)testCoincidentHexes {
    HXMPathFinder* pf = [HXMPathFinder pathFinderOnMap:_map withMinCost:1.0f];
    NSArray* path = [pf findPathFrom:HXMHexMake(3,3) to:HXMHexMake(3,3) using:nil];
    STAssertEquals([path count], 1u, nil);
    STAssertTrue([self hexIn:path at:0 is:HXMHexMake(3,3)], nil);
}

//------------------------------------------------------------------------------
// start is next to end
- (void)testAdjacent {
    HXMPathFinder* pf = [HXMPathFinder pathFinderOnMap:_map withMinCost:1.0f];
    NSArray* path = [pf findPathFrom:HXMHexMake(3,3) to:HXMHexMake(4,2) using:[self trivialCostFn]];
    STAssertEquals([path count], 2u, nil);
    STAssertTrue([self hexIn:path at:0 is:HXMHexMake(3,3)], nil);
    STAssertTrue([self hexIn:path at:1 is:HXMHexMake(4,2)], nil);
}

//------------------------------------------------------------------------------
// end is 4 hexes away from start in direction 2
- (void)testStraightLine {
    HXMPathFinder* pf = [HXMPathFinder pathFinderOnMap:_map withMinCost:1.0f];
    NSArray* path = [pf findPathFrom:HXMHexMake(3,3) to:HXMHexMake(7,5) using:[self trivialCostFn]];
    STAssertEquals([path count], 5u, nil);
    STAssertTrue([self hexIn:path at:0 is:HXMHexMake(3,3)], nil);
    STAssertTrue([self hexIn:path at:1 is:HXMHexMake(4,3)], nil);
    STAssertTrue([self hexIn:path at:2 is:HXMHexMake(5,4)], nil);
    STAssertTrue([self hexIn:path at:3 is:HXMHexMake(6,4)], nil);
    STAssertTrue([self hexIn:path at:4 is:HXMHexMake(7,5)], nil);
}

//------------------------------------------------------------------------------
// end is 4 hexes away from start in direction 2, but a hex in the direct path
// has a prohibitive cost, so the optimal path routes around it
- (void)testCrooked {
    HXMPathFinder* pf = [HXMPathFinder pathFinderOnMap:_map withMinCost:1.0f];
    NSArray* path = [pf findPathFrom:HXMHexMake(3,3) to:HXMHexMake(7,5) using:[self barrier0604CostFn]];
    STAssertEquals([path count], 6u, nil);
    STAssertTrue([self hexIn:path at:0 is:HXMHexMake(3,3)], nil);
    STAssertTrue([self hexIn:path at:1 is:HXMHexMake(4,3)], nil);
    STAssertTrue([self hexIn:path at:2 is:HXMHexMake(5,4)], nil);
    STAssertTrue([self hexIn:path at:3 is:HXMHexMake(6,3)], nil);
    STAssertTrue([self hexIn:path at:4 is:HXMHexMake(7,4)], nil);
    STAssertTrue([self hexIn:path at:5 is:HXMHexMake(7,5)], nil);
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
    HXMPathFinder* pf = [HXMPathFinder pathFinderOnMap:_map withMinCost:1.0f];
    NSArray* path = [pf findPathFrom:HXMHexMake(1,2) to:HXMHexMake(5,4) using:[self shortcutCostFn]];
    STAssertEquals([path count], 15u, nil);
    STAssertTrue([self hexIn:path at:0 is:HXMHexMake(1,2)], nil);
    STAssertTrue([self hexIn:path at:1 is:HXMHexMake(1,1)], nil);
    STAssertTrue([self hexIn:path at:2 is:HXMHexMake(2,0)], nil);
    STAssertTrue([self hexIn:path at:3 is:HXMHexMake(3,1)], nil);
    STAssertTrue([self hexIn:path at:4 is:HXMHexMake(3,2)], nil);
    STAssertTrue([self hexIn:path at:5 is:HXMHexMake(3,3)], nil);
    STAssertTrue([self hexIn:path at:6 is:HXMHexMake(3,4)], nil);
    STAssertTrue([self hexIn:path at:7 is:HXMHexMake(3,5)], nil);
    STAssertTrue([self hexIn:path at:8 is:HXMHexMake(3,6)], nil);
    STAssertTrue([self hexIn:path at:9 is:HXMHexMake(3,7)], nil);
    STAssertTrue([self hexIn:path at:10 is:HXMHexMake(4,6)], nil);
    STAssertTrue([self hexIn:path at:11 is:HXMHexMake(5,6)], nil);
    STAssertTrue([self hexIn:path at:12 is:HXMHexMake(6,5)], nil);
    STAssertTrue([self hexIn:path at:13 is:HXMHexMake(6,4)], nil);
    STAssertTrue([self hexIn:path at:14 is:HXMHexMake(5,4)], nil);
}

//------------------------------------------------------------------------------
// Same as testShortcut, but using a different scaling
- (void)testShortcutWithScaling {
    HXMPathFinder* pf = [HXMPathFinder pathFinderOnMap:_map withMinCost:0.5f];
    NSArray* path = [pf findPathFrom:HXMHexMake(1,2) to:HXMHexMake(5,4) using:[self scaledShortcutCostFn]];
    STAssertEquals([path count], 15u, nil);
    STAssertTrue([self hexIn:path at:0 is:HXMHexMake(1,2)], nil);
    STAssertTrue([self hexIn:path at:1 is:HXMHexMake(1,1)], nil);
    STAssertTrue([self hexIn:path at:2 is:HXMHexMake(2,0)], nil);
    STAssertTrue([self hexIn:path at:3 is:HXMHexMake(3,1)], nil);
    STAssertTrue([self hexIn:path at:4 is:HXMHexMake(3,2)], nil);
    STAssertTrue([self hexIn:path at:5 is:HXMHexMake(3,3)], nil);
    STAssertTrue([self hexIn:path at:6 is:HXMHexMake(3,4)], nil);
    STAssertTrue([self hexIn:path at:7 is:HXMHexMake(3,5)], nil);
    STAssertTrue([self hexIn:path at:8 is:HXMHexMake(3,6)], nil);
    STAssertTrue([self hexIn:path at:9 is:HXMHexMake(3,7)], nil);
    STAssertTrue([self hexIn:path at:10 is:HXMHexMake(4,6)], nil);
    STAssertTrue([self hexIn:path at:11 is:HXMHexMake(5,6)], nil);
    STAssertTrue([self hexIn:path at:12 is:HXMHexMake(6,5)], nil);
    STAssertTrue([self hexIn:path at:13 is:HXMHexMake(6,4)], nil);
    STAssertTrue([self hexIn:path at:14 is:HXMHexMake(5,4)], nil);
}

//------------------------------------------------------------------------------
// No path is possible because impassable hexes block any possible row
- (void)testNoPathPossibleBarrier {
    HXMPathFinder* pf = [HXMPathFinder pathFinderOnMap:_map withMinCost:1.0f];
    NSArray* path = [pf findPathFrom:HXMHexMake(1,1) to:HXMHexMake(7,5) using:[self blockedCostFn]];
    STAssertEquals([path count], 0u, nil);
}

//------------------------------------------------------------------------------
// No path possible because destination hex isn't on grid.
- (void)testNoPathPossibleIllegalHex {
    HXMPathFinder* pf = [HXMPathFinder pathFinderOnMap:_map withMinCost:1.0f];
    NSArray* path = [pf findPathFrom:HXMHexMake(1,1) to:HXMHexMake(100,100) using:[self trivialCostFn]];
    STAssertEquals([path count], 0u, nil);
}

@end

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
    NSValue* v = [array objectAtIndex:idx];
    return HMHexEquals(hex, [v hexValue]);
}

@end


//==============================================================================
@implementation HMPathFinderTests

- (void)setUp {
    [super setUp];
    HMGeometry* g = [[HMGeometry alloc] initWithLongGrain:NO
                                        firstColumnIsLong:NO
                                                  numRows:10
                                               numColumns:7];
    _map = [[HMMap alloc] initWithGeometry:g];
}

//------------------------------------------------------------------------------
- (void)testCoincidentHexes {
    HMPathFinder* pf = [HMPathFinder pathFinderOnMap:_map];
    NSArray* path = [pf findPathFrom:HMHexMake(3,3) to:HMHexMake(3,3) using:nil];
    STAssertTrue([path count] == 0, @"Path from 0303 to 0303 isn't empty");
}

//------------------------------------------------------------------------------
- (void)testAdjacent {
    HMPathFinder* pf = [HMPathFinder pathFinderOnMap:_map];
    NSArray* path = [pf findPathFrom:HMHexMake(3,3) to:HMHexMake(4,2) using:nil];
    STAssertTrue([path count] == 1, @"Path from 0303 to 0402 isn't one hex");
    STAssertTrue([self hexIn:path at:0 is:HMHexMake(4,2)], nil);
}

//------------------------------------------------------------------------------
- (void)testStraightLine {

}

//------------------------------------------------------------------------------
- (void)testShortcut {
    
}

//------------------------------------------------------------------------------
- (void)testBarrier {

}

//------------------------------------------------------------------------------
- (void)testNoPathPossible {

}

@end

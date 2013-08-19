//
//  HXMHexMapGeometryTests.m
//
//  Created by Dave Townsend on 1/9/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "HXMGeometry.h"
#import "HXMMap.h"
#import "HXMHexMapGeometryTests.h"

static HXMGeometry* geometry;
static HXMMap*      map;

@implementation HXMHexMapGeometryTests

- (void)setUp {
    [super setUp];
    
    /*
     *     __    __    __    __    __
     *  __/  \__/V \__/X \__/Z \__/b \
     * /  \__/  \__/W \__/Y \__/a \__/
     * \__/  \__/U \__/  \__/  \__/c \
     * /  \__/T \__/  \__/  \__/  \__/
     * \__/  \__/  \__/  \__/  \__/d \
     * /  \__/H \__/  \__/  \__/  \__/
     * \__/S \__/I \__/  \__/  \__/e \
     * /R \__/B \__/J \__/  \__/  \__/
     * \__/G \__/C \__/  \__/  \__/  \
     * /Q \__/A \__/K \__/  \__/  \__/
     * \__/F \__/D \__/  \__/  \__/  \
     * /P \__/E \__/L \__/  \__/  \__/
     * \__/O \__/M \__/  \__/  \__/  \
     * /  \__/N \__/  \__/  \__/  \__/
     * \__/  \__/  \__/  \__/  \__/  \
     *    \__/  \__/  \__/  \__/  \__/
     *
     * (Yes, this was tedious to type up, but a picture is worth a thousand words, right?
     */
    geometry = [[HXMGeometry alloc] initWithLongGrain:NO firstColumnIsLong:NO numRows:7 numColumns:10];
    map = [[HXMMap alloc] initWithGeometry:geometry];
}

- (void)testLegal {
    // Obviouly wrong, as both coordinates are illegal
    STAssertFalse( [map isHexOnMap:HXMHexMake(-1, -1)], nil );
    STAssertFalse( [map isHexOnMap:HXMHexMake(10, 10)], nil );
    
    // Obviously wrong as one coordinate is illegal
    STAssertFalse( [map isHexOnMap:HXMHexMake(-1,  4)], nil );
    STAssertFalse( [map isHexOnMap:HXMHexMake( 4, -1)], nil );
    STAssertFalse( [map isHexOnMap:HXMHexMake(10,  4)], nil );
    STAssertFalse( [map isHexOnMap:HXMHexMake( 4, 10)], nil );
    
    // Check the top, bottom, and one past the bottom of the first column
    STAssertTrue(  [map isHexOnMap:HXMHexMake( 0,  0)], nil );
    STAssertTrue(  [map isHexOnMap:HXMHexMake( 0,  6)], nil );
    STAssertFalse( [map isHexOnMap:HXMHexMake( 0,  7)], nil );  // would be true if firstColumnIsLong:YES
    
    // Check the extra row and one past the extra row at the bottom of the second column
    STAssertTrue(  [map isHexOnMap:HXMHexMake( 1,  6)], nil );
    STAssertTrue(  [map isHexOnMap:HXMHexMake( 1,  7)], nil );  // because firstColumnIsLong:NO, so second column is long
    STAssertFalse( [map isHexOnMap:HXMHexMake( 1,  8)], nil );
    
    // Check the top, bottom, and one past the bottom of the penultimate column
    STAssertTrue(  [map isHexOnMap:HXMHexMake( 8,  0)], nil );
    STAssertTrue(  [map isHexOnMap:HXMHexMake( 8,  6)], nil );
    STAssertFalse( [map isHexOnMap:HXMHexMake( 8,  7)], nil );  // would be true if firstColumnIsLong:YES
    
    // Check the top and bottom of the last column
    STAssertTrue(  [map isHexOnMap:HXMHexMake( 9,  0)], nil );
    STAssertTrue(  [map isHexOnMap:HXMHexMake( 9,  7)], nil );
    STAssertFalse( [map isHexOnMap:HXMHexMake( 9,  8)], nil );
}

- (void)testDirection {
    HXMHex hA= HXMHexMake(2, 4); HXMHex hB= HXMHexMake(2, 3); HXMHex hC= HXMHexMake(3, 4); HXMHex hD= HXMHexMake(3, 5);
    HXMHex hE= HXMHexMake(2, 5); HXMHex hF= HXMHexMake(1, 5); HXMHex hG= HXMHexMake(1, 4); HXMHex hH= HXMHexMake(2, 2);
    HXMHex hI= HXMHexMake(3, 3); HXMHex hJ= HXMHexMake(4, 3); HXMHex hK= HXMHexMake(4, 4); HXMHex hL= HXMHexMake(4, 5);
    HXMHex hM= HXMHexMake(3, 6); HXMHex hN= HXMHexMake(2, 6); HXMHex hO= HXMHexMake(1, 6); HXMHex hP= HXMHexMake(0, 5);
    HXMHex hQ= HXMHexMake(0, 4); HXMHex hR= HXMHexMake(0, 3); HXMHex hS= HXMHexMake(1, 3);
                                                              HXMHex hW= HXMHexMake(4, 0); HXMHex hX= HXMHexMake(5, 0);
    HXMHex hY= HXMHexMake(6, 0);                              HXMHex ha= HXMHexMake(8, 0); HXMHex hb= HXMHexMake(9, 0);
    HXMHex hc= HXMHexMake(9, 1); HXMHex hd= HXMHexMake(9, 2); HXMHex he= HXMHexMake(9, 3);

    // Same hex
    STAssertEquals([map directionFrom:hA to:hA], 0, nil);
    
    // Adjacent hexes
    STAssertEquals([map directionFrom:hA to:hB], 0, nil);
    STAssertEquals([map directionFrom:hA to:hC], 1, nil);
    STAssertEquals([map directionFrom:hA to:hD], 2, nil);
    STAssertEquals([map directionFrom:hA to:hE], 3, nil);
    STAssertEquals([map directionFrom:hA to:hF], 4, nil);
    STAssertEquals([map directionFrom:hA to:hG], 5, nil);
    
    // Two hexes away
    STAssertEquals([map directionFrom:hA to:hH], 0, nil);
    STAssertEquals([map directionFrom:hA to:hI], 0, nil);
    STAssertEquals([map directionFrom:hA to:hJ], 1, nil);
    STAssertEquals([map directionFrom:hA to:hK], 1, nil);
    STAssertEquals([map directionFrom:hA to:hL], 2, nil);
    STAssertEquals([map directionFrom:hA to:hM], 3, nil);
    STAssertEquals([map directionFrom:hA to:hN], 3, nil);
    STAssertEquals([map directionFrom:hA to:hO], 3, nil);
    STAssertEquals([map directionFrom:hA to:hP], 4, nil);
    STAssertEquals([map directionFrom:hA to:hQ], 5, nil);
    STAssertEquals([map directionFrom:hA to:hR], 5, nil);
    STAssertEquals([map directionFrom:hA to:hS], 0, nil);
    
    // Other spot tests
    STAssertEquals([map directionFrom:hA to:hW], 0, nil);
    STAssertEquals([map directionFrom:hA to:hX], 0, nil);
    STAssertEquals([map directionFrom:hA to:hY], 0, nil);
    STAssertEquals([map directionFrom:hA to:ha], 1, nil);
    STAssertEquals([map directionFrom:hA to:hb], 1, nil);
    STAssertEquals([map directionFrom:hA to:hc], 1, nil);
    STAssertEquals([map directionFrom:hA to:hd], 1, nil);
    STAssertEquals([map directionFrom:hA to:he], 1, nil);
    STAssertEquals([map directionFrom:hS to:he], 1, nil);  // horizontal
}

- (void)testAdjacent {
    HXMHex hA= HXMHexMake(2, 4); HXMHex hB= HXMHexMake(2, 3); HXMHex hC= HXMHexMake(3, 4); HXMHex hD= HXMHexMake(3, 5);
    HXMHex hE= HXMHexMake(2, 5); HXMHex hF= HXMHexMake(1, 5); HXMHex hG= HXMHexMake(1, 4);
    HXMHex hI= HXMHexMake(3, 3); HXMHex hJ= HXMHexMake(4, 3); HXMHex hK= HXMHexMake(4, 4);
    
    STAssertEquals([map hexAdjacentTo:hA inDirection:0], hB, nil);
    STAssertEquals([map hexAdjacentTo:hA inDirection:1], hC, nil);
    STAssertEquals([map hexAdjacentTo:hA inDirection:2], hD, nil);
    STAssertEquals([map hexAdjacentTo:hA inDirection:3], hE, nil);
    STAssertEquals([map hexAdjacentTo:hA inDirection:4], hF, nil);
    STAssertEquals([map hexAdjacentTo:hA inDirection:5], hG, nil);
    
    STAssertEquals([map hexAdjacentTo:hC inDirection:0], hI, nil);
    STAssertEquals([map hexAdjacentTo:hC inDirection:1], hJ, nil);
    STAssertEquals([map hexAdjacentTo:hC inDirection:2], hK, nil);
    STAssertEquals([map hexAdjacentTo:hC inDirection:3], hD, nil);
    STAssertEquals([map hexAdjacentTo:hC inDirection:4], hA, nil);
    STAssertEquals([map hexAdjacentTo:hC inDirection:5], hB, nil);
}

- (void)testDistance {
    HXMHex hA= HXMHexMake(2, 4); HXMHex hB= HXMHexMake(2, 3); HXMHex hC= HXMHexMake(3, 4); HXMHex hD= HXMHexMake(3, 5);
    HXMHex hE= HXMHexMake(2, 5); HXMHex hF= HXMHexMake(1, 5); HXMHex hG= HXMHexMake(1, 4); HXMHex hH= HXMHexMake(2, 2);
    HXMHex hI= HXMHexMake(3, 3); HXMHex hJ= HXMHexMake(4, 3); HXMHex hK= HXMHexMake(4, 4); HXMHex hL= HXMHexMake(4, 5);
    HXMHex hM= HXMHexMake(3, 6); HXMHex hN= HXMHexMake(2, 6); HXMHex hO= HXMHexMake(1, 6); HXMHex hP= HXMHexMake(0, 5);
    HXMHex hQ= HXMHexMake(0, 4); HXMHex hR= HXMHexMake(0, 3); HXMHex hS= HXMHexMake(1, 3); HXMHex hT= HXMHexMake(2, 1);
    HXMHex hU= HXMHexMake(3, 1); HXMHex hV= HXMHexMake(3, 0); HXMHex hW= HXMHexMake(4, 0); HXMHex hX= HXMHexMake(5, 0);
    HXMHex hY= HXMHexMake(6, 0); HXMHex hZ= HXMHexMake(7, 0); HXMHex ha= HXMHexMake(8, 0); HXMHex hb= HXMHexMake(9, 0);
    HXMHex hc= HXMHexMake(9, 1); HXMHex hd= HXMHexMake(9, 2); HXMHex he= HXMHexMake(9, 3);
    
    STAssertEquals([map distanceFrom:hA to:hA], 0, nil);
    
    STAssertEquals([map distanceFrom:hA to:hB], 1, nil);
    STAssertEquals([map distanceFrom:hA to:hC], 1, nil);
    STAssertEquals([map distanceFrom:hA to:hD], 1, nil);
    STAssertEquals([map distanceFrom:hA to:hE], 1, nil);
    STAssertEquals([map distanceFrom:hA to:hF], 1, nil);
    STAssertEquals([map distanceFrom:hA to:hG], 1, nil);
    
    STAssertEquals([map distanceFrom:hC to:hJ], 1, nil);
    
    STAssertEquals([map distanceFrom:hA to:hH], 2, nil);
    STAssertEquals([map distanceFrom:hA to:hI], 2, nil);
    STAssertEquals([map distanceFrom:hA to:hJ], 2, nil);
    STAssertEquals([map distanceFrom:hA to:hK], 2, nil);
    STAssertEquals([map distanceFrom:hA to:hL], 2, nil);
    STAssertEquals([map distanceFrom:hA to:hM], 2, nil);
    STAssertEquals([map distanceFrom:hA to:hN], 2, nil);
    STAssertEquals([map distanceFrom:hA to:hO], 2, nil);
    STAssertEquals([map distanceFrom:hA to:hP], 2, nil);
    STAssertEquals([map distanceFrom:hA to:hQ], 2, nil);
    STAssertEquals([map distanceFrom:hA to:hR], 2, nil);
    STAssertEquals([map distanceFrom:hA to:hS], 2, nil);
    
    STAssertEquals([map distanceFrom:hA to:hT], 3, nil);
    STAssertEquals([map distanceFrom:hA to:hU], 4, nil);
    STAssertEquals([map distanceFrom:hA to:hV], 5, nil);
    STAssertEquals([map distanceFrom:hA to:hW], 5, nil);
    STAssertEquals([map distanceFrom:hA to:hX], 6, nil);
    STAssertEquals([map distanceFrom:hA to:hY], 6, nil);
    STAssertEquals([map distanceFrom:hA to:hZ], 7, nil);
    STAssertEquals([map distanceFrom:hA to:ha], 7, nil);
    STAssertEquals([map distanceFrom:hA to:hb], 8, nil);
    STAssertEquals([map distanceFrom:hA to:hc], 7, nil);
    STAssertEquals([map distanceFrom:hA to:hd], 7, nil);
    STAssertEquals([map distanceFrom:hA to:he], 7, nil);
}

@end

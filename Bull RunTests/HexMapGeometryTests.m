//
//  HexMapGeometryTests.m
//  Bull Run
//
//  Created by Dave Townsend on 1/9/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "HexMapGeometryTests.h"
#import "HMGeometry.h"

static HMGeometry* geometry;

@implementation HexMapGeometryTests

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
    geometry = [[HMGeometry alloc] initWithLongGrain:NO firstColumnIsLong:NO numRows:7 numColumns:10];
}

- (void)testLegal {
    // Obviouly wrong, as both coordinates are illegal
    STAssertFalse( [geometry legal:HMHexMake(-1, -1)], nil );
    STAssertFalse( [geometry legal:HMHexMake(10, 10)], nil );
    
    // Obviously wrong as one coordinate is illegal
    STAssertFalse( [geometry legal:HMHexMake(-1,  4)], nil );
    STAssertFalse( [geometry legal:HMHexMake( 4, -1)], nil );
    STAssertFalse( [geometry legal:HMHexMake(10,  4)], nil );
    STAssertFalse( [geometry legal:HMHexMake( 4, 10)], nil );
    
    // Check the top, bottom, and one past the bottom of the first column
    STAssertTrue(  [geometry legal:HMHexMake( 0,  0)], nil );
    STAssertTrue(  [geometry legal:HMHexMake( 0,  6)], nil );
    STAssertFalse( [geometry legal:HMHexMake( 0,  7)], nil );  // would be true if firstColumnIsLong:YES
    
    // Check the extra row and one past the extra row at the bottom of the second column
    STAssertTrue(  [geometry legal:HMHexMake( 1,  6)], nil );
    STAssertTrue(  [geometry legal:HMHexMake( 1,  7)], nil );  // because firstColumnIsLong:NO, so second column is long
    STAssertFalse( [geometry legal:HMHexMake( 1,  8)], nil );
    
    // Check the top, bottom, and one past the bottom of the penultimate column
    STAssertTrue(  [geometry legal:HMHexMake( 8,  0)], nil );
    STAssertTrue(  [geometry legal:HMHexMake( 8,  6)], nil );
    STAssertFalse( [geometry legal:HMHexMake( 8,  7)], nil );  // would be true if firstColumnIsLong:YES
    
    // Check the top and bottom of the last column
    STAssertTrue(  [geometry legal:HMHexMake( 9,  0)], nil );
    STAssertTrue(  [geometry legal:HMHexMake( 9,  7)], nil );
    STAssertFalse( [geometry legal:HMHexMake( 9,  8)], nil );
}

- (void)testDirection {
    HMHex hA= HMHexMake(2, 4); HMHex hB= HMHexMake(2, 3); HMHex hC= HMHexMake(3, 4); HMHex hD= HMHexMake(3, 5);
    HMHex hE= HMHexMake(2, 5); HMHex hF= HMHexMake(1, 5); HMHex hG= HMHexMake(1, 4); HMHex hH= HMHexMake(2, 2);
    HMHex hI= HMHexMake(3, 3); HMHex hJ= HMHexMake(4, 3); HMHex hK= HMHexMake(4, 4); HMHex hL= HMHexMake(4, 5);
    HMHex hM= HMHexMake(3, 6); HMHex hN= HMHexMake(2, 6); HMHex hO= HMHexMake(1, 6); HMHex hP= HMHexMake(0, 5);
    HMHex hQ= HMHexMake(0, 4); HMHex hR= HMHexMake(0, 3); HMHex hS= HMHexMake(1, 3);
                                                          HMHex hW= HMHexMake(4, 0); HMHex hX= HMHexMake(5, 0);
    HMHex hY= HMHexMake(6, 0);                            HMHex ha= HMHexMake(8, 0); HMHex hb= HMHexMake(9, 0);
    HMHex hc= HMHexMake(9, 1); HMHex hd= HMHexMake(9, 2); HMHex he= HMHexMake(9, 3);

    // Same hex
    STAssertEquals([geometry directionFrom:hA to:hA], 0, nil);
    
    // Adjacent hexes
    STAssertEquals([geometry directionFrom:hA to:hB], 0, nil);
    STAssertEquals([geometry directionFrom:hA to:hC], 1, nil);
    STAssertEquals([geometry directionFrom:hA to:hD], 2, nil);
    STAssertEquals([geometry directionFrom:hA to:hE], 3, nil);
    STAssertEquals([geometry directionFrom:hA to:hF], 4, nil);
    STAssertEquals([geometry directionFrom:hA to:hG], 5, nil);
    
    // Two hexes away
    STAssertEquals([geometry directionFrom:hA to:hH], 0, nil);
    STAssertEquals([geometry directionFrom:hA to:hI], 0, nil);
    STAssertEquals([geometry directionFrom:hA to:hJ], 1, nil);
    STAssertEquals([geometry directionFrom:hA to:hK], 1, nil);
    STAssertEquals([geometry directionFrom:hA to:hL], 2, nil);
    STAssertEquals([geometry directionFrom:hA to:hM], 3, nil);
    STAssertEquals([geometry directionFrom:hA to:hN], 3, nil);
    STAssertEquals([geometry directionFrom:hA to:hO], 3, nil);
    STAssertEquals([geometry directionFrom:hA to:hP], 4, nil);
    STAssertEquals([geometry directionFrom:hA to:hQ], 5, nil);
    STAssertEquals([geometry directionFrom:hA to:hR], 5, nil);
    STAssertEquals([geometry directionFrom:hA to:hS], 0, nil);
    
    // Other spot tests
    STAssertEquals([geometry directionFrom:hA to:hW], 0, nil);
    STAssertEquals([geometry directionFrom:hA to:hX], 0, nil);
    STAssertEquals([geometry directionFrom:hA to:hY], 0, nil);
    STAssertEquals([geometry directionFrom:hA to:ha], 1, nil);
    STAssertEquals([geometry directionFrom:hA to:hb], 1, nil);
    STAssertEquals([geometry directionFrom:hA to:hc], 1, nil);
    STAssertEquals([geometry directionFrom:hA to:hd], 1, nil);
    STAssertEquals([geometry directionFrom:hA to:he], 1, nil);
    STAssertEquals([geometry directionFrom:hS to:he], 1, nil);  // horizontal
}

- (void)test {
    HMHex hA= HMHexMake(2, 4); HMHex hB= HMHexMake(2, 3); HMHex hC= HMHexMake(3, 4); HMHex hD= HMHexMake(3, 5);
    HMHex hE= HMHexMake(2, 5); HMHex hF= HMHexMake(1, 5); HMHex hG= HMHexMake(1, 4);
    HMHex hI= HMHexMake(3, 3); HMHex hJ= HMHexMake(4, 3); HMHex hK= HMHexMake(4, 4);
    
    STAssertEquals([geometry hexAdjacentTo:hA inDirection:0], hB, nil);
    STAssertEquals([geometry hexAdjacentTo:hA inDirection:1], hC, nil);
    STAssertEquals([geometry hexAdjacentTo:hA inDirection:2], hD, nil);
    STAssertEquals([geometry hexAdjacentTo:hA inDirection:3], hE, nil);
    STAssertEquals([geometry hexAdjacentTo:hA inDirection:4], hF, nil);
    STAssertEquals([geometry hexAdjacentTo:hA inDirection:5], hG, nil);
    
    STAssertEquals([geometry hexAdjacentTo:hC inDirection:0], hI, nil);
    STAssertEquals([geometry hexAdjacentTo:hC inDirection:1], hJ, nil);
    STAssertEquals([geometry hexAdjacentTo:hC inDirection:2], hK, nil);
    STAssertEquals([geometry hexAdjacentTo:hC inDirection:3], hD, nil);
    STAssertEquals([geometry hexAdjacentTo:hC inDirection:4], hA, nil);
    STAssertEquals([geometry hexAdjacentTo:hC inDirection:5], hB, nil);
}

- (void)testDistance {
    HMHex hA= HMHexMake(2, 4); HMHex hB= HMHexMake(2, 3); HMHex hC= HMHexMake(3, 4); HMHex hD= HMHexMake(3, 5);
    HMHex hE= HMHexMake(2, 5); HMHex hF= HMHexMake(1, 5); HMHex hG= HMHexMake(1, 4); HMHex hH= HMHexMake(2, 2);
    HMHex hI= HMHexMake(3, 3); HMHex hJ= HMHexMake(4, 3); HMHex hK= HMHexMake(4, 4); HMHex hL= HMHexMake(4, 5);
    HMHex hM= HMHexMake(3, 6); HMHex hN= HMHexMake(2, 6); HMHex hO= HMHexMake(1, 6); HMHex hP= HMHexMake(0, 5);
    HMHex hQ= HMHexMake(0, 4); HMHex hR= HMHexMake(0, 3); HMHex hS= HMHexMake(1, 3); HMHex hT= HMHexMake(2, 1);
    HMHex hU= HMHexMake(3, 1); HMHex hV= HMHexMake(3, 0); HMHex hW= HMHexMake(4, 0); HMHex hX= HMHexMake(5, 0);
    HMHex hY= HMHexMake(6, 0); HMHex hZ= HMHexMake(7, 0); HMHex ha= HMHexMake(8, 0); HMHex hb= HMHexMake(9, 0);
    HMHex hc= HMHexMake(9, 1); HMHex hd= HMHexMake(9, 2); HMHex he= HMHexMake(9, 3);
    
    STAssertEquals([geometry distanceFrom:hA to:hA], 0, nil);
    
    STAssertEquals([geometry distanceFrom:hA to:hB], 1, nil);
    STAssertEquals([geometry distanceFrom:hA to:hC], 1, nil);
    STAssertEquals([geometry distanceFrom:hA to:hD], 1, nil);
    STAssertEquals([geometry distanceFrom:hA to:hE], 1, nil);
    STAssertEquals([geometry distanceFrom:hA to:hF], 1, nil);
    STAssertEquals([geometry distanceFrom:hA to:hG], 1, nil);
    
    STAssertEquals([geometry distanceFrom:hC to:hJ], 1, nil);
    
    STAssertEquals([geometry distanceFrom:hA to:hH], 2, nil);
    STAssertEquals([geometry distanceFrom:hA to:hI], 2, nil);
    STAssertEquals([geometry distanceFrom:hA to:hJ], 2, nil);
    STAssertEquals([geometry distanceFrom:hA to:hK], 2, nil);
    STAssertEquals([geometry distanceFrom:hA to:hL], 2, nil);
    STAssertEquals([geometry distanceFrom:hA to:hM], 2, nil);
    STAssertEquals([geometry distanceFrom:hA to:hN], 2, nil);
    STAssertEquals([geometry distanceFrom:hA to:hO], 2, nil);
    STAssertEquals([geometry distanceFrom:hA to:hP], 2, nil);
    STAssertEquals([geometry distanceFrom:hA to:hQ], 2, nil);
    STAssertEquals([geometry distanceFrom:hA to:hR], 2, nil);
    STAssertEquals([geometry distanceFrom:hA to:hS], 2, nil);
    
    STAssertEquals([geometry distanceFrom:hA to:hT], 3, nil);
    STAssertEquals([geometry distanceFrom:hA to:hU], 4, nil);
    STAssertEquals([geometry distanceFrom:hA to:hV], 5, nil);
    STAssertEquals([geometry distanceFrom:hA to:hW], 5, nil);
    STAssertEquals([geometry distanceFrom:hA to:hX], 6, nil);
    STAssertEquals([geometry distanceFrom:hA to:hY], 6, nil);
    STAssertEquals([geometry distanceFrom:hA to:hZ], 7, nil);
    STAssertEquals([geometry distanceFrom:hA to:ha], 7, nil);
    STAssertEquals([geometry distanceFrom:hA to:hb], 8, nil);
    STAssertEquals([geometry distanceFrom:hA to:hc], 7, nil);
    STAssertEquals([geometry distanceFrom:hA to:hd], 7, nil);
    STAssertEquals([geometry distanceFrom:hA to:he], 7, nil);
}

@end

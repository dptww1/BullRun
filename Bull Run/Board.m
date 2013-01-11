//
//  Board.m
//  Bull Run
//
//  Created by Dave Townsend on 1/11/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "Board.h"
#import "HexMapGeometry.h"

@implementation Board

- (id)init {
    self = [super init];
    
    if (self) {
        _geometry = [[HexMapGeometry alloc] initWithLongGrain:NO
                                            firstColumnIsLong:NO
                                                      numRows:13
                                                   numColumns:17];
    }
    
    return self;
    
}

@end

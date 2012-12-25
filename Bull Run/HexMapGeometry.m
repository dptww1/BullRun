//
//  HexMapGeometry.m
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import "HexMapGeometry.h"

@implementation HexMapGeometry

- (id)initWithLongGrain:(BOOL)longGrain firstColumnIsLong:(BOOL)firstColumnIsLong numRows:(int)rows numColumns:(int)columns {
    self = [super init];
    if (self) {
        [self setIsLongGrain:longGrain];
        [self setFirstColumnIsLong:firstColumnIsLong];
        [self setNumRows:rows];
        [self setNumColumns:columns];
    }
    return self;
}

- (BOOL)legal:(Hex)hex {
    return YES;
}

@end

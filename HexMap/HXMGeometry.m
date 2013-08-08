//
//  HXMGeometry.m
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import "HXMGeometry.h"

@implementation HXMGeometry

#pragma mark - Initialization

- (id)initWithLongGrain:(BOOL)longGrain firstColumnIsLong:(BOOL)firstColumnIsLong numRows:(int)rows numColumns:(int)columns {
    self = [super init];
    if (self) {
        _isLongGrain       = longGrain;
        _firstColumnIsLong = firstColumnIsLong;
        _numRows           = rows;
        _numColumns        = columns;
    }
    return self;
}

#pragma mark - NSCoding Implementation

- (void)encodeWithCoder:(NSCoder*)aCoder {
    [aCoder encodeBool:_isLongGrain       forKey:@"isLongGrain"];
    [aCoder encodeBool:_firstColumnIsLong forKey:@"firstColumnIsLong"];
    [aCoder encodeInt:_numRows            forKey:@"numRows"];
    [aCoder encodeInt:_numColumns         forKey:@"numColumns"];
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super init];
    
    if (self) {
        _isLongGrain       = [aDecoder decodeBoolForKey:@"isLongGrain"];
        _firstColumnIsLong = [aDecoder decodeBoolForKey:@"firstColumnIsLong"];
        _numRows           = [aDecoder decodeIntForKey:@"numRows"];
        _numColumns        = [aDecoder decodeIntForKey:@"numColumns"];
    }
    
    return self;
}

@end

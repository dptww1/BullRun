//
//  Hex.m
//  Bull Run
//
//  Created by Dave Townsend on 12/25/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import "Hex.h"

@implementation Hex {
    int _row;
    int _column;
}

- (id)initWithColumn:(int)col row:(int)row {
    self = [super init];
    if (self) {
        _row = row;
        _column = col;
    }
    return self;
}

- (int)row {
    return _row;
}

- (int)column {
    return _column;
}

@end

//
//  BAReinforcementInfo.m
//  Bull Run
//
//  Created by Dave Townsend on 2/20/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BAReinforcementInfo.h"
#import "HMHex.h"
#import "Unit.h"

@implementation BAReinforcementInfo

#pragma mark - NSCoding Implementation

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[self unitName] forKey:@"unitName"];
    [coder encodeInt:[self entryLocation].column forKey:@"column"];
    [coder encodeInt:[self entryLocation].row forKey:@"row"];
    [coder encodeInt:[self entryTurn] forKey:@"turn"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];

    if (self) {
        int col = [coder decodeIntForKey:@"column"];
        int row = [coder decodeIntForKey:@"row"];

        _entryLocation = HMHexMake(col, row);
        _entryTurn = [coder decodeIntForKey:@"turn"];
        _unitName  = [coder decodeObjectForKey:@"unitName"];
    }

    return self;
}

@end

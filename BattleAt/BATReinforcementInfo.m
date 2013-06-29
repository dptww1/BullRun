//
//  BATReinforcementInfo.m
//
//  Created by Dave Townsend on 2/20/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BATReinforcementInfo.h"
#import "BATUnit.h"
#import "HXMHex.h"

@implementation BATReinforcementInfo

#pragma mark - Initialization

+ (BATReinforcementInfo*)createWithUnit:(BATUnit*)unit {
    return [[BATReinforcementInfo alloc] initWithUnit:unit
                                               onTurn:[unit turn]
                                                atHex:[unit location]];
}

- (BATReinforcementInfo*)initWithUnit:(BATUnit*)unit
                               onTurn:(int)turn
                                atHex:(HXMHex)hex {
    self = [super init];

    if (self) {
        _entryLocation = hex;
        _entryTurn     = turn;
        _unitName      = [unit name];
    }

    return self;
}

#pragma mark - NSCoding Implementation

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_unitName forKey:@"unitName"];
    [coder encodeInt:_entryLocation.column forKey:@"column"];
    [coder encodeInt:_entryLocation.row forKey:@"row"];
    [coder encodeInt:_entryTurn forKey:@"turn"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];

    if (self) {
        int col = [coder decodeIntForKey:@"column"];
        int row = [coder decodeIntForKey:@"row"];

        _entryLocation = HXMHexMake(col, row);
        _entryTurn = [coder decodeIntForKey:@"turn"];
        _unitName  = [coder decodeObjectForKey:@"unitName"];
    }

    return self;
}

@end

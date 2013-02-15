//
//  Unit.m
//  Bull Run
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "Unit.h"
#import "MoveOrders.h"

@implementation Unit

#pragma mark - Convenience Methods

- (BOOL)hasOrders {
    return ![self.moveOrders isEmpty];
}

- (BOOL)friends:(Unit *)other {
    return _side == [other side];
}

- (BOOL)isWrecked {
    // How could this happen? Still, guard against division-by-zero errors
    if (self.originalStrength == 0)
        return NO;

    int pctCasualties = 100 - (self.strength * 100 / self.originalStrength);

    return pctCasualties > self.morale;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:   [self imageXIdx]        forKey:@"imageXIdx"];
    [aCoder encodeInt:   [self imageYIdx]        forKey:@"imageYIdx"];
    [aCoder encodeInt:   [self leadership]       forKey:@"leadership"];
    [aCoder encodeInt:   [self mode]             forKey:@"mode"];
    [aCoder encodeInt:   [self morale]           forKey:@"morale"];
    [aCoder encodeInt:   [self mps]              forKey:@"mps"];
    [aCoder encodeObject:[self name]             forKey:@"name"];
    [aCoder encodeInt:   [self originalStrength] forKey:@"originalStrength"];
    [aCoder encodeInt:   [self side]             forKey:@"side"];
    [aCoder encodeInt:   [self strength]         forKey:@"strength"];
    
    // _location is a structure, so needs special handling
    [aCoder encodeInt:   [self location].column  forKey:@"location_column"];
    [aCoder encodeInt:   [self location].row     forKey:@"location_row"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _imageXIdx        = [aDecoder decodeIntForKey:@"imageXIdx"];
        _imageYIdx        = [aDecoder decodeIntForKey:@"imageYIdx"];
        _leadership       = [aDecoder decodeIntForKey:@"leadership"];
        _mode             = [aDecoder decodeIntForKey:@"mode"];
        _morale           = [aDecoder decodeIntForKey:@"morale"];
        _mps              = [aDecoder decodeIntForKey:@"mps"];
        _name             = [aDecoder decodeObjectForKey:@"name"];
        _originalStrength = [aDecoder decodeIntForKey:@"originalStrength"];
        _side             = [aDecoder decodeIntForKey:@"side"];
        _strength         = [aDecoder decodeIntForKey:@"strength"];
        
        // _location is a structure
        int col = [aDecoder decodeIntForKey:@"location_column"];
        int row = [aDecoder decodeIntForKey:@"location_row"];
        _location = HexMake(col, row);
        
        // Initialize non-persistent properties
        _moveOrders = [[MoveOrders alloc] init];
        _sighted    = NO;
    }
    
    return self;
}

@end

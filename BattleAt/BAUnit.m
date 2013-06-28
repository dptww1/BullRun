//
//  BAUnit.m
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BATMoveOrders.h"
#import "BAUnit.h"

@implementation BAUnit

#pragma mark - Convenience Methods

- (BOOL)hasOrders {
    return ![_moveOrders isEmpty];
}

- (BOOL)friends:(BAUnit*)other {
    return _side == [other side];
}

- (BOOL)isWrecked {
    // How could this happen? Still, guard against division-by-zero errors
    if (_originalStrength == 0)
        return NO;

    int pctCasualties = 100 - (_strength * 100 / _originalStrength);

    return pctCasualties > _morale;
}

- (BOOL)isOffMap {
    return _location.column < 0
        || _location.row    < 0;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:   _imageXIdx        forKey:@"imageXIdx"];
    [aCoder encodeInt:   _imageYIdx        forKey:@"imageYIdx"];
    [aCoder encodeInt:   _leadership       forKey:@"leadership"];
    [aCoder encodeInt:   _mode             forKey:@"mode"];
    [aCoder encodeInt:   _morale           forKey:@"morale"];
    [aCoder encodeInt:   _mps              forKey:@"mps"];
    [aCoder encodeObject:_name             forKey:@"name"];
    [aCoder encodeInt:   _originalStrength forKey:@"originalStrength"];
    [aCoder encodeInt:   _side             forKey:@"side"];
    [aCoder encodeInt:   _strength         forKey:@"strength"];
    [aCoder encodeInt:   _turn             forKey:@"turn"];
    
    // _location is a structure, so needs special handling
    [aCoder encodeInt:   _location.column  forKey:@"location_column"];
    [aCoder encodeInt:   _location.row     forKey:@"location_row"];
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
        _turn             = [aDecoder decodeIntForKey:@"turn"];
        
        // _location is a structure
        int col = [aDecoder decodeIntForKey:@"location_column"];
        int row = [aDecoder decodeIntForKey:@"location_row"];
        _location = HXMHexMake(col, row);
        
        // Initialize non-persistent properties
        _moveOrders = [[BATMoveOrders alloc] init];
        _sighted    = NO;
    }
    
    return self;
}

@end

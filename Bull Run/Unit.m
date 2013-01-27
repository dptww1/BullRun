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

#pragma mark - Initializers

- (id)initWithName:(NSString*)name side:(PlayerSide)side leadership:(int)leadership strength:(int)strength morale:(int)morale location:(Hex)hex imageX:(int)xidx imageY:(int)yidx {
    _imageXIdx        = xidx;
    _imageYIdx        = yidx;
    _leadership       = leadership;
    _location         = hex;
    _mode             = DEFEND;
    _morale           = morale;
    _moveOrders       = [[MoveOrders alloc] init];
    _name             = name;
    _originalStrength = strength;
    _side             = side;
    _sighted          = NO;
    _strength         = strength;
    
    return self;
}

#pragma mark - NSCoding

// Untested since not current used, but seems silly to throw it away in case it's needed later
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:_leadership       forKey:@"leadership"];
    [aCoder encodeInt:_morale           forKey:@"morale"];
    [aCoder encodeObject:_name          forKey:@"name"];
    [aCoder encodeInt:_originalStrength forKey:@"originalStrength"];
    [aCoder encodeInt:_side             forKey:@"side"];
    [aCoder encodeInt:_strength         forKey:@"strength"];
    
    // _location is a structure, so needs special handling
    [aCoder encodeInt:_location.column  forKey:@"location_column"];
    [aCoder encodeInt:_location.row     forKey:@"location_row"];
}

// Untested since not current used, but seems silly to throw it away in case it's needed later
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _leadership       = [aDecoder decodeIntForKey:@"leadership"];
        _morale           = [aDecoder decodeIntForKey:@"morale"];
        _name             = [aDecoder decodeObjectForKey:@"name"];
        _originalStrength = [aDecoder decodeIntForKey:@"originalStrength"];
        _side             = [aDecoder decodeIntForKey:@"side"];
        _strength         = [aDecoder decodeIntForKey:@"strength"];
        
        // _location is a structure
        int col = [aDecoder decodeIntForKey:@"location_column"];
        int row = [aDecoder decodeIntForKey:@"location_row"];
        _location = HexMake(col, row);
    }
    
    return self;
}

@end

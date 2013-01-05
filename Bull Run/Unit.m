//
//  Unit.m
//  Bull Run
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "Unit.h"

@implementation Unit

- (id)initWithName:(NSString*)name side:(PlayerSide)side leadership:(int)leadership strength:(int)strength morale:(int)morale location:(Hex)hex {
    _leadership       = leadership;
    _location         = hex;
    _morale           = morale;
    _name             = name;
    _originalStrength = strength;
    _side             = side;
    _strength         = strength;
    
    return self;
}

@end

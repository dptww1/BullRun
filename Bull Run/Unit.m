//
//  Unit.m
//  Bull Run
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "Unit.h"

@implementation Unit

- (id)initWithName:(NSString*)name strength:(int)strength location:(Hex)hex {
    _name = name;
    _originalStrength = _strength = strength;
    _location = hex;
    
    return self;
}

@end

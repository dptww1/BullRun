//
//  UnitView.m
//  Bull Run
//
//  Created by Dave Townsend on 1/16/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "UnitView.h"
#import "Unit.h"

// Key: Unit*  Value: UnitView*
static NSMutableDictionary* unitViewMap = nil;

@implementation UnitView

#pragma mark - Class Methods

+ (UnitView*)createForUnit:(Unit *)unit {
    if (!unitViewMap)
        unitViewMap = [NSMutableDictionary dictionary];
    
    UnitView* uv = [unitViewMap objectForKey:[unit name]];
    
    if (!uv) {
        uv = [[UnitView alloc] initForUnit:unit];
        
        [unitViewMap setObject:uv forKey:[unit name]];
    }
    
    return uv;
}

#pragma mark - Init Methods

// Client code shouldn't call this because it bypasses the cache
- (UnitView*)initForUnit:(Unit*)unit {
    self = [super init];
    
    if (self) {
        [self setBackgroundColor:([unit side] == USA) ? [[UIColor colorWithRed:0.3 green:0.3 blue:0.7 alpha:1.0] CGColor]
                                                      : [[UIColor colorWithRed:0.7 green:0.3 blue:0.3 alpha:1.0] CGColor]];
        [self setBounds:CGRectMake(0.0, 0.0, 30.0, 30.0)];
        [self setShadowColor:[[UIColor blackColor] CGColor]];
        [self setShadowOffset:CGSizeMake(3.0f, 3.0f)];
        [self setShadowRadius:3.0f];
        [self setShadowOpacity:0.8f];
    }
    
    return self;
}

@end

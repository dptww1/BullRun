//
//  UnitView.m
//  Bull Run
//
//  Created by Dave Townsend on 1/16/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BattleAt.h"
#import "UnitView.h"

// Key: BATUnit*  Value: UnitView*
static NSMutableDictionary* unitViewMap = nil;

@implementation UnitView

#pragma mark - Class Methods

+ (UnitView*)viewForUnit:(BATUnit*)unit {
    if (!unitViewMap)
        unitViewMap = [NSMutableDictionary dictionary];
    
    UnitView* uv = unitViewMap[[unit name]];
    
    if (!uv) {
        uv = [[UnitView alloc] initForUnit:unit];
        
        unitViewMap[[unit name]] = uv;
    }
    
    return uv;
}

+ (UnitView*)findByName:(NSString*)unitName {
    return unitViewMap[unitName];
}

#pragma mark - Init Methods

// Client code shouldn't call this because it bypasses the cache
- (UnitView*)initForUnit:(BATUnit*)unit {
    self = [super init];
    
    if (self) {
        [self setBackgroundColor:([unit side] == PLAYER2)
             ? [[UIColor colorWithRed:0.3 green:0.3 blue:0.7 alpha:1.0] CGColor]
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

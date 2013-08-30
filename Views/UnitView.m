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


//==============================================================================
@interface UnitView ()

@property (nonatomic, weak) BATUnit* unit;

@end


//==============================================================================
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

- (void)drawInContext:(CGContextRef)ctx {
    UIGraphicsPushContext(ctx);

    UIColor* fillColor = [_unit side] == kBATPlayerSide2
        ? [UIColor colorWithRed:0.1 green:0.1 blue:0.8 alpha:1.0]
        : [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1.0];

    CGContextSetFillColorWithColor(ctx, [fillColor CGColor]);
    CGContextSetShadowWithColor(ctx, CGSizeMake(3.0f, 3.0f), 3.0f,
                                [[UIColor colorWithRed:.1f green:.1f blue:.1f alpha:0.8f] CGColor]);
    CGContextFillRect(ctx, CGRectMake(8.f, 8.f, 32.f, 32.f));

    UIGraphicsPopContext();
}

#pragma mark - Init Methods

// Client code shouldn't call this because it bypasses the cache
- (UnitView*)initForUnit:(BATUnit*)unit {
    self = [super init];
    
    if (self) {
        [self setBounds:CGRectMake(0.0, 0.0, 51.0, 51.0)];

        CGSize nameSize = [[unit name] sizeWithFont:[UIFont fontWithName:@"GillSans" size:12.0f]];
        nameSize.height += 1.0f;
        nameSize.width  += 1.0f;

        CATextLayer* txt = [[CATextLayer alloc] init];
        [txt setForegroundColor:[[UIColor whiteColor] CGColor]];
        [txt setShadowColor:[[UIColor blackColor] CGColor]];
        [txt setShadowOffset:CGSizeMake(1.0f, 1.0f)];
        [txt setShadowRadius:0.0f];
        [txt setShadowOpacity:1.0f];
        [txt setBounds:CGRectMake(0.0f, 0.0f, nameSize.width, nameSize.height)];
        [txt setString:[unit name]];
        [txt setFontSize:12.0f];
        [txt setFont:@"GillSans"];
        [txt setPosition:CGPointMake((int)([self bounds].size.width / 2.0f),
                                     (int)(51.0f - nameSize.height / 4.0f))];
        [self setSublayers:@[ txt ]];

        [self setHidden:YES];
        
        _unit = unit;
    }

    return self;
}

#pragma mark - Debugging Support

- (NSString*)description {
    return [NSString stringWithFormat:@"UnitView 0x%p %@", self, [_unit name]];
}

@end

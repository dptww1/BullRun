//
//  MapViewController.m
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BullRun.h"
#import "MapViewController.h"
#import "HexMapCoordinateTransformer.h"
#import "InfoBarView.h"
#import "OrderOfBattle.h"
#import "Unit.h"
#import "Game.h"
#import "Board.h"
#import "MapView.h"
#import "UnitView.h"
#import "MoveOrders.h"

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

#pragma mark - Private Methods

@implementation MapViewController (Private)

- (MapView*)getMapView {
    return (MapView*)[self view];
}

- (CGPoint)getHexCenterPoint:(Hex)h {
    CGPoint pt = [[self coordXformer] hexToScreen:h];
    pt.x += [[self coordXformer] hexSize].width  / 2;
    pt.y += [[self coordXformer] hexSize].height / 2;
    return pt;
}

@end

@implementation MapViewController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        _coordXformer = [[HexMapCoordinateTransformer alloc] initWithGeometry:[[game board] geometry]
                                                                       origin:CGPointMake(67, 58)
                                                                      hexSize:CGSizeMake(51, 51)];
        _currentUnit = nil;
        [self setWantsFullScreenLayout:YES];
        
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        [tapRecognizer setNumberOfTapsRequired:2];

        [[self view] addGestureRecognizer:tapRecognizer];
    }
    
    return self;
}

- (void)drawLayer:(CALayer *)theLayer inContext:(CGContextRef)ctx {
    DEBUG_MOVEORDERS(@"drawLayer:inContext:");
    
    if (!_currentUnit)
        return;

    UIGraphicsPushContext(ctx);

    CGContextSetLineWidth(ctx, 7.0);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    // Draw orders all all friendly units other than the current unit
    if (_currentUnit) {
        UIColor* color = [_currentUnit side] == CSA
                            ? [UIColor colorWithRed:0.7f green:0.3f blue:0.3f alpha:0.3f]
                            : [UIColor colorWithRed:0.3f green:0.3f blue:0.7f alpha:0.3f];
        
        for (Unit* u in [[game oob] unitsForSide:[_currentUnit side]]) {
            if (u != _currentUnit)
                [self drawMoveOrdersForUnit:u withColor:color inContext:ctx];
        }
    }
    
    // Draw orders for current unit
    UIColor* color = [_currentUnit side] == CSA
                        ? [UIColor colorWithRed:0.7f green:0.3f blue:0.3f alpha:1.0f]
                        : [UIColor colorWithRed:0.3f green:0.3f blue:0.7f alpha:1.0f];
    [self drawMoveOrdersForUnit:_currentUnit withColor:color inContext:ctx];
    
    UIGraphicsPopContext();
}

- (void)drawMoveOrdersForUnit:(Unit*)unit withColor:(UIColor*)color inContext:(CGContextRef)ctx {
    if (![unit hasOrders])
        return;
    
    CGPoint start = [self getHexCenterPoint:[unit location]];
    CGContextMoveToPoint(ctx, start.x, start.y);
    
    for (int i = 0; i < [[unit moveOrders] numHexes]; ++i) {
        CGPoint p = [self getHexCenterPoint:[[unit moveOrders] hex:i]];
        CGContextAddLineToPoint(ctx, p.x, p.y);
        DEBUG_MOVEORDERS(@"Drawing line for %@ to (%d,%d)", [unit name], (int)p.x, (int)p.y);
    }
    
    CGContextSetStrokeColorWithColor(ctx, [color CGColor]);
    CGContextStrokePath(ctx);
}

#pragma mark - Callbacks

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (Unit* unit in [[game oob] units]) {
        UnitView* v = [UnitView createForUnit:unit];
        if (![v superlayer]) {
            [v setOpacity:0.0f];
            [[[self view] layer] addSublayer:v];
        }
    }
    
    if (!self.animationInfo)
        [self setAnimationInfo:[NSMutableDictionary dictionary]];
    
    if (!_moveOrderLayer) {
        CGRect bounds = [[self view] bounds];
        
        // The sub layer does not seem to inherit the orientation of the parent view, so we have to rotate the bounds,
        // which is equivalent to just exchanging the height and the width;
        float tmp = bounds.size.height;
        bounds.size.height = bounds.size.width;
        bounds.size.width = tmp;
        
        _moveOrderLayer = [CALayer layer];
        [_moveOrderLayer setBounds:bounds];
        [_moveOrderLayer setPosition:CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))];
        [_moveOrderLayer setDelegate:self];
        [_moveOrderLayer setZPosition:100.0f];
        
        [[[self view] layer] addSublayer:_moveOrderLayer];
    }
    
    if (!_infoBarView) {
        NSArray* infoBarObjects = [[NSBundle mainBundle] loadNibNamed:@"InfoBarView" owner:self options:nil];
        
        InfoBarView* v = infoBarObjects[0];
        
        CGSize vSize = [v bounds].size;
        CGSize parentViewSize = [[self view] bounds].size;
        [v setCenter:CGPointMake(parentViewSize.height - vSize.width / 2.0, vSize.height / 2.0)];

        [self setInfoBarView:v];
        
        [[self view] addSubview:v];
        
        [v showInfoForUnit:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doubleTap:(UIGestureRecognizer*)gr {
    DEBUG_MOVEORDERS(@"Double tap!");
    if (_currentUnit) {
        [[_currentUnit moveOrders] clear];
        [[self view] setNeedsDisplay];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch* t in touches) {
        
        CGPoint p = [t locationInView:[self view]];
        
        if (CGRectContainsPoint([[self infoBarView] frame], p)) {
            [[game board] saveToFile:@"map.plist"]; // TODO: REMOVE
            // nothing to do
            
        } else {
            Hex hex = [[self coordXformer] screenToHex:p];
            
            if ([[_coordXformer geometry] legal:hex]) {
                
                NSLog(@"Hex %02d%02d, zones:%@,%@", hex.column, hex.row, [[game board] is:hex inZone:@"csa"] ? @"CSA" : @"", [[game board] is:hex inZone:@"usa"] ? @"USA" : @"");
                //NSLog(@"Touch at screen (%f,%f) hex (%02d%02d) terrain 0x%02x", p.x, p.y, hex.column, hex.row, [[game board] terrainAt:hex]);

                _currentUnit = [[game oob] unitInHex:hex];
                [[self infoBarView] showInfoForUnit:_currentUnit];
                [_moveOrderLayer setNeedsDisplay];
                _givingNewOrders = NO;
            } else {
                //NSLog(@"Touch at screen (%f,%f) isn't a legal hex!", p.x, p.y);
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_currentUnit)
        return;

    for (UITouch* t in touches) {
        Hex h = [_coordXformer screenToHex:[t locationInView:[self view]]];
        
        // Just ignore illegal hexes
        if (![[_coordXformer geometry] legal:h])
            return;
            
        if (!_givingNewOrders && HexEquals([_currentUnit location], h)) {

            // The user may wiggle a finger around in the unit's current hex,
            // in which case just keep showing the existing orders.
            DEBUG_MOVEORDERS(@"Orders for %@: still in same hex", [_currentUnit name]);
                
        } else { // giving and/or continuing new orders
                
            // If this is the first hex outside the unit's current location, then
            // it's time to give new orders.
            if (!_givingNewOrders) {
                [[_currentUnit moveOrders] clear];

                _givingNewOrders = YES;
            }
            
            // Account for backtracking, where h == moveOrders[-2]
            if ([[_currentUnit moveOrders] isBacktrack:h]) {
                DEBUG_MOVEORDERS(@"Orders for %@: BACKTRACK to %02d%02d", [_currentUnit name], h.column, h.row);
                [[_currentUnit moveOrders] backtrack];
            }
            
            // Add this hex on to the end of the list, unless it it's repeat of what's already there
            else if (HexEquals([[_currentUnit moveOrders] lastHex], h)) {
                
                // Don't keep putting on the same hex on the end of the queue
                    
            } else { // it's a new hex
                    
                DEBUG_MOVEORDERS(@"Orders for %@: ADD %02d%02d", [_currentUnit name], h.column, h.row);
                [[_currentUnit moveOrders] addHex:h];
            }

            [_moveOrderLayer setNeedsDisplay];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_currentUnit)
        return;
    
    DEBUG_MOVEORDERS(@"Orders for %@: END", [_currentUnit name]);
    _currentUnit = nil;
    [_moveOrderLayer setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - Battle@ Callbacks

- (void)unitNowHidden:(Unit *)unit {
    DEBUG_SIGHTING(@"MapViewController#unitNowHidden:%@, viewLoaded=%d", [unit name], [self isViewLoaded]);
    
    CALayer* unitLayer = [UnitView createForUnit:unit];

    [unitLayer setOpacity:0.0f];
    
    [[self view] setNeedsDisplay];
}

- (void)unitNowSighted:(Unit *)unit {
    DEBUG_SIGHTING(@"MapViewController#unitNowSighted:%@, viewLoaded=%d", [unit name], [self isViewLoaded]);
    
    CALayer* unitLayer = [UnitView createForUnit:unit];
    
    // Layer might be out of position because didn't begin on map, but disable animations
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [unitLayer setPosition:[self getHexCenterPoint:[unit location]]];
    [CATransaction commit];

    // But animate the opacity
    [unitLayer setOpacity:1.0f];

    [[self view] setNeedsDisplay];
}

- (void)moveUnit:(Unit *)unit to:(Hex)hex {
    DEBUG_MOVEMENT(@"Moving %@ to %02d%02d", [unit name], hex.column, hex.row);
    
    CAKeyframeAnimation* anim = [self.animationInfo objectForKey:[unit name]];
    if (!anim) {  // first animation for this unit
        anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        NSMutableArray* positions = [NSMutableArray array];
        [positions addObject:[NSValue valueWithCGPoint:[self getHexCenterPoint:[unit location]]]];
        [anim setValues:positions];
        [self.animationInfo setObject:anim forKey:[unit name]];
    }
    
    NSMutableArray* positions = [NSMutableArray arrayWithArray:[anim values]];
    [positions addObject:[NSValue valueWithCGPoint:[self getHexCenterPoint:hex]]];
    [anim setValues:positions];

    
    UnitView* v = [UnitView createForUnit:unit];
    CGPoint dest = [self getHexCenterPoint:hex];
    [v setPosition:dest];
}

- (void)movePhaseWillBegin {
    self.animationInfo = [NSMutableDictionary dictionary];
}

- (void)movePhaseDidEnd {
    // Since we want the time-per-hex rate to be constant, we have to scale the animation duration by the
    // number of hexes that the unit is moving through.
    for (NSString* unitName in [self.animationInfo keyEnumerator]) {
        CAKeyframeAnimation* anim = [self.animationInfo objectForKey:unitName];
        [anim setDuration:[[anim values] count] * 0.25];
        [[UnitView findByName:unitName] addAnimation:anim forKey:unitName];
    }
    
    [self.animationInfo removeAllObjects];
}

#pragma mark - Debugging

- (IBAction)playerIsUsa:(id)sender {
    NSLog(@"Now player is USA");
    [game hackUserSide:USA];
    [[self view] setNeedsDisplay];
}

- (IBAction)playerIsCsa:(id)sender {
    NSLog(@"Now player is CSA");
    [game hackUserSide:CSA];
    [[self view] setNeedsDisplay];
}

@end

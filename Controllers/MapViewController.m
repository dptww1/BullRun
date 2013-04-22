//
//  MapViewController.m
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BAAAnimationList.h"
#import "BAAAnimationListItemMove.h"
#import "BAAAnimationListItemCombat.h"
#import "BAAGunfire.h"
#import "BABattleReport.h"
#import "BAGame.h"
#import "BAMoveOrders.h"
#import "BAUnit.h"
#import "BullRun.h"
#import "HMCoordinateTransformer.h"
#import "HMMap.h"
#import "InfoBarView.h"
#import "MapView.h"
#import "MapViewController.h"
#import "SysUtil.h"
#import "UnitView.h"

#pragma mark - Private Methods

@implementation MapViewController (Private)

- (MapView*)getMapView {
    return (MapView*)[self view];
}

@end

@implementation MapViewController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        _coordXformer = [[HMCoordinateTransformer alloc] initWithGeometry:[[game board] geometry]
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
        
        for (BAUnit* u in [[game oob] unitsForSide:[_currentUnit side]]) {
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

- (void)drawMoveOrdersForUnit:(BAUnit*)unit withColor:(UIColor*)color inContext:(CGContextRef)ctx {
    if (![unit hasOrders])
        return;

    BAMoveOrders* mos = [unit moveOrders];

    // Draw orders line
    CGPoint start = [[self coordXformer] hexCenterToScreen:[unit location]];
    CGContextMoveToPoint(ctx, start.x, start.y);
    
    for (int i = 0; i < [mos numHexes]; ++i) {
        CGPoint p = [[self coordXformer] hexCenterToScreen:[mos hex:i]];
        CGContextAddLineToPoint(ctx, p.x, p.y);
        DEBUG_MOVEORDERS(@"Drawing line for %@ to (%d,%d)", [unit name], (int)p.x, (int)p.y);
    }

    CGContextSetStrokeColorWithColor(ctx, [color CGColor]);
    CGContextStrokePath(ctx);

    // Draw arrowhead at end of line
    HMHex endHex = [mos lastHex];
    HMHex penultimateHex = [mos numHexes] == 1 ? [unit location] : [mos hex:[mos numHexes] - 2];
    int dir = [[_coordXformer geometry] directionFrom:penultimateHex to:endHex];

    CGPoint end = [[self coordXformer] hexCenterToScreen:endHex];

    float b = 30.0f;                        // size of the sides of the equilateral triangle
    float sqrt3 = 1.73f;                    // square root of three
    float side2center = sqrt3 * b / 6.0f;   // distance from midpoint of a side to the triangle's center
    float vertex2center = sqrt3 * b / 3.0f; // distance from vertex to the triangle's center

    if (dir & 1) { // 1, 3, 5
        CGContextMoveToPoint(   ctx, end.x,          end.y + vertex2center);
        CGContextAddLineToPoint(ctx, end.x - b/2.0f, end.y - side2center);
        CGContextAddLineToPoint(ctx, end.x + b/2.0f, end.y - side2center);

    } else { // 0, 2, 4
        CGContextMoveToPoint(   ctx, end.x,          end.y - vertex2center);
        CGContextAddLineToPoint(ctx, end.x - b/2.0f, end.y + side2center);
        CGContextAddLineToPoint(ctx, end.x + b/2.0f, end.y + side2center);
    }

    // Without this blend mode, the overlap between the triangle and the movement line
    // is twice as dark when alpha < 1.0f.
    CGContextSetBlendMode(ctx, kCGBlendModeCopy);
    
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextFillPath(ctx);
}

#pragma mark - Callbacks

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (BAUnit* unit in [[game oob] units]) {
        UnitView* v = [UnitView createForUnit:unit];
        if (![v superlayer]) {
            [v setOpacity:0.0f];
            [[[self view] layer] addSublayer:v];
        }
    }
    
    if (!self.animationInfo)
        [self setAnimationInfo:[NSMutableDictionary dictionary]];

    if (!self.animationList)
        [self setAnimationList:[BAAAnimationList listWithCoordXFormer:[self coordXformer]]];
    
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
            HMHex hex = [[self coordXformer] screenToHex:p];
            
            if ([[_coordXformer geometry] legal:hex]) {

                DEBUG_MAP(@"Hex %02d%02d, zones:%@,%@", hex.column, hex.row, [[game board] is:hex inZone:@"csa"] ? @"CSA" : @"", [[game board] is:hex inZone:@"usa"] ? @"USA" : @"");
                DEBUG_MAP(@"   Terrain %@ cost %2.0f",
                          [[game board] terrainAt:hex] ? [[[game board] terrainAt:hex] name] : @"Impassible",
                          [[game board] terrainAt:hex] ? [[[game board] terrainAt:hex] mpCost] : 0);

                _currentUnit = [game unitInHex:hex];
                [[self infoBarView] showInfoForUnit:_currentUnit];
                [_moveOrderLayer setNeedsDisplay];
                _givingNewOrders = NO;
            } else {
                DEBUG_MAP(@"Touch at screen (%f,%f) isn't a legal hex!", p.x, p.y);
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_currentUnit)
        return;

    for (UITouch* t in touches) {
        HMHex h = [_coordXformer screenToHex:[t locationInView:[self view]]];
        
        // Just ignore illegal hexes
        if (![[_coordXformer geometry] legal:h])
            return;
            
        if (!_givingNewOrders && HMHexEquals([_currentUnit location], h)) {

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
            // However, moveOrders don't understand about the unit's current location,
            // so we have to handle backtracking into the original hex as a special case.
            if ([[_currentUnit moveOrders] isBacktrack:h] ||
                ([[_currentUnit moveOrders] numHexes] == 1 && HMHexEquals([_currentUnit location], h))) {

                DEBUG_MOVEORDERS(@"Orders for %@: BACKTRACK to %02d%02d", [_currentUnit name], h.column, h.row);
                [[_currentUnit moveOrders] backtrack];
            }
            
            // Add this hex on to the end of the list, unless it it's repeat of what's already there
            else if (HMHexEquals([[_currentUnit moveOrders] lastHex], h)) {
                
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

- (void)unitNowHidden:(BAUnit*)unit {
    DEBUG_SIGHTING(@"MapViewController#unitNowHidden:%@, viewLoaded=%d", [unit name], [self isViewLoaded]);
    
    CALayer* unitLayer = [UnitView createForUnit:unit];

    [unitLayer setOpacity:0.0f];
    
    [[self view] setNeedsDisplay];
}

- (void)unitNowSighted:(BAUnit*)unit {
    DEBUG_SIGHTING(@"MapViewController#unitNowSighted:%@, viewLoaded=%d", [unit name], [self isViewLoaded]);
    
    CALayer* unitLayer = [UnitView createForUnit:unit];
    
    // Layer might be out of position because didn't begin on map, but disable animations
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [unitLayer setPosition:[[self coordXformer] hexCenterToScreen:[unit location]]];
    [CATransaction commit];

    // But animate the opacity
    [unitLayer setOpacity:1.0f];

    [[self view] setNeedsDisplay];
}

- (void)moveUnit:(BAUnit*)unit to:(HMHex)hex {
    DEBUG_MOVEMENT(@"Moving %@ to %02d%02d", [unit name], hex.column, hex.row);
    [[self animationList] addItem:[BAAAnimationListItemMove itemMoving:unit toHex:hex]];
}

- (void)movePhaseWillBegin {
    [[self animationList] reset];
}

- (void)movePhaseDidEnd {
    [[self animationList] run:^{
        [[self infoBarView] updateCurrentTimeForTurn:[game turn]];
     }];
}

- (void)showAttack:(BABattleReport *)report {
    [[self animationList]
     addItem:[BAAAnimationListItemCombat itemWithAttacker:[report attacker]
                                                 defender:[report defender]
                                                retreatTo:[report retreatHex]
                                                advanceTo:[report advanceHex]]];
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
